with source as (
    select *
    from {{ source('raw_layer', 'orders') }}
),

renamed as (
    select
        order_id,
        cust_id as customer_id,
        order_status,
        order_purchase_timestamp::TIMESTAMP,
        order_approved_at::TIMESTAMP,
        order_delivered_carrier_date::TIMESTAMP,
        order_delivered_customer_date::TIMESTAMP,
        order_estimated_delivery_date::TIMESTAMP
    from source
)

select *
from renamed
