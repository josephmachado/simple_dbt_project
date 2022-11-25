select *
from {{ ref('stg_eltool__customers') }}
where account_age_in_months > 1000