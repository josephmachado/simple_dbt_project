with customers as (
    select *
    from {{ ref('bronze_customer') }}
),

state as (
    select *
    from {{ ref('bronze_state') }}
)

select
    c.customer_id,
    c.zipcode,
    c.city,
    c.state_code,
    s.state_name,
    c.datetime_created,
    c.datetime_updated,
    c.dbt_valid_from::timestamp as valid_from,
    case
        when c.dbt_valid_to is NULL then '9999-12-31'::timestamp
        else c.dbt_valid_to::timestamp
    end as valid_to
from customers as c
inner join state as s on c.state_code = s.state_code
