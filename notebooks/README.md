# 📓 Snowflake Notebook - dbt Package Lister

## 🎯 Quick Access

**Notebook URL:** https://app.snowflake.com/SFSENORTHAMERICA/demo_gfuribondo/#/notebooks/XR4TI.PUBLIC.DBT_PACKAGE_LISTER

**Notebook Name:** `DBT_PACKAGE_LISTER`  
**Location:** XR4TI.PUBLIC (Database.Schema)

---

## 🚀 What It Does

This Snowflake notebook:
- ✅ Lists all dbt-created objects in Snowflake
- ✅ Shows dbt configuration and packages
- ✅ Displays dbt package information (dbt_utils)
- ✅ Provides reference for dbt commands
- ✅ Can query dbt tables and views interactively

---

## 📂 Files in This Directory

| File | Description |
|------|-------------|
| `dbt_package_lister.ipynb` | Jupyter notebook (deployed to Snowflake) |
| `dbt_package_lister.py` | Python script version |
| `snowflake.yml` | Snowflake CLI configuration |
| `README.md` | This file |

---

## 🔄 Common Commands

### Open Notebook in Browser
```bash
cd /Users/gfuribondo/Cursor/dbtinSnowflake/notebooks
snow notebook open dbt_package_lister --connection sql_executor_keypair
```

### Redeploy After Changes
```bash
snow notebook deploy dbt_package_lister --connection sql_executor_keypair --replace
```

### Get Notebook URL
```bash
snow notebook get-url dbt_package_lister --connection sql_executor_keypair
```

---

## 🎓 How to Use

1. **Open** the notebook URL in your browser
2. **Click "Run All"** to execute all cells
3. **View results** - see all dbt objects listed
4. **Add custom cells** to query your data
5. **Save and share** with your team

---

## 💡 Example Queries to Add

### Query Customer Analytics
```python
session.sql("""
    SELECT 
        FULL_NAME,
        TOTAL_ORDERS,
        TOTAL_SPENT,
        AVG_ORDER_VALUE
    FROM DBT_DEMO_DB.PUBLIC_MARTS.CUSTOMER_ORDERS
    WHERE FULL_NAME IS NOT NULL
    ORDER BY TOTAL_SPENT DESC
    LIMIT 10
""").show()
```

### Show Monthly Revenue
```python
session.sql("""
    SELECT 
        ORDER_MONTH,
        SUM(TOTAL_REVENUE) as MONTHLY_REVENUE
    FROM DBT_DEMO_DB.PUBLIC_MARTS.ORDER_SUMMARY
    GROUP BY ORDER_MONTH
    ORDER BY ORDER_MONTH DESC
""").show()
```

---

## 📚 Documentation

For more details, see: `/Users/gfuribondo/Cursor/dbtinSnowflake/NOTEBOOK_DEPLOYMENT.md`

---

**🎉 Your dbt notebook is ready to use in Snowflake!**

