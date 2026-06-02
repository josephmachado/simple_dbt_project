with orders as (
    select *
    from {{ ref('bronze_orders') }}
),

order_status_code as (
    select *
    from {{ ref('order_status_code') }}
)

select o.* 
, sc.order_status_code
from orders o 
left join order_status_code sc 
on o.order_status = sc.order_status
