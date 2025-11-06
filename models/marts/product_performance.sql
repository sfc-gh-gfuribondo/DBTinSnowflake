{{
    config(
        materialized='table'
    )
}}

with products as (
    select * from {{ ref('stg_products') }}
),

product_metrics as (
    select
        product_id,
        product_name,
        category,
        price,
        stock_quantity,
        price * stock_quantity as total_inventory_value,
        case 
            when stock_quantity < 50 then 'Low Stock'
            when stock_quantity < 100 then 'Medium Stock'
            else 'High Stock'
        end as stock_level
    from products
)

select * from product_metrics
order by category, product_name

