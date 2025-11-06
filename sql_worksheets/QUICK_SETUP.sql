-- ============================================================================
-- QUICK SETUP: Git Integration for Snowflake dbt Projects
-- ============================================================================
-- Copy and run this complete example (replace YOUR_* placeholders)
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE DBT_DEMO_DB;
USE WAREHOUSE DBT_DEMO_WH;

-- ============================================================================
-- STEP 1: Create API Integration (GitHub Example)
-- ============================================================================
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE
  COMMENT = 'API Integration for GitHub repositories';

-- ============================================================================
-- STEP 2: Create Secret with Your GitHub Personal Access Token
-- Generate token at: https://github.com/settings/tokens
-- Required scope: 'repo' (Full control of private repositories)
-- ============================================================================
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  TYPE = password
  USERNAME = 'YOUR_GITHUB_USERNAME'  -- Replace with your GitHub username
  PASSWORD = 'YOUR_GITHUB_TOKEN'     -- Replace with your ghp_xxx token
  COMMENT = 'GitHub Personal Access Token for dbt repo';

-- ============================================================================
-- STEP 3: Link Secret to API Integration
-- ============================================================================
ALTER API INTEGRATION GIT_API_INTEGRATION_GITHUB
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.GITHUB_PAT);

-- ============================================================================
-- STEP 4: Create Git Repository Object
-- ============================================================================
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_GITHUB
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  ORIGIN = 'https://github.com/YOUR_ORG/YOUR_REPO'  -- Replace with your repo URL
  COMMENT = 'dbt project repository';

-- ============================================================================
-- STEP 5: Fetch Repository Content
-- ============================================================================
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO FETCH;

-- ============================================================================
-- STEP 6: Verify Repository Access (List Files)
-- ============================================================================
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main;

-- ============================================================================
-- STEP 7: Create dbt Project from Git Repository
-- ============================================================================
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  FROM GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO
  GIT_BRANCH = 'main'
  COMMENT = 'Production dbt project';

-- ============================================================================
-- STEP 8: Execute dbt Project
-- ============================================================================
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';

-- ============================================================================
-- DONE! Your dbt project is now connected to Git and ready to run.
-- ============================================================================

-- View project details
DESCRIBE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Show all versions (commits)
SHOW VERSIONS IN DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- ============================================================================
-- BONUS: Schedule Daily Production Runs
-- ============================================================================
CREATE OR REPLACE TASK DAILY_DBT_RUN
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --target prod';

-- Start the task
ALTER TASK DAILY_DBT_RUN RESUME;

-- ============================================================================
-- TROUBLESHOOTING COMMANDS
-- ============================================================================

-- Check if integration exists
SHOW API INTEGRATIONS;

-- Check if repository exists
SHOW GIT REPOSITORIES;

-- Check if secret exists
SHOW SECRETS;

-- Test repository access
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main;

-- View dbt project
SHOW DBT PROJECTS;

