{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ ref('products') }}
),

renamed as (
    select
        product_id,
        product_name,
        category,
        price::decimal(10,2) as price,
        stock_quantity
    from source
)

select * from renamed

