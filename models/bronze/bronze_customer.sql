with source as (
    select *
    from {{ source('raw', 'raw_customer') }}
),

renamed as (
    select
        customer_id,
        zipcode,
        city,
        state_code,
        datetime_created::timestamp as datetime_created,
        datetime_updated::timestamp as datetime_updated
    from source
)

select *
from renamed
