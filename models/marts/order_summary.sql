{{
    config(
        materialized='table'
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

order_summary as (
    select
        date_trunc('month', order_date) as order_month,
        status,
        count(order_id) as order_count,
        sum(amount) as total_revenue,
        avg(amount) as avg_order_value,
        min(amount) as min_order_value,
        max(amount) as max_order_value
    from orders
    group by 1, 2
)

select * from order_summary
order by order_month desc, status

