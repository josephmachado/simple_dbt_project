{{
    config(
        materialized='incremental',
        unique_key='event_id',
        incremental_strategy='delete+insert'
    )
}}

with source as (
    select *
    from {{ ref('bronze_clickstream') }}
),

final as (
    select
        event_id,
        event_ts,
        user_id,
        session_id,
        event_type,
        page_url,
        device,
        browser
    from source

    {% if is_incremental() %}
    where event_ts > (select max(event_ts) from {{ this }})
    {% endif %}
)

select *
from final
