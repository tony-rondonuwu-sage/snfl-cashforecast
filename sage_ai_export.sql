-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - PART 1: TRACKING & STREAM CONSUMPTION
-- ============================================================================

-- ============================================================================
-- SECTION 0: CONFIGURATION TABLES
-- ============================================================================

CREATE OR REPLACE TABLE conf_pod (
    pod_name VARCHAR(50) PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    s3_stage VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    total_pods_for_region NUMBER
);

CREATE OR REPLACE TABLE conf_feature (
    feature VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255),
    s3_feature_path VARCHAR(255),
    s3_export_path VARCHAR(255),
    manifest_file_prefix VARCHAR(100)
);

CREATE OR REPLACE TABLE conf_streams (
    feature VARCHAR(50) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    extra_source_columns VARCHAR(500),
    extra_target_columns VARCHAR(500),
    extra_filter_to_records VARCHAR(500),
    PRIMARY KEY (feature, tablename),
    FOREIGN KEY (feature) REFERENCES conf_feature(feature)
);

CREATE OR REPLACE TABLE conf_api_views (
    feature VARCHAR(50) NOT NULL,
    viewname VARCHAR(100) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    extra_filter VARCHAR(500),
    PRIMARY KEY (feature, viewname),
    FOREIGN KEY (feature) REFERENCES conf_feature(feature)
);

INSERT INTO conf_pod (pod_name, region, s3_stage, total_pods_for_region)
SELECT 'p308', 'US', 'sage_ai_export_stage', 2
WHERE NOT EXISTS (SELECT 1 FROM conf_pod WHERE pod_name = 'p308');

INSERT INTO conf_feature (feature, description, s3_feature_path, s3_export_path, manifest_file_prefix)
SELECT 'cf', 'Cash Forecasting', 'cash_forecasting', 'incoming', 'cashflow_data'
WHERE NOT EXISTS (SELECT 1 FROM conf_feature WHERE feature = 'cf');

MERGE INTO conf_streams AS target
USING (
    SELECT * FROM VALUES
        ('cf', 'prrecord', 'recordtype', 'recordtype', 'recordtype IN (''pp'', ''pi'', ''rp'', ''rr'', ''ro'', ''ri'')'),
        ('cf', 'prentry', 'recordtype', 'recordtype', 'recordtype IN (''pp'', ''pi'', ''rp'', ''rr'', ''ro'', ''ri'')'),
        ('cf', 'customer', NULL, NULL, NULL),
        ('cf', 'vendor', NULL, NULL, NULL),
        ('cf', 'term', 'modulekey', 'module', 'modulekey is not null'),
        ('cf', 'location', NULL, NULL, NULL),
        ('cf', 'pymtdetail', 'modulekey', 'module', NULL)
    AS src (feature, tablename, extra_source_columns, extra_target_columns, extra_filter_to_records)
) AS source
ON target.feature = source.feature AND target.tablename = source.tablename
WHEN NOT MATCHED THEN
    INSERT (feature, tablename, extra_source_columns, extra_target_columns, extra_filter_to_records)
    VALUES (source.feature, source.tablename, source.extra_source_columns, source.extra_target_columns, source.extra_filter_to_records);

MERGE INTO conf_api_views AS target
USING (
    SELECT * FROM VALUES
        ('cf', 'accounts_receivable_invoice', 'prrecord', 'recordtype IN (''ri'')'),
        ('cf', 'accounts_receivable_invoice_line', 'prentry', 'recordtype IN (''ri'')'),
        ('cf', 'accounts_receivable_payment', 'prrecord', 'recordtype IN (''rp'', ''rr'', ''ro'')'),
        ('cf', 'accounts_receivable_payment_line', 'prentry', 'recordtype IN (''rp'', ''rr'', ''ro'')'),
        ('cf', 'accounts_receivable_payment_detail', 'pymtdetail', 'module = ''4.AR'''),
        ('cf', 'accounts_receivable_customer', 'customer', NULL),
        ('cf', 'accounts_payable_bill', 'prrecord', 'recordtype IN (''pi'')'),
        ('cf', 'accounts_payable_bill_line', 'prentry', 'recordtype IN (''pi'')'),
        ('cf', 'accounts_payable_payment', 'prrecord', 'recordtype IN (''pp'')'),
        ('cf', 'accounts_payable_payment_line', 'prentry', 'recordtype IN (''pp'')'),
        ('cf', 'accounts_payable_payment_detail', 'pymtdetail', 'module = ''3.AP'''),
        ('cf', 'accounts_payable_vendor', 'vendor', NULL),
        ('cf', 'accounts_receivable_term', 'term', 'module = ''4.AR'''),
        ('cf', 'accounts_payable_term', 'term', 'module = ''3.AP'''),
        ('cf', 'company_config_location', 'location', NULL)
    AS src (feature, viewname, tablename, extra_filter)
) AS source
ON target.feature = source.feature AND target.viewname = source.viewname
WHEN NOT MATCHED THEN
    INSERT (feature, viewname, tablename, extra_filter)
    VALUES (source.feature, source.viewname, source.tablename, source.extra_filter);

