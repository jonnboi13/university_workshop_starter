with customers as (

    select *
    from {{ ref('dim_customer') }}

),

orders as (

    select *
    from {{ ref('fact_orders') }}

),

order_history as (

    select
        order_id,
        customer_order_number,
        days_since_previous_order
    from {{ ref('int_customer_orders') }}

),

customer_summary as (

    select
        o.customer_id,
        count(*) as order_count,
        min(o.ordered_date) as first_order_date,
        max(o.ordered_date) as last_order_date,
        sum(o.revenue) as total_revenue,
        round(avg(o.revenue), 2) as average_revenue_per_order,
        sum(o.order_total) as total_order_value,
        round(avg(o.order_total), 2) as average_order_value,
        sum(o.gross_margin) as total_gross_margin,
        round(
            100 * safe_divide(sum(o.gross_margin), sum(o.revenue)),
            1
        ) as gross_margin_percent,
        round(avg(h.days_since_previous_order), 1) as average_days_between_orders,
        countif(h.customer_order_number > 1) as repeat_order_count
    from orders o
    left join order_history h
        on o.order_id = h.order_id
    group by o.customer_id

)

select
    c.customer_id,
    c.customer_name,
    s.order_count,
    s.first_order_date,
    s.last_order_date,
    s.total_revenue,
    s.average_revenue_per_order,
    s.total_order_value,
    s.average_order_value,
    s.total_gross_margin,
    s.gross_margin_percent,
    s.average_days_between_orders,
    s.repeat_order_count,
    s.order_count > 1 as is_repeat_customer
from customers c
left join customer_summary s
    on c.customer_id = s.customer_id
