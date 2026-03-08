-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - PART 1: UNDO / TEARDOWN
-- ============================================================================

-- ============================================================================
-- SECTION 3 UNDO: TASK & PROCEDURE
-- ============================================================================

ALTER TASK cf_task_consume_streams SUSPEND;
DROP TASK IF EXISTS cf_task_consume_streams;
DROP PROCEDURE IF EXISTS cf_process_stream_changes();

-- ============================================================================
-- SECTION 2 UNDO: STREAMS & VIEWS
-- ============================================================================

-- Streams
DROP STREAM IF EXISTS cf_enabled_st_prrecord;
DROP STREAM IF EXISTS cf_enabled_st_prentry;
DROP STREAM IF EXISTS cf_enabled_st_customer;
DROP STREAM IF EXISTS cf_enabled_st_vendor;
DROP STREAM IF EXISTS cf_enabled_st_term;
DROP STREAM IF EXISTS cf_enabled_st_location;
DROP STREAM IF EXISTS cf_enabled_st_pymtdetail;

-- Views
DROP VIEW IF EXISTS cf_enabled_prrecord;
DROP VIEW IF EXISTS cf_enabled_prentry;
DROP VIEW IF EXISTS cf_enabled_customer;
DROP VIEW IF EXISTS cf_enabled_vendor;
DROP VIEW IF EXISTS cf_enabled_term;
DROP VIEW IF EXISTS cf_enabled_location;
DROP VIEW IF EXISTS cf_enabled_pymtdetail;

-- ============================================================================
-- SECTION 1 UNDO: TRACKING TABLES
-- ============================================================================

DROP TABLE IF EXISTS cf_upsert_records;
DROP TABLE IF EXISTS cf_delete_records;
