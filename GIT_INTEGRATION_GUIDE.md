# 🔗 Git Integration Setup for Snowflake

Complete guide to setting up Git integration with Snowflake to enable dbt Projects.

---

## 📋 Overview

This guide shows you how to:
1. Create an API Integration for Git providers
2. Set up authentication with secrets
3. Create Git repository objects in Snowflake
4. Create dbt projects from Git repositories
5. Execute dbt projects stored in Git

---

## 🚀 Quick Start (GitHub Example)

### Step 1: Create API Integration
```sql
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE;
```

### Step 2: Create Secret for Authentication
```sql
-- Generate a Personal Access Token at: https://github.com/settings/tokens
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  TYPE = password
  USERNAME = 'your_github_username'
  PASSWORD = 'ghp_your_personal_access_token_here';

-- Update API Integration to allow the secret
ALTER API INTEGRATION GIT_API_INTEGRATION_GITHUB
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.GITHUB_PAT);
```

### Step 3: Create Git Repository Object
```sql
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO
  API_INTEGRATION = GIT_API_INTEGRATION_GITHUB
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  ORIGIN = 'https://github.com/YOUR_USERNAME/YOUR_REPO';

-- Fetch the repository content
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO FETCH;
```

### Step 4: Create dbt Project
```sql
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  FROM GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO
  GIT_BRANCH = 'main';
```

### Step 5: Execute dbt Project
```sql
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';
```

---

## 🔐 Setting Up Authentication

### GitHub Personal Access Token (PAT)

1. **Go to GitHub Settings:**
   - Visit: https://github.com/settings/tokens
   - Click "Generate new token (classic)"

2. **Configure Token:**
   - Name: "Snowflake dbt Integration"
   - Expiration: Choose appropriate duration
   - Scopes: Select `repo` (Full control of private repositories)

