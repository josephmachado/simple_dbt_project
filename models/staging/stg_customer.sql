with source as (
  select * from {{ ref('customer') }}
),

stage_customer as (
  select
    customer_order_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_st
  from source
)
select
  *
from stage_customer