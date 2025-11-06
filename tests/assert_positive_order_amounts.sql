-- Test to ensure all order amounts are positive

select
    order_id,
    amount
from {{ ref('stg_orders') }}
where amount <= 0

