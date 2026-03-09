-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - PART 1: TRACKING & STREAM CONSUMPTION
-- ============================================================================

-- ============================================================================
-- SECTION 0: CONFIGURATION TABLES
-- ============================================================================

CREATE OR REPLACE TABLE conf_feature (
    feature VARCHAR(50) PRIMARY KEY,
    description VARCHAR(255)
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

INSERT INTO conf_feature (feature, description)
SELECT 'cf', 'Cash Forecasting'
WHERE NOT EXISTS (SELECT 1 FROM conf_feature WHERE feature = 'cf');

INSERT INTO conf_streams (feature, tablename, extra_source_columns, extra_target_columns, extra_filter_to_records)
SELECT * FROM VALUES
    ('cf', 'prrecord', 'recordtype', 'recordtype', 'recordtype IN (''pp'', ''pi'', ''rp'', ''rr'', ''ro'', ''ri'')'),
    ('cf', 'prentry', 'recordtype', 'recordtype', 'recordtype IN (''pp'', ''pi'', ''rp'', ''rr'', ''ro'', ''ri'')'),
    ('cf', 'customer', NULL, NULL, NULL),
    ('cf', 'vendor', NULL, NULL, NULL),
    ('cf', 'term', 'modulekey', 'module', NULL),
    ('cf', 'location', NULL, NULL, NULL),
    ('cf', 'pymtdetail', NULL, NULL, NULL);

INSERT INTO conf_api_views (feature, viewname, tablename, extra_filter)
SELECT * FROM VALUES
    ('cf', 'accounts_receivable_invoice', 'PRRECORD', 'recordtype IN (''ri'')'),
    ('cf', 'accounts_receivable_invoice_line', 'PRENTRY', 'recordtype IN (''ri'')'),
    ('cf', 'accounts_receivable_payment', 'PRRECORD', 'recordtype IN (''rp'', ''rr'', ''ro'')'),
    ('cf', 'accounts_receivable_payment_line', 'PRENTRY', 'recordtype IN (''rp'', ''rr'', ''ro'')'),
    ('cf', 'accounts_receivable_customer', 'CUSTOMER', NULL),
    ('cf', 'accounts_payable_bill', 'PRRECORD', 'recordtype IN (''pi'')'),
    ('cf', 'accounts_payable_bill_line', 'PRENTRY', 'recordtype IN (''pi'')'),
    ('cf', 'accounts_payable_payment', 'PRRECORD', 'recordtype IN (''pp'')'),
    ('cf', 'accounts_payable_payment_line', 'PRENTRY', 'recordtype IN (''pp'')'),
    ('cf', 'accounts_payable_vendor', 'VENDOR', NULL),
    ('cf', 'accounts_receivable_term', 'TERM', 'module = ''4.AR'''),
    ('cf', 'accounts_payable_term', 'TERM', 'module = ''3.AP'''),
    ('cf', 'company_config_location', 'LOCATION', NULL)
WHERE NOT EXISTS (SELECT 1 FROM conf_api_views WHERE feature = 'cf');

-- ============================================================================
-- SECTION 1: TRACKING TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS cf_upsert_records (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    cny_ VARCHAR(50) NOT NULL,
    record_ VARCHAR(50) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    recordtype VARCHAR(50),
    module VARCHAR(50),
    operation_type CHAR(1) NOT NULL,
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    processed CHAR(1) DEFAULT 'F',
    manifest_file_id NUMBER REFERENCES export_manifest_files(id)
);

CREATE TABLE IF NOT EXISTS cf_delete_records (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    cny_ VARCHAR(50) NOT NULL,
    record_ VARCHAR(50) NOT NULL,
    tablename VARCHAR(50) NOT NULL,
    recordtype VARCHAR(50),
    module VARCHAR(50),
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    processed CHAR(1) DEFAULT 'F',
    manifest_file_id NUMBER REFERENCES export_manifest_files(id)
);

-- ============================================================================
-- SECTION 2: VIEWS AND STREAMS FOR CASHFORECASTING-ENABLED COMPANIES
-- ============================================================================

CREATE OR REPLACE PROCEDURE cf_create_views_and_streams()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_tablename VARCHAR;
    v_view_name VARCHAR;
    v_stream_name VARCHAR;
    v_sql VARCHAR;
    c1 CURSOR FOR SELECT tablename FROM conf_streams WHERE feature = 'cf';
    v_count INTEGER DEFAULT 0;
BEGIN
    OPEN c1;
    FOR rec IN c1 DO
        v_tablename := rec.tablename;
        v_view_name := 'cf_enabled_' || v_tablename;
        v_stream_name := 'cf_enabled_st_' || v_tablename;
        
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
    CLOSE c1;
    
    RETURN 'Created ' || v_count || ' views and streams';
END;
$$;

CALL cf_create_views_and_streams();

-- ============================================================================
-- SECTION 3: PROCEDURE & TASK - CONSUME STREAMS
-- ============================================================================

CREATE OR REPLACE PROCEDURE cf_process_stream_changes()
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
    c1 CURSOR FOR SELECT tablename, extra_source_columns, extra_target_columns, extra_filter_to_records FROM conf_streams WHERE feature = 'cf';
BEGIN
    OPEN c1;
    FOR rec IN c1 DO
        v_tablename := rec.tablename;
        v_stream_name := 'cf_enabled_st_' || v_tablename;
        
        v_extra_col := CASE WHEN rec.extra_target_columns IS NOT NULL THEN ', ' || rec.extra_target_columns ELSE '' END;
        v_extra_val := CASE WHEN rec.extra_source_columns IS NOT NULL THEN ', m1.' || rec.extra_source_columns ELSE '' END;
        v_extra_filter := CASE WHEN rec.extra_filter_to_records IS NOT NULL THEN ' AND m1.' || rec.extra_filter_to_records ELSE '' END;
        
        BEGIN TRANSACTION;
        
        EXECUTE IMMEDIATE 
            'INSERT INTO cf_upsert_records (cny_, record_, tablename' || v_extra_col || ', operation_type) ' ||
            'SELECT m1.cny_, m1.record_, ''' || UPPER(v_tablename) || '''' || v_extra_val || ', ' ||
            'CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN ''U'' ELSE ''I'' END ' ||
            'FROM ' || v_stream_name || ' m1 WHERE m1.METADATA$ACTION = ''INSERT''' || v_extra_filter;
        v_upsert_count := SQLROWCOUNT;
        
        EXECUTE IMMEDIATE 
            'INSERT INTO cf_delete_records (cny_, record_, tablename' || v_extra_col || ') ' ||
            'SELECT m1.cny_, m1.record_, ''' || UPPER(v_tablename) || '''' || v_extra_val || ' ' ||
            'FROM ' || v_stream_name || ' m1 WHERE m1.METADATA$ACTION = ''DELETE'' AND m1.METADATA$ISUPDATE = FALSE' || v_extra_filter;
        v_delete_count := SQLROWCOUNT;
        
        COMMIT;
        
        v_result := v_result || IFF(v_result != '', ', ', '') || UPPER(v_tablename) || '(' || v_upsert_count || ' upserts, ' || v_delete_count || ' deletes)';
    END FOR;
    CLOSE c1;
    
    RETURN 'Processed: ' || v_result;
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
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ROLE_NAME>'
    STORAGE_ALLOWED_LOCATIONS = ('s3://<SAGE_AI_BUCKET>/');

CREATE OR REPLACE STAGE sage_ai_export_stage
    STORAGE_INTEGRATION = sage_ai_s3_integration
    URL = 's3://<SAGE_AI_BUCKET>/exports/'
    FILE_FORMAT = (TYPE = PARQUET);


-- ============================================================================
-- SECTION 3: MANIFEST TRACKING TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS export_dry_run_data (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    manifest_file_id NUMBER NOT NULL REFERENCES export_manifest_files(id),
    csv_data VARCHAR(16777216),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS export_manifest_files (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    export_timestamp TIMESTAMP_NTZ NOT NULL,
    pod_name VARCHAR(50) NOT NULL,
    view_name VARCHAR(100) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    record_count NUMBER,
    export_type VARCHAR(10) NOT NULL,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS pod_registry (
    pod_name VARCHAR(50) PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================================================
-- SECTION 4: PROCEDURE - EXPORT DATA TO S3
-- ============================================================================

CREATE OR REPLACE PROCEDURE cf_export(p_dry_run BOOLEAN DEFAULT FALSE)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_export_timestamp TIMESTAMP_NTZ := DATE_TRUNC('SECOND', CURRENT_TIMESTAMP());
    v_export_timestamp_str VARCHAR := TO_VARCHAR(v_export_timestamp, 'YYYY-MM-DD_HH24:MI:SS');
    v_viewname VARCHAR;
    v_export_name VARCHAR;
    v_tablename VARCHAR;
    v_extra_filter_clause VARCHAR;
    v_base_filter VARCHAR;
    v_cny VARCHAR;
    v_sql VARCHAR;
    v_file_path VARCHAR;
    v_manifest_id NUMBER;
    v_result VARCHAR DEFAULT '';
    res RESULTSET;
    c1 CURSOR FOR SELECT viewname, tablename, extra_filter FROM conf_api_views WHERE feature = 'cf';
BEGIN
    OPEN c1;
    FOR rec IN c1 DO
        v_viewname := rec.viewname;
        v_export_name := UPPER(rec.viewname);
        v_tablename := rec.tablename;
        v_extra_filter_clause := IFF(rec.extra_filter IS NOT NULL, ' AND ' || rec.extra_filter, '');
        v_base_filter := 'tablename = ''' || v_tablename || ''' AND processed = ''F''' || v_extra_filter_clause;
        
        v_sql := 'SELECT DISTINCT cny_ FROM cf_upsert_records WHERE tablename = ''' || v_tablename || ''' AND processed = ''F''' || v_extra_filter_clause;
        res := (EXECUTE IMMEDIATE :v_sql);
        FOR cny_rec IN res DO
            v_cny := cny_rec.cny_;
            v_file_path := 'cash_forecasting/incoming/' || v_cny || '/' || v_export_name || '_UPSERT_' || v_export_timestamp_str || '_';
            
            INSERT INTO export_manifest_files (export_timestamp, pod_name, view_name, file_path, export_type)
            VALUES (:v_export_timestamp, 'cash_forecasting', :v_viewname, :v_file_path, 'UPSERT');
            
            SELECT MAX(id) INTO v_manifest_id FROM export_manifest_files WHERE export_timestamp = :v_export_timestamp AND file_path = :v_file_path;
            
            v_sql := 'UPDATE cf_upsert_records SET processed = ''I'', manifest_file_id = ' || v_manifest_id || 
                     ' WHERE cny_ = ''' || v_cny || ''' AND ' || v_base_filter;
            EXECUTE IMMEDIATE v_sql;
            
            v_sql := 'UPDATE export_manifest_files SET record_count = ' ||
                     '(SELECT COUNT(*) FROM cf_upsert_records WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'') ' ||
                     'WHERE id = ' || v_manifest_id;
            EXECUTE IMMEDIATE v_sql;
            
            IF (p_dry_run) THEN
                v_sql := 'INSERT INTO export_dry_run_data (manifest_file_id, csv_data) ' ||
                         'SELECT ' || v_manifest_id || ', LISTAGG(csv_row, ''\n'') WITHIN GROUP (ORDER BY csv_row) ' ||
                         'FROM (SELECT TO_VARCHAR(OBJECT_CONSTRUCT(*)) AS csv_row FROM ' || v_viewname || ' v ' ||
                         'WHERE v.cnyNumber = ''' || v_cny || ''' ' ||
                         'AND (v.cnyNumber, v.key) IN (SELECT cny_, record_ FROM cf_upsert_records WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'') LIMIT 100)';
            ELSE
                v_sql := 'COPY INTO @sage_ai_export_stage/' || v_file_path || ' ' ||
                         'FROM (SELECT v.* FROM ' || v_viewname || ' v ' ||
                         'WHERE v.cnyNumber = ''' || v_cny || ''' ' ||
                         'AND (v.cnyNumber, v.key) IN (SELECT cny_, record_ FROM cf_upsert_records WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'')) ' ||
                         'INCLUDE_QUERY_ID = FALSE';
            END IF;
            EXECUTE IMMEDIATE v_sql;
        END FOR;
        
        v_sql := 'SELECT DISTINCT cny_ FROM cf_delete_records WHERE tablename = ''' || v_tablename || ''' AND processed = ''F''' || v_extra_filter_clause;
        res := (EXECUTE IMMEDIATE :v_sql);
        FOR cny_rec IN res DO
            v_cny := cny_rec.cny_;
            v_file_path := 'cash_forecasting/incoming/' || v_cny || '/' || v_export_name || '_DELETE_' || v_export_timestamp_str || '_';
            
            INSERT INTO export_manifest_files (export_timestamp, pod_name, view_name, file_path, export_type)
            VALUES (:v_export_timestamp, 'cash_forecasting', :v_viewname, :v_file_path, 'DELETE');
            
            SELECT MAX(id) INTO v_manifest_id FROM export_manifest_files WHERE export_timestamp = :v_export_timestamp AND file_path = :v_file_path;
            
            v_sql := 'UPDATE cf_delete_records SET processed = ''I'', manifest_file_id = ' || v_manifest_id || 
                     ' WHERE cny_ = ''' || v_cny || ''' AND tablename = ''' || v_tablename || ''' AND processed = ''F''' || v_extra_filter_clause;
            EXECUTE IMMEDIATE v_sql;
            
            v_sql := 'UPDATE export_manifest_files SET record_count = ' ||
                     '(SELECT COUNT(*) FROM cf_delete_records WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'') ' ||
                     'WHERE id = ' || v_manifest_id;
            EXECUTE IMMEDIATE v_sql;
            
            IF (p_dry_run) THEN
                v_sql := 'INSERT INTO export_dry_run_data (manifest_file_id, csv_data) ' ||
                         'SELECT ' || v_manifest_id || ', LISTAGG(csv_row, ''\n'') WITHIN GROUP (ORDER BY csv_row) ' ||
                         'FROM (SELECT TO_VARCHAR(OBJECT_CONSTRUCT(*)) AS csv_row FROM cf_delete_records ' ||
                         'WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'' LIMIT 10)';
            ELSE
                v_sql := 'COPY INTO @sage_ai_export_stage/' || v_file_path || ' ' ||
                         'FROM (SELECT cny_, record_, tablename, stream_ts FROM cf_delete_records ' ||
                         'WHERE manifest_file_id = ' || v_manifest_id || ' AND processed = ''I'') ' ||
                         'INCLUDE_QUERY_ID = FALSE';
            END IF;
            EXECUTE IMMEDIATE v_sql;
        END FOR;
        
        v_result := v_result || IFF(v_result != '', ', ', '') || v_viewname;
    END FOR;
    CLOSE c1;
    
    RETURN IFF(p_dry_run, '[DRY RUN] ', '') || 'Exported: ' || v_result;
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
    CALL cf_export(TRUE) INTO v_result;
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
    CALL cf_export(FALSE) INTO v_result;
    RETURN v_result;
END;
$$;

CREATE OR REPLACE TASK task_export_to_s3
    WAREHOUSE = MONITOR_WH
    AFTER task_consume_streams
AS
    CALL cf_export_to_s3();

-- ============================================================================
-- SECTION 5: TASK - CREATE MANIFESTS AND FINALIZE
-- ============================================================================

CREATE OR REPLACE TASK task_create_manifests
    WAREHOUSE = MONITOR_WH
    AFTER task_export_to_s3
AS
DECLARE
    v_export_timestamp TIMESTAMP_NTZ := DATE_TRUNC('SECOND', CURRENT_TIMESTAMP());
    v_export_timestamp_str VARCHAR := TO_VARCHAR(v_export_timestamp, 'YYYY-MM-DD_HH24:MI:SS');
    v_pod_name VARCHAR := '<POD_NAME>';
    v_region VARCHAR := '<REGION>';
    v_manifest_content VARIANT;
    v_all_pods_complete BOOLEAN;
BEGIN
    SELECT OBJECT_CONSTRUCT(
        'export_timestamp', :v_export_timestamp,
        'pod_name', :v_pod_name,
        'region', :v_region,
        'files', ARRAY_AGG(OBJECT_CONSTRUCT(
            'view_name', view_name,
            'file_path', file_path,
            'export_type', export_type,
            'record_count', record_count
        ))
    ) INTO v_manifest_content
    FROM export_manifest_files
    WHERE export_timestamp = :v_export_timestamp AND pod_name = :v_pod_name;

    COPY INTO @sage_ai_export_stage/:v_export_timestamp_str/:v_pod_name/manifest.json
    FROM (SELECT :v_manifest_content)
    FILE_FORMAT = (TYPE = JSON);

    SELECT COUNT(*) = (SELECT COUNT(*) FROM pod_registry WHERE region = :v_region AND is_active = TRUE)
    INTO v_all_pods_complete
    FROM (
        SELECT DISTINCT pod_name 
        FROM export_manifest_files 
        WHERE export_timestamp = :v_export_timestamp
          AND pod_name IN (SELECT pod_name FROM pod_registry WHERE region = :v_region AND is_active = TRUE)
    );

    IF (v_all_pods_complete) THEN
        COPY INTO @sage_ai_export_stage/:v_export_timestamp_str/:v_region/final_manifest.json
        FROM (
            SELECT OBJECT_CONSTRUCT(
                'export_timestamp', :v_export_timestamp,
                'region', :v_region,
                'status', 'COMPLETE',
                'pods', ARRAY_AGG(DISTINCT pod_name),
                'created_at', CURRENT_TIMESTAMP()
            )
            FROM export_manifest_files
            WHERE export_timestamp = :v_export_timestamp
              AND pod_name IN (SELECT pod_name FROM pod_registry WHERE region = :v_region)
        )
        FILE_FORMAT = (TYPE = JSON);
    END IF;

    UPDATE upsert_records SET processed = 'T' WHERE processed = 'I';
    UPDATE delete_records SET processed = 'T' WHERE processed = 'I';
END;

-- ============================================================================
-- SECTION 6: ENABLE TASKS
-- ============================================================================

ALTER TASK task_create_manifests RESUME;
ALTER TASK task_export_to_s3 RESUME;
ALTER TASK task_consume_streams RESUME;

-- ============================================================================
-- SECTION 7: HELPER PROCEDURES
-- ============================================================================

CREATE OR REPLACE PROCEDURE check_region_export_status(p_export_date DATE, p_region VARCHAR)
RETURNS TABLE (pod_name VARCHAR, status VARCHAR)
LANGUAGE SQL
AS
DECLARE
    res RESULTSET;
BEGIN
    res := (
        SELECT 
            pr.pod_name,
            CASE WHEN emf.pod_name IS NOT NULL THEN 'COMPLETE' ELSE 'PENDING' END AS status
        FROM pod_registry pr
        LEFT JOIN (
            SELECT DISTINCT pod_name 
            FROM export_manifest_files 
            WHERE export_timestamp::DATE = :p_export_date
        ) emf ON pr.pod_name = emf.pod_name
        WHERE pr.region = :p_region AND pr.is_active = TRUE
    );
    RETURN TABLE(res);
END;

