with customer as (
  select
    *
  from {{ ref('stg_customer') }}
),
orders as (
  select
    *
  from {{ ref('stg_orders') }}
),
state_map as (
  select
    *
  from {{ ref('stg_state') }}
),
final as (
  select
    customer.customer_unique_id,
    orders.order_id,
    case
      orders.order_status
      when 'delivered' then 1
      else 0
    end
      as order_status,
      state_map.state_name
      from orders
      inner join customer on orders.customer_order_id = customer.customer_order_id
      inner join state_map on customer.customer_st = state_map.st
    )
  select
    *
  from final