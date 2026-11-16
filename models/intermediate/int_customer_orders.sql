with orders as (

    select * from {{ ref('stg_jaffle_shop__raw_orders') }}

),

customers as (

    select * from {{ ref('stg_jaffle_shop__raw_customers') }}

),

sequenced as (

    select
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.store_id,
        o.ordered_at,
        o.ordered_date,
        o.order_subtotal,
        o.order_tax_paid,
        o.order_total,

        row_number() over (
            partition by o.customer_id
            order by o.ordered_at, o.order_id
        ) as customer_order_number,

        lag(o.ordered_at) over (
            partition by o.customer_id
            order by o.ordered_at, o.order_id
        ) as previous_ordered_at

    from orders o
    left join customers c
        on o.customer_id = c.customer_id

)

select
    *,
    timestamp_diff(
        ordered_at,
        previous_ordered_at,
        day
    ) as days_since_previous_order

from sequenced