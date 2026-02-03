

{% test duplicates_check(model,column_name) %}
{{ config(severity = 'warn') }}

with a as (

select source_system,{{ column_name }}, count(*) as cnt
from {{ model }} 
group by source_system,{{ column_name }}
having count(*) >1
)
,b as (
select source_system,cast(count(*) as string) as cnt from a group by source_system
)
select source_system,cnt from b where cnt<>'0'

{% endtest %}


{% test duplicates_check_no_source(model,column_name) %}
{{ config(severity = 'warn') }}

with a as (

select {{ column_name }}, count(*) as cnt
from {{ model }} 
group by {{ column_name }}
having count(*) >1
)
,b as (
select cast(count(*) as string) as cnt from a 
)
select cnt from b where cnt<>'0'

{% endtest %}
