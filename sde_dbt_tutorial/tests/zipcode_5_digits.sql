select *
from {{ ref('stg_eltool__customers') }}
where char_length(zipcode) != 5