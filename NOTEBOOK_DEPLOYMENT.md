# 📓 Snowflake Notebook Deployment - dbt Package Lister

## ✅ Successfully Deployed!

**Notebook Name:** `dbt_package_lister`  
**Database:** DBT_DEMO_DB  
**Schema:** PUBLIC  
**Stage:** @notebooks/dbt_package_lister  
**Warehouse:** DBT_DEMO_WH

---

## 🌐 Access Your Notebook

### Direct URL:
```
https://app.snowflake.com/SFSENORTHAMERICA/demo_gfuribondo/#/notebooks/XR4TI.PUBLIC.DBT_PACKAGE_LISTER
```

### Via Snowflake UI:
1. Log in to Snowflake: https://app.snowflake.com
2. Navigate to **Projects** → **Notebooks**
3. Look for **`DBT_PACKAGE_LISTER`** in the list
4. Click to open

---

## 📋 What This Notebook Does

The notebook demonstrates:

1. **Lists dbt Project Information**
   - Shows dbt configuration
   - Displays database and warehouse used

2. **Queries dbt-Created Objects**
   - Lists all tables and views created by dbt
   - Shows schema organization (PUBLIC, STAGING, MARTS)

3. **Shows dbt Packages**
   - Displays configured packages (dbt_utils)
   - Shows package versions and details

4. **Lists Available dbt Commands**
   - Reference guide for dbt CLI commands
   - Helpful for demo presentations

---

## 🎯 Notebook Contents

### Cell 1: Project Information
Displays welcome message and dbt project overview

### Cell 2: Query dbt Objects
Uses Snowpark to query all dbt-created tables and views:
```python
SELECT 
    TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM DBT_DEMO_DB.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA IN ('PUBLIC', 'PUBLIC_STAGING', 'PUBLIC_MARTS')
```

### Cell 3: dbt Configuration
Shows:
- dbt version: 1.7.1
- Adapter: dbt-snowflake
- Database: DBT_DEMO_DB
- Warehouse: DBT_DEMO_WH

### Cell 4: Configured Packages
Lists packages from `packages.yml`:
- dbt-labs/dbt_utils (v1.1.1)

### Cell 5: Package Details
Shows detailed information about dbt_utils package

### Cell 6: Available Commands
Reference guide for all dbt commands

---

## 🚀 Running the Notebook

### In Snowflake UI:
1. Open the notebook URL
2. Click **Run All** button at the top
3. View results in each cell

### Via Snow CLI:
```bash
# Execute the notebook
cd /Users/gfuribondo/Cursor/dbtinSnowflake/notebooks
snow notebook execute dbt_package_lister --connection sql_executor_keypair

# Get notebook URL
snow notebook get-url dbt_package_lister --connection sql_executor_keypair

# Open in browser
snow notebook open dbt_package_lister --connection sql_executor_keypair
```

---

## 🔄 Updating the Notebook

### 1. Edit Locally:
```bash
# Edit the notebook file
open /Users/gfuribondo/Cursor/dbtinSnowflake/notebooks/dbt_package_lister.ipynb
```

### 2. Redeploy:
```bash
cd /Users/gfuribondo/Cursor/dbtinSnowflake/notebooks
snow notebook deploy dbt_package_lister --connection sql_executor_keypair --replace
```

---

## 📊 What You Can Query in the Notebook

### dbt Seed Tables (Raw Data):
```python
session.sql("SELECT * FROM DBT_DEMO_DB.PUBLIC.CUSTOMERS LIMIT 5").show()
session.sql("SELECT * FROM DBT_DEMO_DB.PUBLIC.ORDERS LIMIT 5").show()
session.sql("SELECT * FROM DBT_DEMO_DB.PUBLIC.PRODUCTS LIMIT 5").show()
```

### dbt Staging Views:
```python
session.sql("SELECT * FROM DBT_DEMO_DB.PUBLIC_STAGING.STG_CUSTOMERS LIMIT 5").show()
session.sql("SELECT * FROM DBT_DEMO_DB.PUBLIC_STAGING.STG_ORDERS LIMIT 5").show()
```

