-- ============================================================================
-- CLEANUP SCRIPT for existing deleted stream
-- ============================================================================

-- 1. Suspend and Drop Task
ALTER TASK IF EXISTS capture_deleted_records SUSPEND;
DROP TASK IF EXISTS capture_deleted_records;

-- 2. Drop Streams
DROP STREAM IF EXISTS st_prrecord_delete;
DROP STREAM IF EXISTS st_prentry_delete;
DROP STREAM IF EXISTS st_customer_delete;
DROP STREAM IF EXISTS st_vendor_delete;
DROP STREAM IF EXISTS st_term_delete;
DROP STREAM IF EXISTS st_location_delete;
