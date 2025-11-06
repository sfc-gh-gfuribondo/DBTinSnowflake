-- ============================================================================
-- EXECUTE DBT PROJECT - SQL Worksheet Examples
-- Based on: https://docs.snowflake.com/en/sql-reference/sql/execute-dbt-project
-- ============================================================================
-- This worksheet demonstrates how to run dbt projects directly from Snowflake
-- using the EXECUTE DBT PROJECT command (Preview Feature)
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE DBT_DEMO_DB;
USE WAREHOUSE DBT_DEMO_WH;

-- ============================================================================
-- SECTION 1: Create a dbt Project Object from Git
-- ============================================================================
-- Note: First you need to create a dbt project object in Snowflake
-- This requires a Git repository with your dbt project

-- Example: Create a dbt project from a Git repository
-- (Uncomment and modify for your repository)
/*
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  FROM GIT REPOSITORY my_git_integration
  PATH '/dbt_project';
*/

-- ============================================================================
-- SECTION 2: Basic EXECUTE DBT PROJECT Commands
-- ============================================================================

-- Example 1: Execute default dbt run command
-- Runs dbt with default settings from the project configuration
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Example 2: Execute dbt run with specific target
-- Targets the 'dev' profile defined in profiles.yml
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';

-- Example 3: Execute dbt run with specific target (production)
-- Targets the 'prod' profile defined in profiles.yml
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target prod';

-- ============================================================================
-- SECTION 3: Model Selection Examples
-- ============================================================================

-- Example 4: Run specific models only
-- Selects and runs three specific models from the dbt project
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select stg_customers stg_orders customer_orders --target dev';

-- Example 5: Run all staging models
-- Uses dbt naming convention to select all staging models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select staging.* --target dev';

-- Example 6: Run all marts models
-- Uses dbt naming convention to select all marts models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select marts.* --target dev';

-- Example 7: Run a model and all its downstream dependencies
-- The '+' notation runs the specified model and everything downstream
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select stg_customers+ --target dev';

-- Example 8: Run a model and all its upstream dependencies
-- The '+' before the model runs all dependencies first
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select +customer_orders --target dev';

-- Example 9: Run a model with both upstream and downstream
-- Runs the full dependency chain
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select +customer_orders+ --target dev';

-- ============================================================================
-- SECTION 4: Different dbt Commands
-- ============================================================================

-- Example 10: Execute dbt seed command
-- Loads CSV files from seeds/ directory
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'seed --target dev';

-- Example 11: Execute dbt test command
-- Runs all data quality tests
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'test --target dev';

-- Example 12: Execute dbt test for specific models
-- Tests only the specified models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'test --select stg_customers stg_orders --target dev';

-- Example 13: Execute dbt build command
-- Runs seeds, models, and tests in correct order
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'build --target dev';

-- Example 14: Execute dbt docs generate
-- Generates documentation for the project
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'docs generate --target dev';

-- Example 15: Execute dbt snapshot
-- Runs snapshot models for slowly changing dimensions
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'snapshot --target dev';

-- Example 16: Execute dbt compile
-- Compiles models without executing them
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'compile --target dev';

-- ============================================================================
-- SECTION 5: Advanced Options
-- ============================================================================

-- Example 17: Full refresh (rebuild from scratch)
-- Drops and recreates all tables
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --full-refresh --target dev';

-- Example 18: Run with threads (parallel execution)
-- Runs multiple models in parallel
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --threads 4 --target dev';

-- Example 19: Fail fast - stop on first error
-- Stops execution if any model fails
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --fail-fast --target dev';

-- Example 20: Run modified models only
-- Uses state comparison (requires state configuration)
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select state:modified+ --target dev';

-- ============================================================================
-- SECTION 6: Subdirectory Projects
-- ============================================================================

-- Example 21: Execute dbt project in subdirectory
-- Useful when multiple dbt projects exist in one repository
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_PARENT_PROJECT
  ARGS = 'run --target dev'
  PROJECT_ROOT = 'subdirectory/project1';

-- Example 22: Execute different subdirectory projects
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_PARENT_PROJECT
  ARGS = 'run --target prod'
  PROJECT_ROOT = 'subdirectory/project2';

-- ============================================================================
-- SECTION 7: Workspace Execution (Alternative Syntax)
-- ============================================================================

-- Example 23: Execute from workspace
-- Executes dbt project saved in a Snowflake workspace
EXECUTE DBT PROJECT FROM WORKSPACE user$.public."My dbt Project Workspace"
  ARGS = 'run --target dev';

