with items as (

    select * from {{ ref('stg_jaffle_shop__raw_items') }}

),
orders as (

    select * from {{ ref('stg_jaffle_shop__raw_orders') }}

),
products as (

    select * from {{ ref('stg_jaffle_shop__raw_products') }}

),
customers as (

    select * from {{ ref('stg_jaffle_shop__raw_customers') }}

),
stores as (

    select * from {{ ref('stg_jaffle_shop__raw_stores') }}

)

select
    i.item_id,
    i.order_id,
    i.sku as product_sku,
    p.product_name,
    p.product_type,
    p.product_price,
    p.product_description,
    c.customer_id,
    c.customer_name,
    s.store_id,
    s.store_name,
    s.opened_date,
    s.tax_rate
from items i
left join orders o
    on i.order_id = o.order_id

left join products p
    on i.sku = p.sku

left join customers c
    on o.customer_id = c.customer_id

left join stores s
    on o.store_id = s.store_id
