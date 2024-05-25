with source as (
    select *
    from {{ source('raw_layer', 'state') }}
),

renamed as (
    select
        state_id::INT as state_id,
        state_code::VARCHAR(2) as state_code,
        state_name::VARCHAR(30) as state_name
    from source
)

select *
from renamed