-- ============================================================================
-- SECTION 1: EXPORT TRACKING TABLES (must be created before tracking tables)
-- ============================================================================

CREATE OR REPLACE TABLE export_manifest (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    iteration NUMBER NOT NULL,
    export_timestamp TIMESTAMP_NTZ NOT NULL,
    manifest_file_name VARCHAR(255) NOT NULL,
    pod_name VARCHAR(50) NOT NULL,
    feature VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'In-progress',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE export_data_files (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    manifest_file_id NUMBER NOT NULL REFERENCES export_manifest(id),
    view_name VARCHAR(100) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    record_count NUMBER,
    export_type VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'In-progress',
    error_message VARCHAR(2000),
    upsert_record_ids ARRAY,
    delete_record_ids ARRAY,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE export_dry_run_data (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    data_file_id NUMBER NOT NULL REFERENCES export_data_files(id),
    csv_data VARCHAR(16777216),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- SECTION 2: STREAM TRACKING TABLES
-- ============================================================================

CREATE OR REPLACE TABLE cf_upsert_records (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    cny_ VARCHAR(50) NOT NULL,
    record_ VARCHAR(50) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    recordtype VARCHAR(50),
    module VARCHAR(50),
    operation_type CHAR(1) NOT NULL,
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    data_file_id NUMBER REFERENCES export_data_files(id)
);

CREATE OR REPLACE TABLE cf_delete_records (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    cny_ VARCHAR(50) NOT NULL,
    record_ VARCHAR(50) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    recordtype VARCHAR(50),
    module VARCHAR(50),
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    data_file_id NUMBER REFERENCES export_data_files(id)
);

-- ============================================================================
-- SECTION 3: VIEWS AND STREAMS FOR CASHFORECASTING-ENABLED COMPANIES
-- ============================================================================

CREATE OR REPLACE PROCEDURE create_views_and_streams(p_feature VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_tablename VARCHAR;
    v_view_name VARCHAR;
    v_stream_name VARCHAR;
    v_sql VARCHAR;
    v_count INTEGER DEFAULT 0;
    res RESULTSET;
BEGIN
    res := (SELECT tablename FROM conf_streams WHERE feature = :p_feature);
    FOR rec IN res DO
        v_tablename := rec.tablename;
        v_view_name := p_feature || '_enabled_' || v_tablename;
        v_stream_name := p_feature || '_enabled_st_' || v_tablename;
        
        v_sql := 'CREATE VIEW IF NOT EXISTS ' || v_view_name || ' AS ' ||
                 'SELECT m1.* FROM ICRW_SCHEMA.' || v_tablename || ' m1 ' ||
                 'INNER JOIN ICRW_SCHEMA.companypref cp ' ||
                 'ON m1.cny_ = cp.cny_ ' ||
                 'AND cp.property = ''ENABLECASHFLOW'' ' ||
                 'AND cp.value = ''T''';
        EXECUTE IMMEDIATE v_sql;
        
        v_sql := 'CREATE STREAM IF NOT EXISTS ' || v_stream_name || ' ON VIEW ' || v_view_name;
        EXECUTE IMMEDIATE v_sql;
        
        v_count := v_count + 1;
    END FOR;
    
    RETURN 'Created ' || v_count || ' views and streams for feature: ' || p_feature;
END;
$$;

CREATE OR REPLACE PROCEDURE cf_create_views_and_streams()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_result STRING;
BEGIN
    CALL create_views_and_streams('cf') INTO v_result;
    RETURN v_result;
END;
$$;

CALL cf_create_views_and_streams();

-- ============================================================================
-- SECTION 4: PROCEDURE & TASK - CONSUME STREAMS
-- ============================================================================

CREATE OR REPLACE PROCEDURE process_stream_changes(p_feature VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_tablename VARCHAR;
    v_stream_name VARCHAR;
    v_extra_col VARCHAR;
    v_extra_val VARCHAR;
    v_extra_filter VARCHAR;
    v_upsert_count INTEGER;
    v_delete_count INTEGER;
    v_result VARCHAR DEFAULT '';
    v_upsert_table VARCHAR;
    v_delete_table VARCHAR;
    res RESULTSET;
BEGIN
    v_upsert_table := p_feature || '_upsert_records';
    v_delete_table := p_feature || '_delete_records';
    
    res := (SELECT tablename, extra_source_columns, extra_target_columns, extra_filter_to_records FROM conf_streams WHERE feature = :p_feature);
    FOR rec IN res DO
        v_tablename := rec.tablename;
        v_stream_name := p_feature || '_enabled_st_' || v_tablename;
        
        v_extra_col := CASE WHEN rec.extra_target_columns IS NOT NULL THEN ', ' || rec.extra_target_columns ELSE '' END;
        v_extra_val := CASE WHEN rec.extra_source_columns IS NOT NULL THEN ', m1.' || rec.extra_source_columns ELSE '' END;
        v_extra_filter := CASE WHEN rec.extra_filter_to_records IS NOT NULL THEN ' AND m1.' || rec.extra_filter_to_records ELSE '' END;
        
        BEGIN TRANSACTION;
        
        EXECUTE IMMEDIATE 
            'INSERT INTO ' || v_upsert_table || ' (cny_, record_, tablename' || v_extra_col || ', operation_type) ' ||
            'SELECT m1.cny_, m1.record_, ''' || v_tablename || '''' || v_extra_val || ', ' ||
            'CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN ''U'' ELSE ''I'' END ' ||
            'FROM ' || v_stream_name || ' m1 WHERE m1.METADATA$ACTION = ''INSERT''' || v_extra_filter;
        v_upsert_count := SQLROWCOUNT;
        
        EXECUTE IMMEDIATE 
            'INSERT INTO ' || v_delete_table || ' (cny_, record_, tablename' || v_extra_col || ') ' ||
            'SELECT m1.cny_, m1.record_, ''' || v_tablename || '''' || v_extra_val || ' ' ||
            'FROM ' || v_stream_name || ' m1 WHERE m1.METADATA$ACTION = ''DELETE'' AND m1.METADATA$ISUPDATE = FALSE' || v_extra_filter;
        v_delete_count := SQLROWCOUNT;
        
        COMMIT;
        
        v_result := v_result || IFF(v_result != '', ', ', '') || UPPER(v_tablename) || '(' || v_upsert_count || ' upserts, ' || v_delete_count || ' deletes)';
    END FOR;
    
    RETURN 'Processed [' || p_feature || ']: ' || v_result;
END;
$$;

CREATE OR REPLACE PROCEDURE cf_process_stream_changes()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_result STRING;
BEGIN
    CALL process_stream_changes('cf') INTO v_result;
    RETURN v_result;
END;
$$;

CREATE OR REPLACE TASK cf_task_consume_streams
    SCHEDULE = 'USING CRON 1 */4 * * * America/Los_Angeles'
AS
    CALL cf_process_stream_changes();

ALTER TASK cf_task_consume_streams RESUME;



-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - PART 2: STORAGE, EXPORT & MANIFESTS
-- ============================================================================

-- ============================================================================
-- SECTION 1: STORAGE INTEGRATION AND EXTERNAL STAGE
-- ============================================================================

CREATE OR REPLACE STORAGE INTEGRATION sage_ai_s3_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::374322211295:role/ia-dds-snowflake'
    STORAGE_ALLOWED_LOCATIONS = ('s3://sail-mercury-intacct-data-extract-development-eu-west-1/'); 

CREATE OR REPLACE STAGE sage_ai_export_stage
    STORAGE_INTEGRATION = sage_ai_s3_integration
    URL = 's3://sail-mercury-intacct-data-extract-development-eu-west-1/'
    FILE_FORMAT = (TYPE = PARQUET);


-- ============================================================================
-- SECTION 5: PROCEDURE - EXPORT DATA TO S3
-- ============================================================================

CREATE OR REPLACE PROCEDURE export_data(p_feature VARCHAR, p_dry_run BOOLEAN DEFAULT FALSE)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_export_timestamp TIMESTAMP_NTZ := DATE_TRUNC('SECOND', CURRENT_TIMESTAMP());
    v_export_timestamp_str VARCHAR := TO_VARCHAR(v_export_timestamp, 'YYYYMMDDHH24MISS');
    v_export_date DATE := CURRENT_DATE();
    v_iteration NUMBER;
    v_manifest_id NUMBER;
    v_manifest_file_name VARCHAR;
    v_pod_name VARCHAR;
    v_s3_stage VARCHAR;
    v_s3_feature_path VARCHAR;
    v_s3_export_path VARCHAR;
    v_manifest_file_prefix VARCHAR;
    v_viewname VARCHAR;
    v_export_name VARCHAR;
    v_tablename VARCHAR;
    v_extra_filter_clause VARCHAR;
    v_base_filter VARCHAR;
    v_cny VARCHAR;
    v_sql VARCHAR;
    v_file_path VARCHAR;
    v_data_file_id NUMBER;
    v_result VARCHAR DEFAULT '';
    v_debug VARCHAR DEFAULT '';
    v_upsert_table VARCHAR;
    v_delete_table VARCHAR;
    res RESULTSET;
    res2 RESULTSET;
BEGIN
    v_upsert_table := p_feature || '_upsert_records';
    v_delete_table := p_feature || '_delete_records';
    v_debug := '[1] Starting export_data, feature=' || p_feature || ', dry_run=' || IFF(p_dry_run, 'TRUE', 'FALSE') || '\n';
    
    SELECT pod_name, s3_stage INTO v_pod_name, v_s3_stage FROM conf_pod WHERE is_active = TRUE LIMIT 1;
    v_debug := v_debug || '[2] pod_name=' || v_pod_name || ', s3_stage=' || v_s3_stage || '\n';
    
    SELECT s3_feature_path, s3_export_path, manifest_file_prefix INTO v_s3_feature_path, v_s3_export_path, v_manifest_file_prefix FROM conf_feature WHERE feature = :p_feature;
    v_debug := v_debug || '[3] s3_feature_path=' || v_s3_feature_path || ', s3_export_path=' || v_s3_export_path || ', manifest_file_prefix=' || v_manifest_file_prefix || '\n';
    
    SELECT COALESCE(MAX(iteration), 0) + 1 INTO v_iteration 
    FROM export_manifest WHERE date = :v_export_date AND pod_name = :v_pod_name AND feature = :p_feature;
    v_debug := v_debug || '[4] iteration=' || v_iteration || '\n';
    
    v_manifest_file_name := v_pod_name || '.' || v_manifest_file_prefix || '_' || v_export_timestamp_str;
    v_debug := v_debug || '[5] manifest_file_name=' || v_manifest_file_name || '\n';
    
    INSERT INTO export_manifest (date, iteration, export_timestamp, manifest_file_name, pod_name, feature)
    VALUES (:v_export_date, :v_iteration, :v_export_timestamp, :v_manifest_file_name, :v_pod_name, :p_feature);
    v_debug := v_debug || '[6] Inserted into export_manifest\n';
    
    SELECT MAX(id) INTO v_manifest_id FROM export_manifest 
    WHERE export_timestamp = :v_export_timestamp AND pod_name = :v_pod_name AND feature = :p_feature;
    v_debug := v_debug || '[7] manifest_id=' || v_manifest_id || '\n';
    
    res2 := (SELECT viewname, tablename, extra_filter FROM conf_api_views WHERE feature = :p_feature);
    FOR rec IN res2 DO
        v_viewname := rec.viewname;
        v_export_name := UPPER(rec.viewname);
        v_tablename := rec.tablename;
        v_extra_filter_clause := IFF(rec.extra_filter IS NOT NULL, ' AND ' || rec.extra_filter, '');
        v_base_filter := 'tablename = ''' || v_tablename || ''' AND (data_file_id IS NULL OR data_file_id IN (SELECT id FROM export_data_files WHERE status = ''Failed''))' || v_extra_filter_clause;
        v_debug := v_debug || '[8] Processing view=' || v_viewname || ', tablename=' || v_tablename || '\n';
        v_debug := v_debug || '[8a] base_filter=' || v_base_filter || '\n';
        
        v_sql := 'SELECT DISTINCT cny_ FROM ' || v_upsert_table || ' WHERE ' || v_base_filter;
        v_debug := v_debug || '[9] Upsert SQL=' || v_sql || '\n';
        res := (EXECUTE IMMEDIATE :v_sql);
        FOR cny_rec IN res DO
            v_cny := cny_rec.cny_;
            v_file_path := v_s3_feature_path || '/' || v_s3_export_path || '/' || v_cny || '/' || v_export_name || '_UPSERT_' || v_export_timestamp_str || '_';
            v_debug := v_debug || '[10] Processing upsert cny_=' || v_cny || ', file_path=' || v_file_path || '\n';
            
            INSERT INTO export_data_files (manifest_file_id, view_name, file_path, export_type)
            VALUES (:v_manifest_id, :v_viewname, :v_file_path, 'UPSERT');
            
            SELECT MAX(id) INTO v_data_file_id FROM export_data_files WHERE manifest_file_id = :v_manifest_id AND file_path = :v_file_path;
            v_debug := v_debug || '[11] data_file_id=' || v_data_file_id || '\n';
            
            v_sql := 'UPDATE ' || v_upsert_table || ' SET data_file_id = ' || v_data_file_id || 
                     ' WHERE cny_ = ''' || v_cny || ''' AND ' || v_base_filter;
            v_debug := v_debug || '[12] Update upsert SQL=' || v_sql || '\n';
            EXECUTE IMMEDIATE v_sql;
            
            v_sql := 'UPDATE export_data_files SET record_count = ' ||
                     '(SELECT COUNT(*) FROM ' || v_upsert_table || ' WHERE data_file_id = ' || v_data_file_id || ') ' ||
                     'WHERE id = ' || v_data_file_id;
            EXECUTE IMMEDIATE v_sql;
            
            BEGIN
                IF (p_dry_run) THEN
                    v_sql := 'INSERT INTO export_dry_run_data (data_file_id, csv_data) ' ||
                             'SELECT ' || v_data_file_id || ', LISTAGG(csv_row, ''\n'') WITHIN GROUP (ORDER BY csv_row) ' ||
                             'FROM (SELECT TO_VARCHAR(OBJECT_CONSTRUCT(*)) AS csv_row FROM ' || v_viewname || ' v ' ||
                             'WHERE v.cnyNumber = ''' || v_cny || ''' ' ||
                             'AND (TO_NUMBER(v.cnyNumber), TO_NUMBER(v.key)) IN (SELECT cny_, record_ FROM ' || v_upsert_table || ' WHERE data_file_id = ' || v_data_file_id || '))';
                ELSE
                    v_sql := 'COPY INTO @' || v_s3_stage || '/' || v_file_path || ' ' ||
                             'FROM (SELECT v.* FROM ' || v_viewname || ' v ' ||
                             'WHERE v.cnyNumber = ''' || v_cny || ''' ' ||
                             'AND (TO_NUMBER(v.cnyNumber), TO_NUMBER(v.key)) IN (SELECT cny_, record_ FROM ' || v_upsert_table || ' WHERE data_file_id = ' || v_data_file_id || ')) ' ||
                             'MAX_FILE_SIZE = 268435456 ' ||
                             'INCLUDE_QUERY_ID = FALSE';
                END IF;
                v_debug := v_debug || '[13] Export SQL=' || v_sql || '\n';
                EXECUTE IMMEDIATE v_sql;
                UPDATE export_data_files SET status = 'Exported' WHERE id = :v_data_file_id;
                v_debug := v_debug || '[14] Export successful for upsert\n';
            EXCEPTION
                WHEN OTHER THEN
                    v_debug := v_debug || '[14-ERR] Export failed: ' || SQLERRM || '\n';
                    v_sql := 'UPDATE export_data_files SET status = ''Failed'', error_message = ''' || SQLERRM || ''', ' ||
                             'upsert_record_ids = (SELECT ARRAY_AGG(id) FROM ' || v_upsert_table || ' WHERE data_file_id = ' || v_data_file_id || ') ' ||
                             'WHERE id = ' || v_data_file_id;
                    EXECUTE IMMEDIATE v_sql;
            END;
        END FOR;
        
        v_sql := 'SELECT DISTINCT cny_ FROM ' || v_delete_table || ' WHERE ' || v_base_filter;
        v_debug := v_debug || '[15] Delete SQL=' || v_sql || '\n';
        res := (EXECUTE IMMEDIATE :v_sql);
        FOR cny_rec IN res DO
            v_cny := cny_rec.cny_;
            v_file_path := v_s3_feature_path || '/' || v_s3_export_path || '/' || v_cny || '/' || v_export_name || '_DELETE_' || v_export_timestamp_str || '_';
            v_debug := v_debug || '[16] Processing delete cny_=' || v_cny || ', file_path=' || v_file_path || '\n';
            
            INSERT INTO export_data_files (manifest_file_id, view_name, file_path, export_type)
            VALUES (:v_manifest_id, :v_viewname, :v_file_path, 'DELETE');
            
            SELECT MAX(id) INTO v_data_file_id FROM export_data_files WHERE manifest_file_id = :v_manifest_id AND file_path = :v_file_path;
            v_debug := v_debug || '[17] data_file_id=' || v_data_file_id || '\n';
            
            v_sql := 'UPDATE ' || v_delete_table || ' SET data_file_id = ' || v_data_file_id || 
                     ' WHERE cny_ = ''' || v_cny || ''' AND ' || v_base_filter;
            v_debug := v_debug || '[18] Update delete SQL=' || v_sql || '\n';
            EXECUTE IMMEDIATE v_sql;
            
            v_sql := 'UPDATE export_data_files SET record_count = ' ||
                     '(SELECT COUNT(*) FROM ' || v_delete_table || ' WHERE data_file_id = ' || v_data_file_id || ') ' ||
                     'WHERE id = ' || v_data_file_id;
            EXECUTE IMMEDIATE v_sql;
            
            BEGIN
                IF (p_dry_run) THEN
                    v_sql := 'INSERT INTO export_dry_run_data (data_file_id, csv_data) ' ||
                             'SELECT ' || v_data_file_id || ', LISTAGG(csv_row, ''\n'') WITHIN GROUP (ORDER BY csv_row) ' ||
                             'FROM (SELECT TO_VARCHAR(OBJECT_CONSTRUCT(*)) AS csv_row FROM ' || v_delete_table || ' ' ||
                             'WHERE data_file_id = ' || v_data_file_id || ')';
                ELSE
                    v_sql := 'COPY INTO @' || v_s3_stage || '/' || v_file_path || ' ' ||
                             'FROM (SELECT cny_, record_, tablename, stream_ts FROM ' || v_delete_table || ' ' ||
                             'WHERE data_file_id = ' || v_data_file_id || ') ' ||
                             'MAX_FILE_SIZE = 268435456 ' ||
                             'INCLUDE_QUERY_ID = FALSE';
                END IF;
                v_debug := v_debug || '[19] Export SQL=' || v_sql || '\n';
                EXECUTE IMMEDIATE v_sql;
                UPDATE export_data_files SET status = 'Exported' WHERE id = :v_data_file_id;
                v_debug := v_debug || '[20] Export successful for delete\n';
            EXCEPTION
                WHEN OTHER THEN
                    v_debug := v_debug || '[20-ERR] Export failed: ' || SQLERRM || '\n';
                    v_sql := 'UPDATE export_data_files SET status = ''Failed'', error_message = ''' || SQLERRM || ''', ' ||
                             'delete_record_ids = (SELECT ARRAY_AGG(id) FROM ' || v_delete_table || ' WHERE data_file_id = ' || v_data_file_id || ') ' ||
                             'WHERE id = ' || v_data_file_id;
                    EXECUTE IMMEDIATE v_sql;
            END;
        END FOR;
        
        v_result := v_result || IFF(v_result != '', ', ', '') || v_viewname;
    END FOR;
    
    UPDATE export_manifest SET status = 'Completed' WHERE id = :v_manifest_id;
    v_debug := v_debug || '[21] Completed. manifest_id=' || v_manifest_id || '\n';
    
    RETURN IFF(p_dry_run, '[DRY RUN] ', '') || '[' || p_feature || '] Manifest: ' || v_manifest_file_name || ' | Exported: ' || v_result || '\n\n--- DEBUG LOG ---\n' || v_debug;
END;
$$;

CREATE OR REPLACE PROCEDURE cf_export_data(p_dry_run BOOLEAN DEFAULT FALSE)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_result STRING;
BEGIN
    CALL export_data('cf', :p_dry_run) INTO v_result;
    RETURN v_result;
END;
$$;

CREATE OR REPLACE PROCEDURE cf_export_dry_run()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_result STRING;
BEGIN
    CALL cf_export_data(TRUE) INTO v_result;
    RETURN v_result;
END;
$$;

CREATE OR REPLACE PROCEDURE cf_export_to_s3()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_result STRING;
BEGIN
    CALL cf_export_data(FALSE) INTO v_result;
    RETURN v_result;
END;
$$;

CREATE OR REPLACE TASK cf_task_export_to_s3
    WAREHOUSE = MONITOR_WH
    AFTER cf_task_consume_streams
AS
    CALL cf_export_to_s3();

-- ============================================================================
-- SECTION 6: TASK - CREATE MANIFESTS AND FINALIZE
-- ============================================================================

CREATE OR REPLACE PROCEDURE create_manifests(p_feature VARCHAR, p_dry_run BOOLEAN DEFAULT FALSE)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    v_export_date DATE := CURRENT_DATE();
    v_pod_name VARCHAR;
    v_region VARCHAR;
    v_s3_stage VARCHAR;
    v_manifest_file_name VARCHAR;
    v_manifest_file_prefix VARCHAR;
    v_s3_feature_path VARCHAR;
    v_final_manifest_name VARCHAR;
    v_data_file_content VARIANT;
    v_all_pods_complete BOOLEAN;
    v_total_pods_for_region NUMBER;
    v_manifest_count NUMBER DEFAULT 0;
    v_debug VARCHAR DEFAULT '';
    v_sql VARCHAR;
BEGIN
    v_debug := '[1] Starting create_manifests, feature=' || p_feature || ', dry_run=' || IFF(p_dry_run, 'TRUE', 'FALSE') || ', export_date=' || TO_VARCHAR(v_export_date) || '\n';

    SELECT pod_name, region, s3_stage, total_pods_for_region INTO v_pod_name, v_region, v_s3_stage, v_total_pods_for_region FROM conf_pod WHERE is_active = TRUE LIMIT 1;
    v_debug := v_debug || '[2] pod_name=' || v_pod_name || ', region=' || v_region || ', s3_stage=' || v_s3_stage || ', total_pods_for_region=' || v_total_pods_for_region || '\n';

    SELECT s3_feature_path, manifest_file_prefix INTO v_s3_feature_path, v_manifest_file_prefix FROM conf_feature WHERE feature = :p_feature;
    v_debug := v_debug || '[3] s3_feature_path=' || v_s3_feature_path || ', manifest_file_prefix=' || v_manifest_file_prefix || '\n';
    v_final_manifest_name := v_manifest_file_prefix || '_ready_' || TO_VARCHAR(v_export_date, 'YYYYMMDD') || '000001.done';
    v_debug := v_debug || '[4] final_manifest_name=' || v_final_manifest_name || '\n';

    SELECT manifest_file_name INTO v_manifest_file_name
    FROM export_manifest
    WHERE date = :v_export_date AND feature = :p_feature AND pod_name = :v_pod_name
    ORDER BY export_timestamp DESC
    LIMIT 1;
    v_debug := v_debug || '[5] manifest_file_name=' || v_manifest_file_name || '\n';

    SELECT OBJECT_CONSTRUCT(
        'export_date', :v_export_date,
        'pod_name', :v_pod_name,
        'region', :v_region,
        'feature', :p_feature,
        'files', ARRAY_AGG(OBJECT_CONSTRUCT(
            'view_name', edf.view_name,
            'file_path', edf.file_path,
            'export_type', edf.export_type,
            'record_count', edf.record_count
        ))
    ) INTO v_data_file_content
    FROM export_data_files edf
    JOIN export_manifest em ON edf.manifest_file_id = em.id
    WHERE em.date = :v_export_date AND em.feature = :p_feature AND em.pod_name = :v_pod_name;
    v_debug := v_debug || '[6] data_file_content=' || TO_VARCHAR(v_data_file_content) || '\n';

    v_sql := 'COPY INTO @' || v_s3_stage || '/' || v_s3_feature_path || '/' || v_manifest_file_name || '.json ' ||
        'FROM (SELECT PARSE_JSON(''' || TO_VARCHAR(v_data_file_content) || ''')) FILE_FORMAT = (TYPE = JSON) SINGLE = TRUE OVERWRITE = TRUE';
    v_debug := v_debug || '[7] Manifest COPY SQL=' || v_sql || '\n';
    IF (p_dry_run) THEN
        v_debug := v_debug || '[8] DRY RUN - Skipping manifest JSON write to S3\n';
    ELSE
        EXECUTE IMMEDIATE v_sql;
        v_debug := v_debug || '[8] Manifest JSON file written successfully\n';
    END IF;

    v_sql := 'LS @' || v_s3_stage || '/' || v_s3_feature_path || '/ PATTERN=''p.*\\.' || v_manifest_file_prefix || '_' || TO_VARCHAR(v_export_date, 'YYYYMMDD') || '.*\\.json.*''';
    v_debug := v_debug || '[9] LS SQL=' || v_sql || '\n';
    IF (p_dry_run) THEN
        v_manifest_count := 2;
        v_debug := v_debug || '[10] DRY RUN - Skipping LS, manifest_count=0, total_pods_for_region=' || v_total_pods_for_region || '\n';
    ELSE
        EXECUTE IMMEDIATE v_sql;
        SELECT COUNT(*) INTO v_manifest_count FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
        v_debug := v_debug || '[10] manifest_count=' || v_manifest_count || ', total_pods_for_region=' || v_total_pods_for_region || '\n';
    END IF;

    v_all_pods_complete := (v_manifest_count >= v_total_pods_for_region);
    v_debug := v_debug || '[11] all_pods_complete=' || IFF(v_all_pods_complete, 'TRUE', 'FALSE') || '\n';

    IF (v_all_pods_complete) THEN
        BEGIN
            v_sql := 'COPY INTO @' || v_s3_stage || '/' || v_s3_feature_path || '/' || v_final_manifest_name || ' ' ||
                'FROM (SELECT OBJECT_CONSTRUCT(' ||
                '''export_date'', ''' || v_export_date || ''',' ||
                '''region'', ''' || v_region || ''',' ||
                '''feature'', ''' || p_feature || ''',' ||
                '''status'', ''COMPLETE'',' ||
                '''created_at'', CURRENT_TIMESTAMP()' ||
                ')) FILE_FORMAT = (TYPE = JSON) SINGLE = TRUE OVERWRITE = FALSE';
            v_debug := v_debug || '[12] Final manifest COPY SQL=' || v_sql || '\n';
            IF (p_dry_run) THEN
                v_debug := v_debug || '[13] DRY RUN - Skipping final manifest write to S3\n';
            ELSE
                EXECUTE IMMEDIATE v_sql;
                v_debug := v_debug || '[13] Final manifest written successfully\n';
            END IF;
        EXCEPTION
            WHEN OTHER THEN
                v_debug := v_debug || '[13-IGNORED] Final manifest write failed: ' || SQLERRM || '\n';
        END;
    ELSE
        v_debug := v_debug || '[12] Skipping final manifest - not all pods complete\n';
    END IF;

    v_debug := v_debug || '[14] Completed create_manifests\n';
    RETURN IFF(p_dry_run, '[DRY RUN] ', '') || 'Manifest created: ' || v_manifest_file_name || '. All pods complete: ' || v_all_pods_complete || '\n\n--- DEBUG LOG ---\n' || v_debug;
END;

CREATE OR REPLACE TASK cf_task_create_manifests
    WAREHOUSE = MONITOR_WH
    AFTER cf_task_export_to_s3
AS
    CALL create_manifests('cf');

-- ============================================================================
-- SECTION 7: ENABLE TASKS
-- ============================================================================

ALTER TASK cf_task_create_manifests RESUME;
ALTER TASK cf_task_export_to_s3 RESUME;


call cf_export_to_s3();
LS @my_s3_stage/ PATTERN='.*';
