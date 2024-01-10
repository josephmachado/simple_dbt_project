SELECT
    EXTRACT(
        YEAR
        FROM
        order_approved_at
    ) AS order_year, --noqa: CV03
{{
    dbt_utils.pivot('order_status',
    dbt_utils.get_column_values(ref('customer_orders'), 'order_status')) }}
FROM
    {{ ref('customer_orders') }}
GROUP BY
    1
