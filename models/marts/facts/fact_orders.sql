with order_finance as (

    select
        order_id,
        count(*) as item_count,
        sum(revenue) as revenue,
        sum(cost) as cost,
        sum(gross_margin) as gross_margin,
        round(100 * safe_divide(sum(gross_margin), sum(revenue)), 1) as gross_margin_percent
    from {{ ref('int_item_finance') }}
    group by order_id

),

orders as (

    select *
    from {{ ref('int_customer_orders') }}

)

select
    o.order_id,
    o.customer_id,
    o.store_id,
    o.ordered_at,
    o.ordered_date,
    coalesce(f.item_count, 0) as item_count,
    f.revenue,
    f.cost,
    f.gross_margin,
    f.gross_margin_percent,
    o.order_subtotal,
    o.order_tax_paid,
    o.order_total
from orders o
left join order_finance f
    on o.order_id = f.order_id
