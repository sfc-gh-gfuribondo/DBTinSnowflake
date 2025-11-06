# 30-Minute dbt + Snowflake Demo Guide

## 🎯 Demo Objectives

By the end of this demo, audience will understand:
- What is dbt and why use it
- How dbt works with Snowflake
- Key dbt features: models, tests, documentation
- Best practices for data transformation

---

## 📅 Timeline (30 Minutes)

### ⏱️ 0-5 mins: Introduction & Setup
### ⏱️ 5-10 mins: Loading Data & Staging Models
### ⏱️ 10-20 mins: Building Analytics Models
### ⏱️ 20-25 mins: Testing & Data Quality
### ⏱️ 25-30 mins: Documentation & Q&A

---

## 🎬 Slide-by-Slide Guide

### **Slide 1: Title Slide (1 min)**
- Introduce dbt (data build tool)
- "Transform data in your warehouse using SQL"
- Mention it works seamlessly with Snowflake

### **Slide 2: What is dbt? (2 mins)**

**Key Points:**
- dbt = SQL + Software Engineering Best Practices
- Transform data where it lives (in Snowflake)
- Version control, testing, documentation built-in
- Open source + large community

**Demo Action:** Show the project structure in IDE

```
models/
├── staging/    # Clean raw data
└── marts/      # Business metrics
```

### **Slide 3: Architecture Overview (2 mins)**

**Show the flow:**
```
Raw Data (Seeds) 
    ↓
Staging Models (Views)
    ↓
Marts Models (Tables)
    ↓
BI Tools / Analytics
```

**Demo Action:** Show `dbt_project.yml`

### **Slide 4: Demo Setup (5 mins)**

**Pre-requisites shown:**
1. Snowflake account ✅
2. dbt installed ✅
3. Sample data ready ✅

**Live Demo:**

```bash
# 1. Verify connection
dbt debug

# 2. Install packages
dbt deps

# 3. Load sample data
dbt seed
```

**Explain seed files:**
- customers.csv (10 customers)
- orders.csv (20 orders)
- products.csv (10 products)

**Switch to Snowflake UI:**
```sql
-- Show the loaded data
SELECT * FROM DBT_DEMO_DB.PUBLIC.CUSTOMERS LIMIT 5;
SELECT * FROM DBT_DEMO_DB.PUBLIC.ORDERS LIMIT 5;
```

### **Slide 5: Staging Layer (5 mins)**

**Concept:**
- Staging = 1-to-1 with source
- Light transformations: renaming, typing, cleaning
- Always views (cheap, current)

**Demo Action:** Open `models/staging/stg_customers.sql`

```sql
-- Show how we:
-- 1. Cast data types
-- 2. Rename columns
-- 3. Create derived fields (full_name)
```

**Run it:**
```bash
dbt run --select staging
```

**In Snowflake:**
```sql
SELECT * FROM DBT_DEMO_DB.STAGING.STG_CUSTOMERS;
```

**Highlight:**
- SQL you write is templated
- `{{ ref('customers') }}` creates dependencies
- dbt handles the schema creation

### **Slide 6: Marts Layer - Customer Analytics (5 mins)**

**Concept:**
- Marts = business-level analytics
- Wide tables, denormalized
- Optimized for reporting

**Demo Action:** Open `models/marts/customer_orders.sql`

**Explain the logic:**
```sql
-- We're calculating per customer:
-- - Total orders
-- - Total spent
-- - Average order value
-- - First/last order dates
-- - Orders by status
```

**Run it:**
```bash
dbt run --select marts
```

**In Snowflake:**
```sql
-- Show top customers
SELECT 
    full_name,
    total_orders,
    total_spent,
    avg_order_value
FROM DBT_DEMO_DB.MARTS.CUSTOMER_ORDERS
ORDER BY total_spent DESC
LIMIT 5;
```

### **Slide 7: More Marts Models (3 mins)**

**Quick overview of other models:**

**1. order_summary.sql** - Monthly trends
```sql
SELECT * FROM DBT_DEMO_DB.MARTS.ORDER_SUMMARY 
ORDER BY order_month DESC;
```

**2. product_performance.sql** - Inventory analysis
```sql
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(total_inventory_value) as total_value
FROM DBT_DEMO_DB.MARTS.PRODUCT_PERFORMANCE
GROUP BY category;
```

**Key Point:** Each model is just a SELECT statement. dbt handles the CREATE TABLE/VIEW.

### **Slide 8: Data Lineage (2 mins)**

**Demo Action:**
```bash
dbt docs generate
dbt docs serve
```

**Show in browser:**
1. Click on `customer_orders` model
2. Show the blue button to see lineage graph
3. Demonstrate: seeds → staging → marts flow
4. Click on columns to see descriptions

**Key Point:** Auto-generated, always up-to-date

### **Slide 9: Testing & Data Quality (5 mins)**

