
-- ============================================================================
-- VIEWS AND STREAMS FOR CASHFORECASTING-ENABLED COMPANIES
-- ============================================================================

-- Views
CREATE VIEW IF NOT EXISTS dnd_enabled_prrecord AS
SELECT m1.*
FROM ICRW_SCHEMA.prrecord m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_prentry AS
SELECT m1.*
FROM ICRW_SCHEMA.prentry m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_customer AS
SELECT m1.*
FROM ICRW_SCHEMA.customer m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_vendor AS
SELECT m1.*
FROM ICRW_SCHEMA.vendor m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_term AS
SELECT m1.*
FROM ICRW_SCHEMA.term m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_location AS
SELECT m1.*
FROM ICRW_SCHEMA.location m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

CREATE VIEW IF NOT EXISTS dnd_enabled_pymtdetail AS
SELECT m1.*
FROM ICRW_SCHEMA.pymtdetail m1
INNER JOIN ICRW_SCHEMA.companypref cp 
    ON m1.cny_ = cp.cny_ 
    AND cp.property = 'ENABLECASHFLOW' 
    AND cp.value = 'T';

-- Streams
CREATE OR REPLACE STREAM dnd_st_prrecord ON VIEW dnd_enabled_prrecord;
CREATE OR REPLACE STREAM dnd_st_prentry ON VIEW dnd_enabled_prentry;
CREATE OR REPLACE STREAM dnd_st_customer ON VIEW dnd_enabled_customer;
CREATE OR REPLACE STREAM dnd_st_vendor ON VIEW dnd_enabled_vendor;
CREATE OR REPLACE STREAM dnd_st_term ON VIEW dnd_enabled_term;
CREATE OR REPLACE STREAM dnd_st_location ON VIEW dnd_enabled_location;
CREATE OR REPLACE STREAM dnd_st_pymtdetail ON VIEW dnd_enabled_pymtdetail;

