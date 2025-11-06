-- Analysis: Top 10 customers by total revenue

select
    customer_id,
    full_name,
    email,
    total_spent,
    total_orders,
    avg_order_value
from {{ ref('customer_orders') }}
order by total_spent desc
limit 10

