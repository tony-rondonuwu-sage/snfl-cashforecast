# Sage AI Data Export Pipeline — Summary & Technical Design

## Purpose

An incremental CDC (Change Data Capture) pipeline that exports **Intacct ERP financial data** (Cash Forecasting feature) from Snowflake to S3 as Parquet files, with multi-pod coordination, manifest-based signaling, and observability via Slack + Confluence.

---

## Architecture Overview

```
ICRW_SCHEMA (source tables)
  → Views (filtered to CF-enabled companies via companypref)
    → Snowflake Streams (CDC capture)
      → Tracking tables (upsert/delete records)
        → COPY INTO S3 (Parquet files, per company)
          → JSON manifest files (per pod)
            → .done file (when all pods complete)
```

---

## Key Components

| Section | What | How |
|---|---|---|
| **0-A** | S3 connectivity | Storage integration + external stage → `s3://sail-mercury-intacct-data-extract-development/` |
| **0-B** | Configuration | 4 tables: `conf_pod` (pod/region), `conf_feature` (S3 paths), `conf_streams` (source tables + filters), `conf_api_views` (logical API views mapping to source tables) |
| **1** | Export tracking | `export_manifest` (per-run metadata) + `export_data_files` (per-file tracking with status/errors) |
| **2** | CDC staging | `cf_upsert_records` and `cf_delete_records` — intermediate tables holding stream-captured change keys |
| **3** | Views + Streams | `create_views_and_streams('cf')` — dynamically creates views joining source tables to `companypref` (WHERE `ENABLECASHFLOW='T'`), then creates streams on those views |
| **4** | Stream consumer | `process_stream_changes('cf')` — reads stream metadata (`METADATA$ACTION`, `METADATA$ISUPDATE`) to classify changes as upserts or deletes, inserts into tracking tables. Runs on a **CRON task every 4 hours** |
| **5** | S3 export | `export_data('cf')` — iterates over `conf_api_views`, groups by `cny_` (company), exports upserts via source view joins + deletes from tracking table. Writes per-pod JSON manifest, then checks if all pods reported to write a `.done` signal file |
| **6** | Task DAG | `cf_task_consume_streams` (CRON) → `cf_task_export_to_s3` (AFTER) |
| **7** | Notifications | Slack webhook UDF + Confluence page publisher (hierarchical: Year > Month > Pod > Run). Wrapper proc `cf_run_pipeline_with_notification()` orchestrates both steps and sends results |
| **8** | Initial/backfill export | `initial_export()` — full export for specific companies/views with a 2-year lookback filter, bypasses stream tracking |

---

## Data Flow Details

- **Source tables**: `prrecord`, `prentry`, `customer`, `vendor`, `term`, `location`, `pymtdetail` (from `ICRW_SCHEMA`)
- **API views** (15 logical views): map to AR/AP invoices, payments, payment details, customers, vendors, terms, and locations — filtered by `recordtype` or `module`
- **S3 path pattern**: `cash_forecasting/incoming/{company_id}/{VIEW_NAME}_{UPSERT|DELETE}_{YYYYMMDD}{iteration}_*.parquet`
- **Manifest pattern**: `cash_forecasting/{pod}.cashflow_data_{YYYYMMDD}{iteration}.json`
- **Done signal**: `cash_forecasting/cashflow_data_ready_{YYYYMMDD}{iteration}.done` — written only when all pods in the region have published their manifest
- **Failed exports** retain `upsert_record_ids`/`delete_record_ids` arrays for retry on next run

---

## Multi-Pod Coordination

Each pod exports independently and writes a JSON manifest. The last pod to finish checks S3 for all pod manifests matching the same date+iteration pattern. If count >= `total_pods_for_region`, it writes the `.done` file to signal downstream consumers.
