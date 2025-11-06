{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ ref('customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        signup_date::date as signup_date,
        first_name || ' ' || last_name as full_name
    from source
)

select * from renamed