-- Example 24: Execute workspace project with options
EXECUTE DBT PROJECT FROM WORKSPACE user$.public."My dbt Project Workspace"
  ARGS = 'build --select marts.* --target prod';

-- ============================================================================
-- SECTION 8: Capturing and Analyzing Results
-- ============================================================================

-- Example 25: Execute and capture results in a variable
-- Store execution results for analysis
DECLARE
  execution_result VARIANT;
BEGIN
  execution_result := (
    EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
    ARGS = 'run --target dev'
  );
  
  RETURN execution_result;
END;

-- Example 26: Execute and display results with column names
-- Shows success status, exceptions, and output
SELECT 
    "0|1 Success" as SUCCESS_STATUS,
    EXCEPTION as ERROR_MESSAGE,
    STDOUT as OUTPUT,
    OUTPUT_ARCHIVE_URL as ARTIFACTS_URL
FROM (
    EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
    ARGS = 'run --target dev'
);

-- ============================================================================
-- SECTION 9: Production Scheduling with Tasks
-- ============================================================================

-- Example 27: Create scheduled task to run dbt daily
-- Runs dbt models every day at 2 AM
CREATE OR REPLACE TASK DBT_DEMO_DB.PUBLIC.DAILY_DBT_RUN
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --target prod';

-- Example 28: Create task for hourly incremental runs
-- Runs only modified models every hour
CREATE OR REPLACE TASK DBT_DEMO_DB.PUBLIC.HOURLY_DBT_INCREMENTAL
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = '60 MINUTES'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --select state:modified+ --target prod';

-- Example 29: Create dependent tasks (run then test)
-- First task runs models, second task tests them
CREATE OR REPLACE TASK DBT_DEMO_DB.PUBLIC.RUN_DBT_MODELS
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = '6 HOURS'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --target prod';

CREATE OR REPLACE TASK DBT_DEMO_DB.PUBLIC.TEST_DBT_MODELS
  WAREHOUSE = DBT_DEMO_WH
  AFTER DBT_DEMO_DB.PUBLIC.RUN_DBT_MODELS
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'test --target prod';

-- Example 30: Start the task chain
ALTER TASK DBT_DEMO_DB.PUBLIC.TEST_DBT_MODELS RESUME;
ALTER TASK DBT_DEMO_DB.PUBLIC.RUN_DBT_MODELS RESUME;

-- Example 31: Check task execution history
SELECT 
    NAME,
    STATE,
    SCHEDULED_TIME,
    COMPLETED_TIME,
    RETURN_VALUE
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME IN ('RUN_DBT_MODELS', 'TEST_DBT_MODELS')
ORDER BY SCHEDULED_TIME DESC
LIMIT 10;

-- ============================================================================
-- SECTION 10: Error Handling and Monitoring
-- ============================================================================

-- Example 32: Execute with error handling
-- Captures failures and logs them
BEGIN
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --target dev';
  
  -- Log success
  INSERT INTO DBT_DEMO_DB.PUBLIC.DBT_EXECUTION_LOG 
  VALUES (CURRENT_TIMESTAMP(), 'SUCCESS', NULL);
  
EXCEPTION
  WHEN OTHER THEN
    -- Log failure
    INSERT INTO DBT_DEMO_DB.PUBLIC.DBT_EXECUTION_LOG 
    VALUES (CURRENT_TIMESTAMP(), 'FAILED', SQLERRM);
    RAISE;
END;

-- Example 33: Check if dbt project exists before executing
EXECUTE DBT PROJECT IF EXISTS DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';

-- ============================================================================
-- SECTION 11: Querying Results and Artifacts
-- ============================================================================

-- Example 34: Parse execution results
-- Extract and analyze the execution output
WITH execution AS (
  SELECT * FROM (
    EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
    ARGS = 'run --target dev'
  )
)
SELECT
  CASE 
    WHEN "0|1 Success" = TRUE THEN '✅ SUCCESS'
    ELSE '❌ FAILED'
  END as STATUS,
  EXCEPTION as ERROR_DETAILS,
  OUTPUT_ARCHIVE_URL as ARTIFACTS
FROM execution;

-- Example 35: Extract model counts from output
-- Parse STDOUT to get model execution stats
WITH execution AS (
  SELECT * FROM (
    EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
    ARGS = 'run --target dev'
  )
)
SELECT
  STDOUT as FULL_OUTPUT,
  -- Parse for common patterns
  REGEXP_SUBSTR(STDOUT, 'Completed successfully') as SUCCESS_MESSAGE,
  REGEXP_SUBSTR(STDOUT, 'Done. PASS=(\\d+)', 1, 1, 'e', 1) as MODELS_PASSED
FROM execution;

