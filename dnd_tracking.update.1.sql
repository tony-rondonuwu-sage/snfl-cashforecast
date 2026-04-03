-- ============================================================================
-- SECTION 1: TRACKING TABLES
-- ============================================================================

ALTER TABLE deleted_record ADD COLUMN IF NOT EXISTS recordtype VARCHAR(10);
ALTER TABLE deleted_record ADD COLUMN IF NOT EXISTS module VARCHAR(50);


-- ============================================================================
-- SECTION 2: VIEWS AND STREAMS FOR CASHFORECASTING-ENABLED COMPANIES
-- ============================================================================

CREATE OR REPLACE STREAM dnd_st_pymtdetail ON VIEW cf_enabled_pymtdetail;

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
    pymtdetail_upsert_count INTEGER DEFAULT 0;
    pymtdetail_delete_count INTEGER DEFAULT 0;
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

    INSERT INTO deleted_record (cny_, record_, tablename, recordtype)
    SELECT 
        m1.cny_,
        m1.record_,
        'PRRECORD',
        m1.recordtype
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

    INSERT INTO deleted_record (cny_, record_, tablename, recordtype)
    SELECT 
        m1.cny_,
        m1.record_,
        'PRENTRY',
        m1.recordtype
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

    INSERT INTO deleted_record (cny_, record_, tablename, module)
    SELECT 
        m1.cny_,
        m1.record_,
        'TERM',
        m1.modulekey
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

    -- ========== PYMTDETAIL ==========
    BEGIN TRANSACTION;
    INSERT INTO upserted_record (cny_, record_, tablename, module, operation_type)
    SELECT 
        m1.cny_, 
        m1.record_, 
        'PYMTDETAIL',
        m1.modulekey,
        CASE WHEN m1.METADATA$ISUPDATE = TRUE THEN 'U' ELSE 'I' END
    FROM dnd_st_pymtdetail m1
    WHERE m1.METADATA$ACTION = 'INSERT';
    pymtdetail_upsert_count := SQLROWCOUNT;

    INSERT INTO deleted_record (cny_, record_, tablename, module)
    SELECT 
        m1.cny_,
        m1.record_,
        'PYMTDETAIL',
        m1.modulekey
    FROM dnd_st_pymtdetail m1
    WHERE m1.METADATA$ACTION = 'DELETE' 
      AND m1.METADATA$ISUPDATE = FALSE;
    pymtdetail_delete_count := SQLROWCOUNT;
    COMMIT;

    RETURN 'Processed: ' ||
        'PRRECORD(' || prrecord_upsert_count || ' upserts, ' || prrecord_delete_count || ' deletes), ' ||
        'PRENTRY(' || prentry_upsert_count || ' upserts, ' || prentry_delete_count || ' deletes), ' ||
        'CUSTOMER(' || customer_upsert_count || ' upserts, ' || customer_delete_count || ' deletes), ' ||
        'VENDOR(' || vendor_upsert_count || ' upserts, ' || vendor_delete_count || ' deletes), ' ||
        'TERM(' || term_upsert_count || ' upserts, ' || term_delete_count || ' deletes), ' ||
        'LOCATION(' || location_upsert_count || ' upserts, ' || location_delete_count || ' deletes), ' ||
        'PYMTDETAIL(' || pymtdetail_upsert_count || ' upserts, ' || pymtdetail_delete_count || ' deletes)';
END;
$$;

