{%- set order_statuses = ['delivered', 'invoiced', 'shipped', 'processing', 'canceled', 'unavailable'] -%}

with orders as (
    select * from {{ ref('stg_eltool__orders') }}
),

pivoted as (
    select 
        customer_id,
        {%- for order_status in order_statuses -%}
            sum(case when order_status = '{{ order_status }}' then 1 else 0 end) as {{ order_status }}_count
            {% if not loop.last %}, {%- endif %}
        {% endfor -%}
    from orders
    group by customer_id
)

select * from pivoted