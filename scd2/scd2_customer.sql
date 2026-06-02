{% snapshot scd2_customer %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',

      strategy='timestamp',
      updated_at='datetime_updated',
      dbt_valid_to_current='date \'9999-12-31\''
    )
}}

select * from {{ ref('bronze_customer') }}

{% endsnapshot %}
