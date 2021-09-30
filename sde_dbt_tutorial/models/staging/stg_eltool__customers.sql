with source as (
    select *
    from {{ ref('customers_snapshot') }}
), renamed as (
    select customer_id,
        zipcode,
        city,
        state_code,
        datetime_created::TIMESTAMP AS datetime_created,
        datetime_updated::TIMESTAMP AS datetime_updated,
        dbt_valid_from,
        dbt_valid_to
    from source
)
select *
from renamed
