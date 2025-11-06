{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ ref('orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_date::date as order_date,
        status,
        amount::decimal(10,2) as amount
    from source
)

select * from renamed