3. **Copy Token:**
   - Save the token immediately (you won't see it again)
   - Format: `ghp_xxxxxxxxxxxxxxxxxxxx`

4. **Create Secret in Snowflake:**
```sql
CREATE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  TYPE = password
  USERNAME = 'your_github_username'
  PASSWORD = 'ghp_your_token_here';
```

### GitLab Access Token

1. **Go to GitLab:**
   - Visit: https://gitlab.com/-/profile/personal_access_tokens
   - Click "Add new token"

2. **Configure Token:**
   - Name: "Snowflake Integration"
   - Scopes: `read_repository`, `write_repository`

3. **Create Secret:**
```sql
CREATE SECRET DBT_DEMO_DB.PUBLIC.GITLAB_TOKEN
  TYPE = password
  USERNAME = 'your_gitlab_username'
  PASSWORD = 'glpat-your_token_here';
```

### Bitbucket App Password

1. **Go to Bitbucket:**
   - Visit: https://bitbucket.org/account/settings/app-passwords/
   - Click "Create app password"

2. **Configure:**
   - Label: "Snowflake Integration"
   - Permissions: `Repositories - Read`, `Repositories - Write`

3. **Create Secret:**
```sql
CREATE SECRET DBT_DEMO_DB.PUBLIC.BITBUCKET_CREDENTIALS
  TYPE = password
  USERNAME = 'your_bitbucket_username'
  PASSWORD = 'your_app_password_here';
```

### Azure DevOps PAT

1. **Go to Azure DevOps:**
   - Visit: https://dev.azure.com/YOUR_ORG/_usersSettings/tokens
   - Click "New Token"

2. **Configure:**
   - Name: "Snowflake Integration"
   - Scopes: `Code - Read`, `Code - Write`

3. **Create Secret:**
```sql
CREATE SECRET DBT_DEMO_DB.PUBLIC.AZURE_PAT
  TYPE = password
  USERNAME = 'your_azure_username'
  PASSWORD = 'your_pat_here';
```

---

## 📦 Supported Git Providers

### ✅ GitHub
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/YOUR_ORG/')
  ENABLED = TRUE;
```

### ✅ GitLab
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_GITLAB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://gitlab.com/YOUR_ORG/')
  ENABLED = TRUE;
```

### ✅ Bitbucket
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_BITBUCKET
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://bitbucket.org/YOUR_ORG/')
  ENABLED = TRUE;
```

### ✅ Azure DevOps
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_AZURE
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://dev.azure.com/YOUR_ORG/')
  ENABLED = TRUE;
```

### ✅ GitHub Enterprise
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_GHE
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.your-company.com/')
  ENABLED = TRUE;
```

### ✅ Self-Hosted GitLab
```sql
CREATE API INTEGRATION GIT_API_INTEGRATION_GITLAB_SELF
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://gitlab.your-company.com/')
  ENABLED = TRUE;
```

---

## 🔍 Verification and Testing

### Verify API Integration
```sql
DESCRIBE INTEGRATION GIT_API_INTEGRATION_GITHUB;
SHOW API INTEGRATIONS;
```

### Test Git Repository Access
```sql
-- List files in repository
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_REPO/branches/main;

-- List files in specific directory
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_REPO/branches/main/models;

-- View file content
SELECT $1 FROM @DBT_DEMO_DB.PUBLIC.MY_DBT_REPO/branches/main/dbt_project.yml;

-- Show all branches
SHOW BRANCHES IN GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO;

-- Show all tags
SHOW TAGS IN GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO;
```

### Verify dbt Project
```sql
-- Describe dbt project
DESCRIBE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Show all versions (commits)
SHOW VERSIONS IN DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT;

-- Execute a simple command
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'debug';
```

---

## 🔄 Managing Git Repository

### Fetch Latest Changes
```sql
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO FETCH;
```

### Switch Branches
```sql
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_BRANCH = 'develop';
```

### Use Specific Tag
```sql
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_TAG = 'v1.0.0';
```

### Use Specific Commit
```sql
ALTER DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  SET GIT_COMMIT = 'abc123def456789...';
```

---

## 🔐 Security Best Practices

### 1. Use Least Privilege
```sql
-- Create dedicated role for dbt
CREATE ROLE DBT_EXECUTOR;

-- Grant only necessary permissions
GRANT USAGE ON INTEGRATION GIT_API_INTEGRATION_GITHUB TO ROLE DBT_EXECUTOR;
GRANT USAGE ON GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO TO ROLE DBT_EXECUTOR;
GRANT USAGE ON DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT TO ROLE DBT_EXECUTOR;
GRANT READ ON SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT TO ROLE DBT_EXECUTOR;
```

### 2. Restrict API Integration Prefixes
```sql
-- Only allow specific organization
CREATE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/your-org/')  -- Specific org only
  ENABLED = TRUE;
```

### 3. Rotate Secrets Regularly
```sql
-- Update secret with new token
ALTER SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  SET PASSWORD = 'new_token_here';
```

### 4. Monitor Access
```sql
-- Check who has access to integration
SHOW GRANTS ON INTEGRATION GIT_API_INTEGRATION_GITHUB;

-- Check who has access to repository
SHOW GRANTS ON GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO;
```

---

## 🚨 Troubleshooting

### Issue: "Integration not found"
**Solution:**
```sql
-- Check if integration exists
SHOW API INTEGRATIONS;

-- Verify you have ACCOUNTADMIN role
USE ROLE ACCOUNTADMIN;

-- Recreate if needed
CREATE API INTEGRATION GIT_API_INTEGRATION_GITHUB
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE;
```

### Issue: "Authentication failed"
**Solution:**
```sql
-- Verify secret exists
SHOW SECRETS IN DATABASE DBT_DEMO_DB;

-- Check secret details (won't show password)
DESCRIBE SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT;

-- Verify token is still valid in GitHub
-- Generate new token if expired and update secret
ALTER SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT
  SET PASSWORD = 'new_token_here';
```

### Issue: "Repository not found"
**Solution:**
```sql
-- Verify URL is correct
DESCRIBE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO;

-- Test access to repository
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_REPO/branches/main;

-- Ensure repository URL doesn't end with .git
-- CORRECT: https://github.com/user/repo
-- WRONG:   https://github.com/user/repo.git
```

### Issue: "Permission denied"
**Solution:**
```sql
-- Grant necessary permissions
GRANT USAGE ON INTEGRATION GIT_API_INTEGRATION_GITHUB TO ROLE YOUR_ROLE;
GRANT USAGE ON GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO TO ROLE YOUR_ROLE;
GRANT READ ON SECRET DBT_DEMO_DB.PUBLIC.GITHUB_PAT TO ROLE YOUR_ROLE;
```

### Issue: "File not found in repository"
**Solution:**
```sql
-- Fetch latest changes
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.MY_DBT_REPO FETCH;

-- List files to verify structure
LS @DBT_DEMO_DB.PUBLIC.MY_DBT_REPO/branches/main;

-- Ensure dbt_project.yml exists in root or specify PROJECT_ROOT
```

---

## 📖 Complete Example Workflow

### Scenario: Production dbt Project from GitHub

```sql
-- 1. Create API Integration (once per Snowflake account)
CREATE OR REPLACE API INTEGRATION PROD_GITHUB_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-company/')
  ENABLED = TRUE;

-- 2. Create Secret for Authentication
CREATE OR REPLACE SECRET DBT_DEMO_DB.PUBLIC.PROD_GITHUB_SECRET
  TYPE = password
  USERNAME = 'dbt-service-account'
  PASSWORD = 'ghp_production_token_here';

-- 3. Link Secret to API Integration
ALTER API INTEGRATION PROD_GITHUB_INTEGRATION
  SET ALLOWED_AUTHENTICATION_SECRETS = (DBT_DEMO_DB.PUBLIC.PROD_GITHUB_SECRET);

-- 4. Create Git Repository
CREATE OR REPLACE GIT REPOSITORY DBT_DEMO_DB.PUBLIC.PROD_DBT_REPO
  API_INTEGRATION = PROD_GITHUB_INTEGRATION
  GIT_CREDENTIALS = DBT_DEMO_DB.PUBLIC.PROD_GITHUB_SECRET
  ORIGIN = 'https://github.com/my-company/dbt-analytics';

-- 5. Fetch Repository
ALTER GIT REPOSITORY DBT_DEMO_DB.PUBLIC.PROD_DBT_REPO FETCH;

-- 6. Verify Files
LS @DBT_DEMO_DB.PUBLIC.PROD_DBT_REPO/branches/main;

-- 7. Create dbt Project
CREATE OR REPLACE DBT PROJECT DBT_DEMO_DB.PUBLIC.PROD_DBT_PROJECT
  FROM GIT REPOSITORY DBT_DEMO_DB.PUBLIC.PROD_DBT_REPO
  GIT_BRANCH = 'main';

-- 8. Test Execution
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.PROD_DBT_PROJECT
  ARGS = 'debug';

-- 9. Run Production Build
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.PROD_DBT_PROJECT
  ARGS = 'build --target prod';

-- 10. Schedule Daily Runs
CREATE OR REPLACE TASK DAILY_PROD_DBT
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.PROD_DBT_PROJECT 
  ARGS = 'run --target prod';

ALTER TASK DAILY_PROD_DBT RESUME;
```

---

## 📚 Additional Resources

- **Snowflake Git Integration Docs:** https://docs.snowflake.com/en/developer-guide/git/git-overview
- **CREATE API INTEGRATION:** https://docs.snowflake.com/en/sql-reference/sql/create-api-integration
- **CREATE GIT REPOSITORY:** https://docs.snowflake.com/en/sql-reference/sql/create-git-repository
- **CREATE DBT PROJECT:** https://docs.snowflake.com/en/sql-reference/sql/create-dbt-project
- **EXECUTE DBT PROJECT:** https://docs.snowflake.com/en/sql-reference/sql/execute-dbt-project

## 📁 SQL Worksheet

Complete SQL examples: `/Users/gfuribondo/Cursor/dbtinSnowflake/sql_worksheets/git_integration_setup.sql`

---

**✨ You're now ready to use Git-based dbt projects in Snowflake!**

