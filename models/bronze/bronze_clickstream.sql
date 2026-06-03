with source as (
    select *
    from {{ source('raw', 'raw_clickstream') }}
),

renamed as (
    select
        event_id::INT as event_id,
        event_ts::TIMESTAMP as event_ts,
        user_id::VARCHAR(10) as user_id,
        session_id::VARCHAR(10) as session_id,
        event_type::VARCHAR(20) as event_type,
        page_url::VARCHAR(50) as page_url,
        device::VARCHAR(10) as device,
        browser::VARCHAR(10) as browser
    from source
)

select *
from renamed
