with orders as (
    select *
    from {{ ref('bronze_orders') }}
)

select * from orders