**Concept:**
- Tests = SQL queries that return 0 rows on pass
- Built-in tests: unique, not_null, relationships, accepted_values
- Custom tests: any SQL you want

**Demo Action:** Open `models/staging/schema.yml`

**Show test definitions:**
```yaml
columns:
  - name: customer_id
    tests:
      - unique
      - not_null
  - name: email
    tests:
      - unique
```

**Run tests:**
```bash
dbt test
```

**Show results:** All pass ✅

**Demo failure:** Open `models/marts/schema.yml`

**Show custom test:** `tests/assert_positive_order_amounts.sql`

```sql
-- This query should return 0 rows
select * from {{ ref('stg_orders') }}
where amount <= 0
```

**Run it:**
```bash
dbt test --select assert_positive_order_amounts
```

### **Slide 10: Development Workflow (3 mins)**

**Show iterative development:**

```bash
# Run just one model
dbt run --select customer_orders

# Run a model and everything upstream
dbt run --select +customer_orders

# Run a model and everything downstream
dbt run --select customer_orders+

# Run only changed models
dbt run --select state:modified+
```

**Key Point:** Fast iteration, test as you go

### **Slide 11: Production Deployment (2 mins)**

**Best Practices:**
- All SQL in Git (version control)
- CI/CD integration
- Run in orchestrator (Airflow, Dagster, dbt Cloud)
- Separate dev/prod environments

**Show:**
```bash
# Production run
dbt build --target prod

# This runs: seed → run → test → snapshot
```

### **Slide 12: Key Benefits (2 mins)**

**Summarize:**
1. ✅ **Version Control** - All transformations in Git
2. ✅ **Testing** - Catch data quality issues early
3. ✅ **Documentation** - Auto-generated, always current
4. ✅ **Modularity** - Reusable components
5. ✅ **Collaboration** - Team can review code
6. ✅ **Performance** - Leverage Snowflake compute

### **Slide 13: Q&A (2 mins)**

**Common Questions:**

**Q: How does dbt compare to stored procedures?**
A: dbt provides version control, testing, documentation. Logic is declarative (SELECT) not procedural.

**Q: Can I use Python?**
A: Yes! dbt 1.3+ supports Python models for ML/complex logic.

**Q: How do I schedule dbt runs?**
A: Use dbt Cloud, Airflow, or any orchestrator.

**Q: What about incremental models?**
A: dbt supports incremental processing for large datasets.

---

## 🎤 Speaker Notes

### **Opening Hook (30 seconds)**
"Raise your hand if you've written SQL in production that you couldn't remember 6 months later...
dbt solves this by bringing software engineering practices to analytics."

### **Key Messages to Repeat**
1. "Transform data where it lives" (in Snowflake)
2. "SQL + version control + tests + docs"
3. "Fast, collaborative, reliable"

### **Demo Tips**
- ✅ Run all commands before the demo to ensure they work
- ✅ Have Snowflake UI and terminal side-by-side
- ✅ Use a large font size (16pt+)
- ✅ Prepare for common questions (see above)
- ✅ Have backup: recording of commands if live demo fails

### **Timing Checkpoints**
- 10 mins: Should have shown seeds + staging
- 20 mins: Should have shown marts + lineage
- 25 mins: Should have shown tests
- 30 mins: Wrap up Q&A

---

## 🎬 Pre-Demo Checklist

```bash
# 1. Reset environment
cd /Users/gfuribondo/Cursor/dbtinSnowflake

# 2. Clean up
dbt clean

# 3. Verify connection
dbt debug

# 4. Install packages
dbt deps

# 5. Test full flow
dbt build

# 6. Generate docs
dbt docs generate

# 7. Verify Snowflake UI is logged in

# 8. Clear terminal for clean demo start
clear
```

---

## 📊 Backup Queries (If Needed)

If you need to show results without running dbt:

```sql
-- Show customer metrics
SELECT 
    CONCAT(first_name, ' ', last_name) as full_name,
    COUNT(o.order_id) as orders,
    SUM(o.amount) as total_spent
FROM DBT_DEMO_DB.PUBLIC.CUSTOMERS c
LEFT JOIN DBT_DEMO_DB.PUBLIC.ORDERS o 
    ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY total_spent DESC;

-- Show monthly revenue
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(amount) as revenue
FROM DBT_DEMO_DB.PUBLIC.ORDERS
GROUP BY 1
ORDER BY 1 DESC;
```

---

## 🎓 Follow-up Resources to Share

After demo, share:
1. This GitHub repository
2. [Snowflake dbt Quickstart](https://www.snowflake.com/en/developers/guides/dbt-projects-on-snowflake/?index=..%2F..index)
3. [dbt Documentation](https://docs.getdbt.com/)
4. [dbt Slack Community](https://www.getdbt.com/community/)

---

**Good luck with your demo! 🚀**

