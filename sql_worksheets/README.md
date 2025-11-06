# SQL Worksheets for dbt + Snowflake

This directory contains SQL worksheets for working with dbt projects in Snowflake.

## 📁 Files

### `execute_dbt_project_examples.sql`
Comprehensive examples of the `EXECUTE DBT PROJECT` command based on [Snowflake's official documentation](https://docs.snowflake.com/en/sql-reference/sql/execute-dbt-project).

**What's Inside:**
- 43 complete, runnable examples
- Basic to advanced usage patterns
- Production workflow examples
- Task scheduling and automation
- Error handling and monitoring
- Model selection strategies
- Subdirectory project execution

## 🚀 Quick Start

### Open in Snowflake UI

1. Log into Snowflake: https://app.snowflake.com
2. Go to **Worksheets**
3. Create a new worksheet
4. Copy content from `execute_dbt_project_examples.sql`
5. Run sections individually (highlight and execute)

### Or Use Snow CLI

```bash
# Execute individual commands
snow sql -f sql_worksheets/execute_dbt_project_examples.sql --connection sql_executor_keypair

# Or run specific queries
snow sql -q "EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT ARGS = 'run --target dev';" --connection sql_executor_keypair
```

## 📋 Worksheet Sections

The main worksheet is organized into 14 sections:

1. **Create dbt Project Object** - Setup from Git
2. **Basic Commands** - Simple execution examples
3. **Model Selection** - Select specific models or groups
4. **Different dbt Commands** - run, test, seed, build, etc.
5. **Advanced Options** - Full refresh, threads, fail fast
6. **Subdirectory Projects** - Multiple projects in one repo
7. **Workspace Execution** - Run from Snowflake workspaces
8. **Capturing Results** - Parse and analyze output
9. **Production Scheduling** - Tasks and automation
10. **Error Handling** - Exception management
11. **Querying Results** - Parse execution output
12. **Management Commands** - SHOW, DESCRIBE, etc.
13. **Real-World Workflow** - Complete production pipeline
14. **Cleanup Commands** - Task and project management

## 🎯 Common Use Cases

### Run dbt Models
```sql
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --target dev';
```

### Run Specific Models
```sql
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'run --select stg_customers customer_orders --target dev';
```

### Run Tests
```sql
EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  ARGS = 'test --target prod';
```

### Schedule Daily Runs
```sql
CREATE OR REPLACE TASK DAILY_DBT_RUN
  WAREHOUSE = DBT_DEMO_WH
  SCHEDULE = 'USING CRON 0 2 * * * America/Los_Angeles'
AS
  EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT 
  ARGS = 'run --target prod';

ALTER TASK DAILY_DBT_RUN RESUME;
```

## ⚠️ Important Notes

### Preview Feature
`EXECUTE DBT PROJECT` is currently in **Preview** and available to all accounts. Features may change before general availability.

### Prerequisites

1. **Create dbt Project First:**
```sql
CREATE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
  FROM GIT REPOSITORY my_git_integration
  PATH '/dbt_project';
```

2. **Required Permissions:**
   - USAGE on dbt project object
   - USAGE on database and schema
   - Privileges on target objects
   - USAGE on warehouse

3. **profiles.yml Configuration:**
   - Must be properly configured in your dbt project
   - Specify role, warehouse, database, schema
   - Can use different targets (dev, prod)

## 📊 Output Columns

| Column | Description |
|--------|-------------|
| `0|1 Success` | TRUE if successful, FALSE if failed |
| `EXCEPTION` | Error message if failed, "None" if successful |
| `STDOUT` | Standard output from dbt execution |
| `OUTPUT_ARCHIVE_URL` | URL to artifacts and logs |

## 🔍 Monitoring Executions

### Check Task History
```sql
SELECT 
    NAME,
    STATE,
    SCHEDULED_TIME,
    COMPLETED_TIME,
    RETURN_VALUE
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME = 'DAILY_DBT_RUN'
ORDER BY SCHEDULED_TIME DESC
LIMIT 10;
```

### Parse Execution Results
```sql
WITH execution AS (
  SELECT * FROM (
    EXECUTE DBT PROJECT DBT_DEMO_DB.PUBLIC.MY_DBT_PROJECT
    ARGS = 'run --target dev'
  )
)
SELECT
  CASE WHEN "0|1 Success" = TRUE THEN '✅ SUCCESS' ELSE '❌ FAILED' END as STATUS,
  EXCEPTION as ERROR,
  OUTPUT_ARCHIVE_URL as ARTIFACTS
FROM execution;
```

## 🎓 Learning Path

1. **Start with Section 2** - Basic Commands
2. **Try Section 3** - Model Selection
3. **Explore Section 4** - Different dbt Commands
4. **Advanced: Section 9** - Production Scheduling
5. **Production: Section 13** - Complete Workflow

## 📚 Additional Resources

- [Snowflake dbt Projects Documentation](https://docs.snowflake.com/en/sql-reference/sql/execute-dbt-project)
- [CREATE DBT PROJECT](https://docs.snowflake.com/en/sql-reference/sql/create-dbt-project)
- [dbt Documentation](https://docs.getdbt.com/)
- Project README: `../README.md`
- Demo Guide: `../DEMO_GUIDE.md`

## 💡 Tips

1. **Start with dev target** - Test commands against dev before prod
2. **Use model selection** - Run only what you need for faster iterations
3. **Implement tasks** - Automate production runs with Snowflake tasks
4. **Monitor execution** - Check OUTPUT_ARCHIVE_URL for logs and artifacts
5. **Handle errors** - Use TRY/CATCH blocks for robust workflows

## 🆘 Troubleshooting

### "dbt project not found"
- Verify project exists: `SHOW DBT PROJECTS;`
- Check permissions: `SHOW GRANTS ON DBT PROJECT <name>;`

### "No profiles.yml found"
- Ensure profiles.yml exists in project root
- Check PROJECT_ROOT parameter if in subdirectory

### Task execution fails
- Check task history: `SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY());`
- Verify warehouse is running
- Confirm role has necessary privileges

---

**Ready to use!** Open the worksheet and start executing dbt commands in Snowflake.

