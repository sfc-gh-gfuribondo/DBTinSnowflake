{{
    config(
        materialized='table'
    )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        c.customer_id,
        c.full_name,
        c.email,
        c.signup_date,
        count(o.order_id) as total_orders,
        sum(case when o.status = 'completed' then 1 else 0 end) as completed_orders,
        sum(case when o.status = 'cancelled' then 1 else 0 end) as cancelled_orders,
        sum(case when o.status = 'processing' then 1 else 0 end) as processing_orders,
        sum(case when o.status = 'pending' then 1 else 0 end) as pending_orders,
        sum(o.amount) as total_spent,
        avg(o.amount) as avg_order_value,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date
    from customers c
    left join orders o on c.customer_id = o.customer_id
    group by 1, 2, 3, 4
)

select * from customer_orders

