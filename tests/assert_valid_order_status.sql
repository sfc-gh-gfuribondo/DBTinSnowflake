-- Test to ensure order status values are valid

select
    order_id,
    status
from {{ ref('stg_orders') }}
where status not in ('completed', 'cancelled', 'processing', 'pending')

