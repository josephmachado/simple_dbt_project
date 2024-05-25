with source as (
    select *
    from {{ source('raw_layer', 'state') }}
),

renamed as (
    select
        state_identifier::INT as state_id,
        state_code::VARCHAR(2) as state_code,
        st_name::VARCHAR(30) as state_name
    from source
)

select *
from renamed
