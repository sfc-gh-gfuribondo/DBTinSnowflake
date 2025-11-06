-- ============================================================================
-- SNOWFLAKE GIT INTEGRATION SETUP
-- ============================================================================
-- This worksheet guides you through setting up Git integration with Snowflake
-- to enable dbt Projects on Snowflake with Git repositories
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE DBT_DEMO_DB;
USE SCHEMA PUBLIC;
USE WAREHOUSE DBT_DEMO_WH;

-- ============================================================================
-- SECTION 1: GITHUB INTEGRATION
-- ============================================================================

-- Step 1: Create API Integration for GitHub
-- This allows Snowflake to authenticate with GitHub
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ALLOWED_AUTHENTICATION_SECRETS = ()
  ENABLED = TRUE
  COMMENT = 'API Integration for GitHub repositories';

-- View the created integration
DESCRIBE INTEGRATION GIT_API_INTEGRATION_GITHUB;

-- Show all API integrations
SHOW API INTEGRATIONS LIKE 'GIT_API_INTEGRATION%';

-- ============================================================================
-- Step 2: Create Git Repository Object (Public Repo)
-- ============================================================================

-- For PUBLIC GitHub repositories (no authentication needed)
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_GITHUB
  ORIGIN = 'https://github.com/YOUR_USERNAME/YOUR_REPO_NAME'
  COMMENT = 'dbt project repository from GitHub';

-- View the repository details
DESCRIBE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO;

-- Show all Git repositories
SHOW GIT REPOSITORIES IN DATABASE DBT_DEMO_DB;

-- ============================================================================
-- Step 3: Create Git Repository Object (Private Repo with Token)
-- ============================================================================

-- First, create a secret for your GitHub Personal Access Token (PAT)
-- Generate a PAT at: https://github.com/settings/tokens

CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  TYPE = password
  USERNAME = 'YOUR_GITHUB_USERNAME'
  PASSWORD = 'YOUR_GITHUB_PERSONAL_ACCESS_TOKEN'
  COMMENT = 'GitHub Personal Access Token for private repo access';

-- View the secret (password won't be shown)
DESCRIBE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT;

-- Update API Integration to allow the secret
ALTER API INTEGRATION GIT_API_INTEGRATION_GITHUB
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.GITHUB_PAT);

-- Create Git repository with authentication
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_PRIVATE_DBT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_GITHUB
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  ORIGIN = 'https://github.com/YOUR_USERNAME/YOUR_PRIVATE_REPO'
  COMMENT = 'Private dbt project repository from GitHub';

-- ============================================================================
-- SECTION 2: GITLAB INTEGRATION
-- ============================================================================

-- Step 1: Create API Integration for GitLab
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_GITLAB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://gitlab.com/')
  ALLOWED_AUTHENTICATION_SECRETS = ()
  ENABLED = TRUE
  COMMENT = 'API Integration for GitLab repositories';

-- Step 2: Create secret for GitLab access token
-- Generate token at: https://gitlab.com/-/profile/personal_access_tokens
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.GITLAB_TOKEN
  TYPE = password
  USERNAME = 'YOUR_GITLAB_USERNAME'
  PASSWORD = 'YOUR_GITLAB_ACCESS_TOKEN'
  COMMENT = 'GitLab Access Token';

-- Step 3: Update API Integration
ALTER API INTEGRATION GIT_API_INTEGRATION_GITLAB
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.GITLAB_TOKEN);

-- Step 4: Create GitLab repository
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_GITLAB_DBT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_GITLAB
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.GITLAB_TOKEN
  ORIGIN = 'https://gitlab.com/YOUR_USERNAME/YOUR_REPO'
  COMMENT = 'dbt project from GitLab';

-- ============================================================================
-- SECTION 3: BITBUCKET INTEGRATION
-- ============================================================================

-- Step 1: Create API Integration for Bitbucket
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_BITBUCKET
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://bitbucket.org/')
  ALLOWED_AUTHENTICATION_SECRETS = ()
  ENABLED = TRUE
  COMMENT = 'API Integration for Bitbucket repositories';

-- Step 2: Create secret for Bitbucket
-- Generate app password at: https://bitbucket.org/account/settings/app-passwords/
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.BITBUCKET_CREDENTIALS
  TYPE = password
  USERNAME = 'YOUR_BITBUCKET_USERNAME'
  PASSWORD = 'YOUR_BITBUCKET_APP_PASSWORD'
  COMMENT = 'Bitbucket App Password';

