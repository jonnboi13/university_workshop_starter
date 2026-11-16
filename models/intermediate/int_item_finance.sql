with items as (

    select * from {{ ref('stg_jaffle_shop__raw_items') }}

),

products as (

    select * from {{ ref('stg_jaffle_shop__raw_products') }}

),

supply_costs as (

    select
        sku,
        sum(supply_cost) as total_supply_cost
    from {{ ref('stg_jaffle_shop__raw_supplies') }}
    group by sku

)

select
    i.item_id,
    i.order_id,
    i.sku,

    p.product_name,
    p.product_type,
    p.product_price as revenue,

    coalesce(s.total_supply_cost, 0) as cost,

    p.product_price - coalesce(s.total_supply_cost, 0) as gross_margin,

    round(
        100 * safe_divide(
            p.product_price - coalesce(s.total_supply_cost, 0),
            p.product_price
        ),
        1
    ) as gross_margin_percent

from items i
left join products p
    on i.sku = p.sku
left join supply_costs s
    on i.sku = s.sku
