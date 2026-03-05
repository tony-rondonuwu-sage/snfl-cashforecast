-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - PART 1: TRACKING & STREAM CONSUMPTION
-- ============================================================================

-- ============================================================================
-- SECTION 1: TRACKING TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS upserted_record (
    id NUMBER AUTOINCREMENT PRIMARY KEY,
    cny_ NUMBER(15) NOT NULL,
    record_ NUMBER(15) NOT NULL,
    tablename VARCHAR(255) NOT NULL,
    recordtype VARCHAR(10),
    module VARCHAR(50),
    operation_type CHAR(1) NOT NULL,
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS deleted_record (
    cny_ NUMBER(15) NOT NULL,
    record_ NUMBER(15) NOT NULL,
    tablename VARCHAR(255) NOT NULL,
    stream_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);


-- ============================================================================
-- SECTION 2: VIEWS AND STREAMS FOR CASHFORECASTING-ENABLED COMPANIES
-- ============================================================================

-- Views
CREATE OR REPLACE VIEW cf_enabled_prrecord AS
SELECT m1.*
FROM ICRW_SCHEMA.prrecord m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE OR REPLACE VIEW cf_enabled_prentry AS
SELECT m1.*
FROM ICRW_SCHEMA.prentry m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE OR REPLACE VIEW cf_enabled_customer AS
SELECT m1.*
FROM ICRW_SCHEMA.customer m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE OR REPLACE VIEW cf_enabled_vendor AS
SELECT m1.*
FROM ICRW_SCHEMA.vendor m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE OR REPLACE VIEW cf_enabled_term AS
SELECT m1.*
FROM ICRW_SCHEMA.term m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE OR REPLACE VIEW cf_enabled_location AS
SELECT m1.*
FROM ICRW_SCHEMA.location m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

-- Streams
CREATE OR REPLACE STREAM dnd_st_prrecord ON VIEW cf_enabled_prrecord;
CREATE OR REPLACE STREAM dnd_st_prentry ON VIEW cf_enabled_prentry;
CREATE OR REPLACE STREAM dnd_st_customer ON VIEW cf_enabled_customer;
CREATE OR REPLACE STREAM dnd_st_vendor ON VIEW cf_enabled_vendor;
CREATE OR REPLACE STREAM dnd_st_term ON VIEW cf_enabled_term;
CREATE OR REPLACE STREAM dnd_st_location ON VIEW cf_enabled_location;

-- ============================================================================
-- SECTION 3: PROCEDURE & TASK - CONSUME STREAMS
-- ============================================================================

CREATE OR REPLACE PROCEDURE dnd_process_stream_changes()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    prrecord_upsert_count INTEGER DEFAULT 0;
    prrecord_delete_count INTEGER DEFAULT 0;
    prentry_upsert_count INTEGER DEFAULT 0;
    prentry_delete_count INTEGER DEFAULT 0;
    customer_upsert_count INTEGER DEFAULT 0;
    customer_delete_count INTEGER DEFAULT 0;
    vendor_upsert_count INTEGER DEFAULT 0;
    vendor_delete_count INTEGER DEFAULT 0;
    term_upsert_count INTEGER DEFAULT 0;
    term_delete_count INTEGER DEFAULT 0;
    location_upsert_count INTEGER DEFAULT 0;
    location_delete_count INTEGER DEFAULT 0;
BEGIN
    -- ========== PRRECORD ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, recordtype, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'PRRECORD',
        m1.recordtype,
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_prrecord m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    prrecord_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'PRRECORD'
    FROM dnd_st_prrecord m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    prrecord_delete_count := SQLROWCOUNT;
    COMMIT;

    -- ========== PRENTRY ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, recordtype, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'PRENTRY',
        m1.recordtype,
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_prentry m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    prentry_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'PRENTRY'
    FROM dnd_st_prentry m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    prentry_delete_count := SQLROWCOUNT;
    COMMIT;

    -- ========== CUSTOMER ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'CUSTOMER',
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_customer m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    customer_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'CUSTOMER'
    FROM dnd_st_customer m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    customer_delete_count := SQLROWCOUNT;
    COMMIT;

    -- ========== VENDOR ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'VENDOR',
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_vendor m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    vendor_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'VENDOR'
    FROM dnd_st_vendor m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    vendor_delete_count := SQLROWCOUNT;
    COMMIT;

    -- ========== TERM ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, module, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'TERM',
        m1.modulekey,
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_term m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    term_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'TERM'
    FROM dnd_st_term m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    term_delete_count := SQLROWCOUNT;
    COMMIT;

    -- ========== LOCATION ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'LOCATION',
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_location m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    location_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename)
    SELECT 
        m1.cny_,
        m1.record_,
        'LOCATION'
    FROM dnd_st_location m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    location_delete_count := SQLROWCOUNT;
    COMMIT;

    RETURN 'Processed: ' ||
        'PRRECORD(' || prrecord_upsert_count || ' upserts, ' || prrecord_delete_count || ' deletes), ' ||
        'PRENTRY(' || prentry_upsert_count || ' upserts, ' || prentry_delete_count || ' deletes), ' ||
        'CUSTOMER(' || customer_upsert_count || ' upserts, ' || customer_delete_count || ' deletes), ' ||
        'VENDOR(' || vendor_upsert_count || ' upserts, ' || vendor_delete_count || ' deletes), ' ||
        'TERM(' || term_upsert_count || ' upserts, ' || term_delete_count || ' deletes), ' ||
        'LOCATION(' || location_upsert_count || ' upserts, ' || location_delete_count || ' deletes)';
END;
$$;

CREATE OR REPLACE TASK dnd_task_consume_streams
    SCHEDULE = 'USING CRON 10 */4 * * * America/Los_Angeles'
AS
    CALL dnd_process_stream_changes();

ALTER TASK dnd_task_consume_streams RESUME;