-- Step 3: Update API Integration
ALTER API INTEGRATION GIT_API_INTEGRATION_BITBUCKET
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.BITBUCKET_CREDENTIALS);

-- Step 4: Create Bitbucket repository
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_BITBUCKET_DBT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_BITBUCKET
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.BITBUCKET_CREDENTIALS
  ORIGIN = 'https://bitbucket.org/YOUR_USERNAME/YOUR_REPO'
  COMMENT = 'dbt project from Bitbucket';

-- ============================================================================
-- SECTION 4: AZURE DEVOPS INTEGRATION
-- ============================================================================

-- Step 1: Create API Integration for Azure DevOps
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_AZURE
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://dev.azure.com/')
  ALLOWED_AUTHENTICATION_SECRETS = ()
  ENABLED = TRUE
  COMMENT = 'API Integration for Azure DevOps repositories';

-- Step 2: Create secret for Azure DevOps
-- Generate PAT at: https://dev.azure.com/YOUR_ORG/_usersSettings/tokens
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.AZURE_PAT
  TYPE = password
  USERNAME = 'YOUR_AZURE_USERNAME'
  PASSWORD = 'YOUR_AZURE_PAT'
  COMMENT = 'Azure DevOps Personal Access Token';

-- Step 3: Update API Integration
ALTER API INTEGRATION GIT_API_INTEGRATION_AZURE
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.AZURE_PAT);

-- Step 4: Create Azure DevOps repository
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_AZURE_DBT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_AZURE
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.AZURE_PAT
  ORIGIN = 'https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_git/YOUR_REPO'
  COMMENT = 'dbt project from Azure DevOps';

-- ============================================================================
-- SECTION 5: FETCH AND VERIFY GIT REPOSITORY
-- ============================================================================

-- Fetch the latest changes from the Git repository
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO FETCH;

-- List branches in the repository
SHOW BRANCHES IN GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO;

-- List tags in the repository
SHOW TAGS IN GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO;

-- List files in the repository (from main branch)
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main;

-- List files in a specific directory
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main/models;

-- View a specific file content
SELECT $1 FROM @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main/dbt_project.yml;

-- ============================================================================
-- SECTION 6: CREATE DBT PROJECT FROM GIT REPOSITORY
-- ============================================================================

-- Create a dbt project object from the Git repository
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  FROM GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO
  GIT_BRANCH = 'main'
  COMMENT = 'dbt project for analytics';

-- Describe the dbt project
DESCRIBE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Show all dbt projects
SHOW DBT PROJECTS IN DATABASE DBT_DEMO_DB;

-- Show versions (commits) in the dbt project
SHOW VERSIONS IN DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- ============================================================================
-- SECTION 7: EXECUTE DBT PROJECT FROM GIT
-- ============================================================================

-- Now you can execute the dbt project!
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';

-- Run with specific models
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select staging.* --target dev';

-- Run tests
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'test --target dev';

-- Build everything
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'build --target prod';

-- ============================================================================
-- SECTION 8: UPDATE DBT PROJECT FROM GIT
-- ============================================================================

-- Fetch latest changes from Git
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO FETCH;

-- Update dbt project to use a different branch
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_BRANCH = 'develop';

-- Update dbt project to use a specific tag/version
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_TAG = 'v1.0.0';

-- Update dbt project to use a specific commit
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_COMMIT = 'abc123def456...';

-- ============================================================================
-- SECTION 9: GRANT PERMISSIONS
-- ============================================================================

-- Grant usage on API Integration
GRANT USAGE ON INTEGRATION GIT_API_INTEGRATION_GITHUB TO ROLE DEVELOPER_ROLE;

-- Grant usage on Git repository
GRANT USAGE ON GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO TO ROLE DEVELOPER_ROLE;

-- Grant usage on dbt project
GRANT USAGE ON DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT TO ROLE DEVELOPER_ROLE;

-- Grant read on secret (for authentication)
GRANT READ ON SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT TO ROLE DEVELOPER_ROLE;

-- ============================================================================
-- SECTION 10: MONITORING AND TROUBLESHOOTING
-- ============================================================================

-- Check API Integration status
DESCRIBE INTEGRATION GIT_API_INTEGRATION_GITHUB;

-- Verify Git repository configuration
DESCRIBE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO;

-- Check last fetch time
SELECT 
    NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    ORIGIN,
    TYPE,
    OWNER,
    COMMENT
