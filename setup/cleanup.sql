-- Cleanup Script - Run this to remove all demo resources
-- WARNING: This will delete all data and objects created for the demo

USE ROLE ACCOUNTADMIN;

-- Drop schemas
DROP SCHEMA IF EXISTS DBT_DEMO_DB.STAGING CASCADE;
DROP SCHEMA IF EXISTS DBT_DEMO_DB.MARTS CASCADE;
DROP SCHEMA IF EXISTS DBT_DEMO_DB.PUBLIC CASCADE;

-- Drop database
DROP DATABASE IF EXISTS DBT_DEMO_DB CASCADE;

-- Drop warehouse
DROP WAREHOUSE IF EXISTS DBT_DEMO_WH;

-- Optional: Drop role and user if created
-- DROP ROLE IF EXISTS DBT_DEMO_ROLE;
-- DROP USER IF EXISTS DBT_USER;

SELECT 'Cleanup complete!' AS status;

