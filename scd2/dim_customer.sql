{% snapshot dim_customer %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',

      strategy='timestamp',
      updated_at='datetime_updated',
      dbt_valid_to_current='date \'9999-12-31\''
    )
}}

with customers as (

select * from {{ ref('bronze_customer') }}

),

state as (
    select *
    from {{ ref('bronze_state') }}
)

select
  *,
  s.state_name 
  from customers as c
left join state as s on c.state_code = s.state_code

{% endsnapshot %}