FROM INFORMATION_SCHEMA.GIT_REPOSITORIES
WHERE DATABASE_NAME = 'DBT_DEMO_DB';

-- View dbt project details
SELECT 
    NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    GIT_REPOSITORY,
    GIT_BRANCH,
    GIT_TAG,
    OWNER,
    COMMENT
FROM INFORMATION_SCHEMA.DBT_PROJECTS
WHERE DATABASE_NAME = 'DBT_DEMO_DB';

-- Check secret existence (won't show password)
SHOW SECRETS IN DATABASE DBT_DEMO_DB;

-- Test repository access by listing files
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO/branches/main;

-- ============================================================================
-- SECTION 11: CLEANUP (IF NEEDED)
-- ============================================================================

-- Drop dbt project
-- DROP DBT PROJECT IF EXISTS DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Drop Git repository
-- DROP GIT REPOSITORY IF EXISTS DBT_DEMO_DB.PUBLIC.MY_DBT_GIT_REPO;

-- Drop secret
-- DROP SECRET IF EXISTS DBT_DEMO_DB.PUBLIC.GITHUB_PAT;

-- Drop API Integration
-- DROP API INTEGRATION IF EXISTS GIT_API_INTEGRATION_GITHUB;

-- ============================================================================
-- SECTION 12: COMPLETE EXAMPLE WORKFLOW
-- ============================================================================

-- EXAMPLE: Complete setup for a GitHub repository
-- Replace placeholders with your actual values

-- 1. Create API Integration
CREATE OR REPLACE API INTEGRATION MY_GITHUB_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/YOUR_ORG/')
  ENABLED = TRUE;

-- 2. Create Secret (for private repos)
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.MY_GITHUB_SECRET
  TYPE = password
  USERNAME = 'your_github_username'
  PASSWORD = 'ghp_your_personal_access_token_here';

-- 3. Update API Integration with secret
ALTER API INTEGRATION MY_GITHUB_INTEGRATION
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.MY_GITHUB_SECRET);

-- 4. Create Git Repository
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_COMPANY_DBT_REPO
  API_INTEGRATION = MY_GITHUB_INTEGRATION
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.MY_GITHUB_SECRET
  ORIGIN = 'https://github.com/YOUR_ORG/dbt-project';

-- 5. Fetch repository content
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_COMPANY_DBT_REPO FETCH;

-- 6. Verify files exist
LS @DBT_DEMO_DB.PUBLIC.MY_COMPANY_DBT_REPO/branches/main;

-- 7. Create dbt project
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.PRODUCTION_DBT_PROJECT
  FROM GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_COMPANY_DBT_REPO
  GIT_BRANCH = 'main';

-- 8. Execute dbt project
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.PRODUCTION_DBT_PROJECT
  ARGS = 'run --target prod';

-- 9. Schedule with tasks
CREATE OR REPLACE TASK DAILY_DBT_RUN
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.PRODUCTION_DBT_PROJECT 
  ARGS = 'run --target prod';

ALTER TASK DAILY_DBT_RUN RESUME;

-- ============================================================================
-- END OF WORKSHEET
-- ============================================================================

/*
QUICK REFERENCE:

1. CREATE API INTEGRATION:
   - Specify git provider (GitHub, GitLab, Bitbucket, Azure DevOps)
   - Set allowed prefixes for security
   - Enable the integration

2. CREATE SECRET (for private repos):
   - Generate Personal Access Token in your Git provider
   - Create secret with username and token
   - Add secret to API Integration

3. CREATE GIT REPOSITORY:
   - Reference the API Integration
   - Provide Git credentials (for private repos)
   - Specify the repository URL

4. CREATE DBT PROJECT:
   - Reference the Git Repository
   - Specify branch, tag, or commit
   - Execute with EXECUTE DBT PROJECT

TROUBLESHOOTING:

- "Integration not found": Check API Integration exists and is enabled
- "Authentication failed": Verify Personal Access Token is valid
- "Repository not found": Ensure URL is correct and accessible
- "Permission denied": Grant USAGE on integration and repository
- "File not found": Run ALTER GIT REPOSITORY ... FETCH first

For more information:
https://docs.snowflake.com/en/developer-guide/git/git-overview
https://docs.snowflake.com/en/sql-reference/sql/create-api-integration
https://docs.snowflake.com/en/sql-reference/sql/create-git-repository
*/

