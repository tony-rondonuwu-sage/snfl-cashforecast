-- ============================================================================
-- SAGE AI DATA EXPORT PIPELINE - UNDO/DROP SCRIPT
-- ============================================================================

-- SECTION 7: SUSPEND AND DROP TASKS (must suspend before dropping)
ALTER TASK IF EXISTS task_create_manifests SUSPEND;
ALTER TASK IF EXISTS task_export_to_s3 SUSPEND;
ALTER TASK IF EXISTS task_consume_streams SUSPEND;
ALTER TASK IF EXISTS cf_task_consume_streams SUSPEND;

DROP TASK IF EXISTS task_create_manifests;
DROP TASK IF EXISTS task_export_to_s3;
DROP TASK IF EXISTS task_consume_streams;
DROP TASK IF EXISTS cf_task_consume_streams;

-- SECTION 8: DROP HELPER PROCEDURES
DROP PROCEDURE IF EXISTS check_region_export_status(DATE, VARCHAR);

-- SECTION 5 & 6: DROP EXPORT PROCEDURES
DROP PROCEDURE IF EXISTS cf_export_to_s3();
DROP PROCEDURE IF EXISTS cf_export_dry_run();
DROP PROCEDURE IF EXISTS cf_export_data(BOOLEAN);
DROP PROCEDURE IF EXISTS export_data(VARCHAR, BOOLEAN);

-- SECTION 4: DROP STREAM PROCESSING PROCEDURES
DROP PROCEDURE IF EXISTS cf_process_stream_changes();
DROP PROCEDURE IF EXISTS process_stream_changes(VARCHAR);

-- SECTION 3: DROP VIEW/STREAM CREATION PROCEDURES
DROP PROCEDURE IF EXISTS cf_create_views_and_streams();
DROP PROCEDURE IF EXISTS create_views_and_streams(VARCHAR);

-- SECTION 3: DROP STREAMS (created by cf_create_views_and_streams)
DROP STREAM IF EXISTS cf_enabled_st_prrecord;
DROP STREAM IF EXISTS cf_enabled_st_prentry;
DROP STREAM IF EXISTS cf_enabled_st_customer;
DROP STREAM IF EXISTS cf_enabled_st_vendor;
DROP STREAM IF EXISTS cf_enabled_st_term;
DROP STREAM IF EXISTS cf_enabled_st_location;
DROP STREAM IF EXISTS cf_enabled_st_pymtdetail;

-- SECTION 3: DROP VIEWS (created by cf_create_views_and_streams)
DROP VIEW IF EXISTS cf_enabled_prrecord;
DROP VIEW IF EXISTS cf_enabled_prentry;
DROP VIEW IF EXISTS cf_enabled_customer;
DROP VIEW IF EXISTS cf_enabled_vendor;
DROP VIEW IF EXISTS cf_enabled_term;
DROP VIEW IF EXISTS cf_enabled_location;
DROP VIEW IF EXISTS cf_enabled_pymtdetail;

-- SECTION 1: DROP STORAGE INTEGRATION AND STAGE
DROP STAGE IF EXISTS sage_ai_export_stage;
DROP STORAGE INTEGRATION IF EXISTS sage_ai_s3_integration;

-- SECTION 2: DROP STREAM TRACKING TABLES
DROP TABLE IF EXISTS cf_delete_records;
DROP TABLE IF EXISTS cf_upsert_records;

-- SECTION 1: DROP EXPORT TRACKING TABLES
DROP TABLE IF EXISTS export_dry_run_data;
DROP TABLE IF EXISTS export_data_files;
DROP TABLE IF EXISTS export_manifest;

-- SECTION 0: DROP CONFIGURATION TABLES (drop in reverse FK order)
DROP TABLE IF EXISTS conf_api_views;
DROP TABLE IF EXISTS conf_streams;
DROP TABLE IF EXISTS conf_pod;
DROP TABLE IF EXISTS conf_feature;
