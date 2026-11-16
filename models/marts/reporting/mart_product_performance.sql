with products as (

    select *
    from {{ ref('dim_product') }}

),

item_finance as (

    select *
    from {{ ref('int_item_finance') }}

),

customer_orders as (

    select
        order_id,
        customer_id
    from {{ ref('int_customer_orders') }}

),

product_sales as (

    select
        i.sku,
        count(*) as units_sold,
        count(distinct o.customer_id) as unique_customers,
        sum(i.revenue) as revenue,
        sum(i.cost) as cost,
        sum(i.gross_margin) as gross_margin,
        round(avg(i.revenue), 2) as average_revenue_per_sale
    from item_finance i
    left join customer_orders o
        on i.order_id = o.order_id
    group by i.sku

)

select
    p.sku,
    p.product_name,
    p.product_type,
    p.product_price,
    coalesce(s.units_sold, 0) as units_sold,
    coalesce(s.unique_customers, 0) as unique_customers,
    coalesce(s.revenue, 0) as revenue,
    coalesce(s.cost, 0) as cost,
    coalesce(s.gross_margin, 0) as gross_margin,
    round(
        100 * safe_divide(coalesce(s.gross_margin, 0), coalesce(s.revenue, 0)),
        1
    ) as gross_margin_percent,
    s.average_revenue_per_sale
from products p
left join product_sales s
    on p.sku = s.sku