### dbt Marts Tables (Analytics):
```python
# Customer analytics
session.sql("""
    SELECT FULL_NAME, TOTAL_ORDERS, TOTAL_SPENT, AVG_ORDER_VALUE
    FROM DBT_DEMO_DB.PUBLIC_MARTS.CUSTOMER_ORDERS
    WHERE FULL_NAME IS NOT NULL
    ORDER BY TOTAL_SPENT DESC
""").show()

# Monthly revenue
session.sql("""
    SELECT ORDER_MONTH, STATUS, ORDER_COUNT, TOTAL_REVENUE
    FROM DBT_DEMO_DB.PUBLIC_MARTS.ORDER_SUMMARY
    WHERE ORDER_MONTH IS NOT NULL
    ORDER BY ORDER_MONTH DESC
""").show()
```

---

## 💡 Use Cases for This Notebook

### 1. **Demo Presentation**
- Show dbt objects directly in Snowflake
- Interactive querying during presentation
- Visual proof that dbt created the objects

### 2. **Training & Education**
- Teach team members about dbt structure
- Show data lineage concepts
- Interactive learning environment

### 3. **Documentation**
- Living documentation of dbt project
- Always up-to-date with actual Snowflake objects
- Self-service for stakeholders

### 4. **Monitoring**
- Check what objects exist
- Verify dbt deployments
- Quick health check

---

## 🎨 Customization Ideas

### Add More Cells:
```python
# Query customer metrics
session.sql("""
    SELECT 
        COUNT(DISTINCT CUSTOMER_ID) as total_customers,
        SUM(TOTAL_SPENT) as total_revenue,
        AVG(TOTAL_SPENT) as avg_customer_value
    FROM DBT_DEMO_DB.PUBLIC_MARTS.CUSTOMER_ORDERS
    WHERE CUSTOMER_ID IS NOT NULL
""").show()

# Create visualizations
import pandas as pd
import plotly.express as px

df = session.sql("""
    SELECT ORDER_MONTH, SUM(TOTAL_REVENUE) as revenue
    FROM DBT_DEMO_DB.PUBLIC_MARTS.ORDER_SUMMARY
    GROUP BY ORDER_MONTH
    ORDER BY ORDER_MONTH
""").to_pandas()

fig = px.line(df, x='ORDER_MONTH', y='REVENUE', title='Monthly Revenue Trend')
fig.show()
```

---

## 📁 File Locations

- **Notebook File:** `/Users/gfuribondo/Cursor/dbtinSnowflake/notebooks/dbt_package_lister.ipynb`
- **Configuration:** `/Users/gfuribondo/Cursor/dbtinSnowflake/notebooks/snowflake.yml`
- **Python Script:** `/Users/gfuribondo/Cursor/dbtinSnowflake/notebooks/dbt_package_lister.py`
- **Snowflake Stage:** `@DBT_DEMO_DB.PUBLIC.NOTEBOOKS/dbt_package_lister`

---

## 🔍 Troubleshooting

### Notebook Won't Execute?
```bash
# Check notebook status
snow notebook get-url dbt_package_lister --connection sql_executor_keypair

# Redeploy
snow notebook deploy dbt_package_lister --connection sql_executor_keypair --replace
```

### Can't Find Notebook in UI?
- Go to: **Projects** → **Notebooks**
- Search for: `DBT_PACKAGE_LISTER`
- Filter by database: `XR4TI` or `DBT_DEMO_DB`

### Permission Issues?
Ensure your role has:
```sql
GRANT USAGE ON DATABASE DBT_DEMO_DB TO ROLE YOUR_ROLE;
GRANT USAGE ON WAREHOUSE DBT_DEMO_WH TO ROLE YOUR_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA DBT_DEMO_DB.PUBLIC TO ROLE YOUR_ROLE;
```

---

## 🎯 Next Steps

1. **Open the notebook** in Snowflake UI
2. **Run all cells** to see dbt objects
3. **Add custom queries** for your analysis
4. **Share with team** for collaboration
5. **Use in demos** to show dbt + Snowflake integration

---

## 📚 Related Documentation

- **dbt Project README:** `/Users/gfuribondo/Cursor/dbtinSnowflake/README.md`
- **Demo Guide:** `/Users/gfuribondo/Cursor/dbtinSnowflake/DEMO_GUIDE.md`
- **Deployment Summary:** `/Users/gfuribondo/Cursor/dbtinSnowflake/DEPLOYMENT_SUMMARY.md`

---

**✨ Your notebook is live and ready to use!**

Open it here: https://app.snowflake.com/SFSENORTHAMERICA/demo_gfuribondo/#/notebooks/XR4TI.PUBLIC.DBT_PACKAGE_LISTER

---

*Deployed: November 6, 2025*  
*Notebook ID: XR4TI.PUBLIC.DBT_PACKAGE_LISTER*

