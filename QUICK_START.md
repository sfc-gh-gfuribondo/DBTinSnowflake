# 🚀 Quick Start - 5 Minutes to Running

## Prerequisites
- Snowflake account
- Python 3.8+

## Steps

### 1. Install dbt
```bash
pip install dbt-snowflake
```

### 2. Setup Snowflake
Run `setup/snowflake_setup.sql` in your Snowflake account

### 3. Configure Connection
```bash
export SNOWFLAKE_ACCOUNT="your_account.region"
export SNOWFLAKE_USER="your_username"
export SNOWFLAKE_PASSWORD="your_password"
```

### 4. Run Demo
```bash
cd /path/to/dbtinSnowflake
dbt debug          # Verify connection
dbt deps           # Install packages
dbt seed           # Load sample data
dbt run            # Build models
dbt test           # Run tests
dbt docs generate  # Generate docs
dbt docs serve     # View docs
```

## What Gets Created

### In Snowflake:
- **Database:** `DBT_DEMO_DB`
- **Schemas:** `PUBLIC`, `STAGING`, `MARTS`
- **Tables/Views:**
  - Seeds: customers, orders, products
  - Staging: stg_customers, stg_orders, stg_products
  - Marts: customer_orders, order_summary, product_performance

### Results to Query:
```sql
-- Top customers
SELECT * FROM DBT_DEMO_DB.MARTS.CUSTOMER_ORDERS 
ORDER BY total_spent DESC LIMIT 5;

-- Monthly revenue
SELECT * FROM DBT_DEMO_DB.MARTS.ORDER_SUMMARY 
ORDER BY order_month DESC;

-- Inventory status
SELECT * FROM DBT_DEMO_DB.MARTS.PRODUCT_PERFORMANCE 
ORDER BY total_inventory_value DESC;
```

## Troubleshooting

**Connection failed?**
```bash
dbt debug --config-dir .
```

**Need to reset?**
```bash
dbt clean
dbt deps
dbt build
```

## Next Steps
- Read `README.md` for detailed documentation
- Check `DEMO_GUIDE.md` for presentation guide
- Explore the models in `models/` directory

---
That's it! You now have a working dbt + Snowflake environment. 🎉

