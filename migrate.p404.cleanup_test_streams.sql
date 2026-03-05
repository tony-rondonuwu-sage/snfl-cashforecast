
-- ============================================================================
-- CLEANUP SCRIPT - DROP ALL OBJECTS CREATED FOR STREAM TESTING in POD 404
-- ============================================================================
-- Run the following to remove all objects created by this script.
-- Execute in order: Tasks first, then Streams, Views, Procedures, and Tables.

-- 1. Suspend and Drop Task
ALTER TASK IF EXISTS task_consume_streams SUSPEND;
DROP TASK IF EXISTS task_consume_streams;

-- 2. Drop Streams
DROP STREAM IF EXISTS st_prrecord_ai_enabled;
DROP STREAM IF EXISTS st_prentry_ai_enabled;
DROP STREAM IF EXISTS st_customer_ai_enabled;
DROP STREAM IF EXISTS st_vendor_ai_enabled;
DROP STREAM IF EXISTS st_term_ai_enabled;
DROP STREAM IF EXISTS st_location_ai_enabled;

-- 3. Drop Views
DROP VIEW IF EXISTS prrecord_ai_enabled;
DROP VIEW IF EXISTS prentry_ai_enabled;
DROP VIEW IF EXISTS customer_ai_enabled;
DROP VIEW IF EXISTS vendor_ai_enabled;
DROP VIEW IF EXISTS term_ai_enabled;
DROP VIEW IF EXISTS location_ai_enabled;

-- 4. Drop Procedure
DROP PROCEDURE IF EXISTS process_stream_changes();

-- 5. Drop Tables (indexes are dropped automatically with tables)
DROP TABLE IF EXISTS upsert_records;
DROP TABLE IF EXISTS delete_records;

