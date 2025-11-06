-- Snowflake Setup Script for dbt Demo
-- Run this in Snowflake before running dbt commands

-- Step 1: Create a database for the dbt demo
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS DBT_DEMO_DB;
USE DATABASE DBT_DEMO_DB;

-- Step 2: Create a warehouse for dbt to use
CREATE WAREHOUSE IF NOT EXISTS DBT_DEMO_WH
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Step 3: Create a role for dbt
CREATE ROLE IF NOT EXISTS DBT_DEMO_ROLE;

-- Step 4: Grant necessary privileges to the role
GRANT USAGE ON WAREHOUSE DBT_DEMO_WH TO ROLE DBT_DEMO_ROLE;
GRANT ALL ON DATABASE DBT_DEMO_DB TO ROLE DBT_DEMO_ROLE;
GRANT ALL ON ALL SCHEMAS IN DATABASE DBT_DEMO_DB TO ROLE DBT_DEMO_ROLE;

-- Step 5: Create a user for dbt (optional - use your existing user)
-- CREATE USER IF NOT EXISTS DBT_USER
--   PASSWORD = 'YourSecurePassword123!'
--   DEFAULT_ROLE = DBT_DEMO_ROLE
--   DEFAULT_WAREHOUSE = DBT_DEMO_WH;

-- Step 6: Grant role to user (replace YOUR_USERNAME with your Snowflake username)
-- GRANT ROLE DBT_DEMO_ROLE TO USER DBT_USER;
-- Or use your existing username:
-- GRANT ROLE DBT_DEMO_ROLE TO USER <YOUR_USERNAME>;

-- Step 7: Create schemas for dbt (optional - dbt will create them)
CREATE SCHEMA IF NOT EXISTS DBT_DEMO_DB.STAGING;
CREATE SCHEMA IF NOT EXISTS DBT_DEMO_DB.MARTS;

-- Grant privileges on the new schemas
GRANT ALL ON SCHEMA DBT_DEMO_DB.STAGING TO ROLE DBT_DEMO_ROLE;
GRANT ALL ON SCHEMA DBT_DEMO_DB.MARTS TO ROLE DBT_DEMO_ROLE;

-- Verify setup
SHOW DATABASES LIKE 'DBT_DEMO_DB';
SHOW WAREHOUSES LIKE 'DBT_DEMO_WH';
SHOW ROLES LIKE 'DBT_DEMO_ROLE';

SELECT 'Snowflake setup complete!' AS status;