-- ============================================================================
-- SECTION 12: Management Commands
-- ============================================================================

-- Example 36: Show all dbt projects
SHOW DBT PROJECTS IN DATABASE DBT_DEMO_DB;

-- Example 37: Show dbt projects in specific schema
SHOW DBT PROJECTS IN SCHEMA DBT_DEMO_DB.PUBLIC;

-- Example 38: Describe a dbt project
DESCRIBE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Example 39: Show versions in dbt project
SHOW VERSIONS IN DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- ============================================================================
-- SECTION 13: Real-World Production Workflow
-- ============================================================================

-- Example 40: Complete production workflow
-- Daily orchestration with monitoring

-- Step 1: Run dbt seed (load reference data)
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'seed --target prod';

-- Step 2: Run staging models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select staging.* --target prod';

-- Step 3: Run marts models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select marts.* --target prod';

-- Step 4: Run all tests
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'test --target prod';

-- Step 5: Generate documentation
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'docs generate --target prod';

-- Step 6: Query results to verify
SELECT * FROM DBT_DEMO_DB.PUBLIC_MARTS.CUSTOMER_ORDERS LIMIT 5;
SELECT * FROM DBT_DEMO_DB.PUBLIC_MARTS.ORDER_SUMMARY LIMIT 5;

-- ============================================================================
-- SECTION 14: Cleanup Commands
-- ============================================================================

-- Example 41: Stop all tasks
ALTER TASK DBT_DEMO_DB.PUBLIC.RUN_DBT_MODELS SUSPEND;
ALTER TASK DBT_DEMO_DB.PUBLIC.TEST_DBT_MODELS SUSPEND;
ALTER TASK DBT_DEMO_DB.PUBLIC.DAILY_DBT_RUN SUSPEND;

-- Example 42: Drop tasks (if needed)
-- DROP TASK IF EXISTS DBT_DEMO_DB.PUBLIC.RUN_DBT_MODELS;
-- DROP TASK IF EXISTS DBT_DEMO_DB.PUBLIC.TEST_DBT_MODELS;
-- DROP TASK IF EXISTS DBT_DEMO_DB.PUBLIC.DAILY_DBT_RUN;

-- Example 43: Drop dbt project (if needed)
-- DROP DBT PROJECT IF EXISTS DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- ============================================================================
-- END OF WORKSHEET
-- ============================================================================

/*
IMPORTANT NOTES:

1. PREVIEW FEATURE:
   - EXECUTE DBT PROJECT is currently in preview
   - Available to all accounts but may change
   - Review latest documentation before production use

2. PREREQUISITES:
   - dbt project must be created first using CREATE DBT PROJECT
   - Project can be from Git repository or Snowflake workspace
   - profiles.yml must be properly configured

3. PERMISSIONS REQUIRED:
   - USAGE privilege on the dbt project object
   - USAGE privilege on database and schema
   - Privileges on target database/schema for transformations
   - USAGE on warehouse specified in profiles.yml

4. BEST PRACTICES:
   - Use tasks for scheduled production runs
   - Implement error handling and logging
   - Monitor execution via TASK_HISTORY
   - Use --target to separate dev/prod environments
   - Leverage model selection for efficient runs

5. OUTPUT COLUMNS:
   - "0|1 Success": Boolean success indicator
   - EXCEPTION: Error message if failed
   - STDOUT: Standard output from dbt
   - OUTPUT_ARCHIVE_URL: Link to artifacts and logs

6. ARTIFACTS:
   - Access via OUTPUT_ARCHIVE_URL
   - Contains logs, manifest.json, run_results.json
   - Useful for monitoring and debugging

For more information:
https://docs.snowflake.com/en/sql-reference/sql/execute-dbt-project
*/

-- ============================================================================
-- QUICK REFERENCE
-- ============================================================================
/*
COMMON COMMANDS:

Basic execution:
  EXECUTE DBT PROJECT <name> ARGS = 'run';

Specific target:
  EXECUTE DBT PROJECT <name> ARGS = 'run --target prod';

Select models:
  EXECUTE DBT PROJECT <name> ARGS = 'run --select model1 model2';

Run tests:
  EXECUTE DBT PROJECT <name> ARGS = 'test';

Full rebuild:
  EXECUTE DBT PROJECT <name> ARGS = 'run --full-refresh';

Build everything:
  EXECUTE DBT PROJECT <name> ARGS = 'build';

Subdirectory:
  EXECUTE DBT PROJECT <name> PROJECT_ROOT = 'path/to/project';

From workspace:
  EXECUTE DBT PROJECT FROM WORKSPACE user$.public."WorkspaceName";
*/

