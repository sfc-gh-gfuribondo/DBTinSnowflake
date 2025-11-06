# dbt + Snowflake Demo Project

A complete demonstration of using dbt (data build tool) with Snowflake for modern data transformation and analytics. This project follows the [Snowflake dbt Quickstart Guide](https://www.snowflake.com/en/developers/guides/dbt-projects-on-snowflake/?index=..%2F..index).

## 📋 Overview

This demo showcases:
- **Staging models** - Clean and prepare raw data
- **Marts models** - Business-level analytics tables
- **Data tests** - Ensure data quality
- **Documentation** - Auto-generated data documentation
- **Seeds** - Load CSV files as tables

## 🏗️ Project Structure

```
dbtinSnowflake/
├── models/
│   ├── staging/              # Staging layer (views)
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_products.sql
│   │   └── schema.yml
│   └── marts/                # Analytics layer (tables)
│       ├── customer_orders.sql
│       ├── order_summary.sql
│       ├── product_performance.sql
│       └── schema.yml
├── seeds/                    # Sample data CSV files
│   ├── customers.csv
│   ├── orders.csv
│   └── products.csv
├── tests/                    # Custom data tests
│   ├── assert_positive_order_amounts.sql
│   └── assert_valid_order_status.sql
├── macros/                   # Reusable SQL functions
│   └── cents_to_dollars.sql
├── analyses/                 # Ad-hoc analytics queries
│   └── top_customers_by_revenue.sql
├── setup/                    # Snowflake setup scripts
│   ├── snowflake_setup.sql
│   └── cleanup.sql
├── dbt_project.yml          # Project configuration
└── profiles.yml             # Connection configuration
```

## 🚀 Quick Start (30-Minute Demo)

### Prerequisites

1. **Snowflake Account** - [Sign up for a free trial](https://signup.snowflake.com/)
2. **Python 3.8+** installed
3. **dbt-snowflake** package

### Step 1: Install dbt

```bash
pip install dbt-snowflake
```

### Step 2: Setup Snowflake

1. Log into your Snowflake account
2. Run the setup script in Snowflake:
   ```sql
   -- Copy and run the contents of setup/snowflake_setup.sql
   ```

### Step 3: Configure dbt Connection

1. Set your Snowflake credentials as environment variables:
   ```bash
   export SNOWFLAKE_ACCOUNT="your_account.region"
   export SNOWFLAKE_USER="your_username"
   export SNOWFLAKE_PASSWORD="your_password"
   ```

2. Or edit `profiles.yml` directly with your credentials

### Step 4: Verify Connection

```bash
dbt debug
```

### Step 5: Install dbt Packages

```bash
dbt deps
```

### Step 6: Load Seed Data

```bash
dbt seed
```

This loads the sample CSV files (customers, orders, products) into Snowflake.

### Step 7: Run Models

```bash
dbt run
```

This creates:
- 3 staging views
- 3 marts tables

### Step 8: Test Data Quality

```bash
dbt test
```

This runs all data quality tests.

### Step 9: Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

Opens an interactive documentation site in your browser.

## 📊 Demo Walkthrough

### Part 1: Staging Layer (5 minutes)

The staging models clean and standardize raw data:

- **stg_customers**: Combines first/last name, formats dates
- **stg_orders**: Converts amounts to decimal, formats dates
- **stg_products**: Standardizes product data

```sql
-- Example: View staged customers
SELECT * FROM DBT_DEMO_DB.STAGING.STG_CUSTOMERS LIMIT 10;
```

### Part 2: Marts Layer (10 minutes)

Business-level analytics tables:

**1. customer_orders** - Customer-level metrics
```sql
SELECT 
    full_name,
    total_orders,
    total_spent,
    avg_order_value
FROM DBT_DEMO_DB.MARTS.CUSTOMER_ORDERS
ORDER BY total_spent DESC
LIMIT 5;
```

**2. order_summary** - Monthly order trends
```sql
SELECT 
    order_month,
    status,
    order_count,
    total_revenue
FROM DBT_DEMO_DB.MARTS.ORDER_SUMMARY
ORDER BY order_month DESC;
```

**3. product_performance** - Product analytics
```sql
SELECT 
    category,
    product_name,
    stock_level,
    total_inventory_value
FROM DBT_DEMO_DB.MARTS.PRODUCT_PERFORMANCE
ORDER BY total_inventory_value DESC;
```

### Part 3: Data Quality Tests (5 minutes)

Show how dbt tests ensure data quality:

```bash
# Run specific test
dbt test --select stg_customers

# Show test results in Snowflake
SELECT * FROM DBT_DEMO_DB.STAGING.STG_ORDERS 
WHERE AMOUNT <= 0;  -- Should return 0 rows
```

### Part 4: Documentation (5 minutes)

```bash
dbt docs generate
dbt docs serve
```

Demonstrate:
- Interactive lineage graph
- Column-level documentation
- Test results
- Model descriptions

### Part 5: Incremental Development (5 minutes)

Show how to iterate on models:

```bash
# Run only one model
dbt run --select customer_orders

# Run model and its dependencies
dbt run --select +customer_orders

# Run model and downstream models
dbt run --select customer_orders+
```

## 🔄 Common dbt Commands

```bash
# Run everything
dbt build

# Run only changed models
dbt run --select state:modified+

# Run with full refresh
dbt run --full-refresh

# Test specific model
dbt test --select customer_orders

# Compile without running
dbt compile

# Run specific models
dbt run --select marts.*
```

## 📈 Key Metrics in This Demo

The demo calculates:
- Total orders per customer
- Average order value
- Monthly revenue trends
- Order status distribution
- Product inventory values
- Customer lifetime value

## 🧹 Cleanup

To remove all demo resources from Snowflake:

```sql
-- Run the contents of setup/cleanup.sql
```

## 📚 Learning Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake dbt Quickstart](https://www.snowflake.com/en/developers/guides/dbt-projects-on-snowflake/?index=..%2F..index)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [dbt Discourse Community](https://discourse.getdbt.com/)

## 🎯 Demo Tips

1. **Start with seeds** - Show how easy it is to load CSV data
2. **Explain layering** - Staging vs. Marts concept
3. **Show lineage** - Use `dbt docs` to visualize dependencies
4. **Run tests live** - Break something and show tests catch it
5. **Highlight version control** - All SQL in Git
6. **Show incremental** - How to rebuild only what changed

## 🔧 Troubleshooting

**Connection Issues:**
```bash
dbt debug --config-dir .
```

**Clear cache and rebuild:**
```bash
dbt clean
dbt deps
dbt build
```

**View compiled SQL:**
```bash
dbt compile
# Check target/compiled/snowflake_dbt_demo/
```

## 📝 Customization Ideas

Extend this demo by:
1. Adding more complex transformations
2. Implementing snapshots for slowly changing dimensions
3. Creating incremental models for large datasets
4. Adding custom macros for business logic
5. Integrating with BI tools (Tableau, Looker, etc.)

## 🤝 Contributing

This is a demo project. Feel free to:
- Add more sample data
- Create additional models
- Implement advanced dbt features
- Improve documentation

---

**Demo Duration:** 30 minutes
**Difficulty Level:** Beginner to Intermediate
**Prerequisites:** Snowflake account, basic SQL knowledge

