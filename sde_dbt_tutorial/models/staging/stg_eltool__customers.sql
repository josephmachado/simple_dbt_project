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
        (DATE_PART('year', now()) - DATE_PART('year', datetime_created::TIMESTAMP)) * 12 +
              (DATE_PART('month', now()) - DATE_PART('month', datetime_created::TIMESTAMP))::integer as account_age_in_months,
        dbt_valid_from,
        dbt_valid_to
    from source
)
select *
from renamed
