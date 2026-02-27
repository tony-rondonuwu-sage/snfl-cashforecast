CREATE OR REPLACE TABLE deleted_record (
  cny_ number(15) NOT NULL,
  record_ number(15) NOT NULL,
  tablename varchar(255) NOT NULL,
  stream_ts timestamp_ntz DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE STREAM st_prrecord_delete ON table ICRW_SCHEMA.prrecord;
CREATE OR REPLACE STREAM st_prentry_delete ON table ICRW_SCHEMA.prentry;
CREATE OR REPLACE STREAM st_customer_delete ON table ICRW_SCHEMA.customer;
CREATE OR REPLACE STREAM st_vendor_delete ON table ICRW_SCHEMA.vendor;
CREATE OR REPLACE STREAM st_term_delete ON table ICRW_SCHEMA.term;
CREATE OR REPLACE STREAM st_location_delete ON table ICRW_SCHEMA.location;

-- Create task to query the stream and insert truly deleted records to deleted_record table.  
-- Note that updated records have two entries in the stream: DELETE and INSERT.  Make sure that DELETE is excluded.
CREATE OR REPLACE TASK capture_deleted_records
    SCHEDULE = '240 MINUTE'
AS
  INSERT INTO deleted_record(cny_, record_, tablename) 
  SELECT * FROM (
    SELECT m1.cny_, m1.record_, 'PRRECORD' 
      FROM st_prrecord_delete m1 WHERE m1.METADATA$ACTION = 'DELETE' 
      AND NOT EXISTS (SELECT 1 FROM st_prrecord_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    UNION ALL
    SELECT m1.cny_, m1.record_, 'PRENTRY' 
      FROM st_prentry_delete m1 WHERE m1.METADATA$ACTION = 'DELETE' 
      AND NOT EXISTS (SELECT 1 FROM st_prentry_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    UNION ALL
    SELECT m1.cny_, m1.record_, 'CUSTOMER' 
      FROM st_customer_delete m1 WHERE m1.METADATA$ACTION = 'DELETE' 
      AND NOT EXISTS (SELECT 1 FROM st_customer_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    UNION ALL
    SELECT m1.cny_, m1.record_, 'VENDOR'
      FROM st_vendor_delete m1 WHERE m1.METADATA$ACTION = 'DELETE'
      AND NOT EXISTS (SELECT 1 FROM st_vendor_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    UNION ALL
    SELECT m1.cny_, m1.record_, 'TERM' 
      FROM st_term_delete m1 WHERE m1.METADATA$ACTION = 'DELETE' 
      AND NOT EXISTS (SELECT 1 FROM st_term_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    UNION ALL
    SELECT m1.cny_, m1.record_, 'LOCATION' 
      FROM st_location_delete m1 WHERE m1.METADATA$ACTION = 'DELETE' 
      AND NOT EXISTS (SELECT 1 FROM st_location_delete m2 WHERE m2.METADATA$ACTION = 'INSERT' AND m2.cny_=m1.cny_ AND m2.record_=m1.record_)
    ) x
    WHERE EXISTS (SELECT 1 FROM ICRW_SCHEMA.companypref cp WHERE x.cny_=cp.cny_ AND cp.property='ENABLECASHFLOW' and cp.value='T')
;

ALTER TASK capture_deleted_records RESUME;

