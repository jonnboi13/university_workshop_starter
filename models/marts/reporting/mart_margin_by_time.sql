with orders as (

    select *
    from {{ ref('fact_orders') }}

),

dates as (

    select *
    from {{ ref('dim_date') }}

),

date_counts as (

    select
        is_weekend,
        count(*) as active_days
    from dates
    group by is_weekend

),

labeled_orders as (

    select
        o.ordered_date,
        d.is_weekend,
        case
            when extract(hour from o.ordered_at) < 11 then 'Morning'
            when extract(hour from o.ordered_at) < 15 then 'Afternoon'
            else 'Evening'
        end as time_of_day,
        o.revenue,
        o.cost,
        o.gross_margin
    from orders o
    left join dates d
        on o.ordered_date = d.date_day

),

grouped as (

select
    is_weekend,
    time_of_day,
    count(*) as order_count,
    sum(revenue) as revenue,
    sum(cost) as cost,
    sum(gross_margin) as gross_margin,
    round(avg(gross_margin), 2) as average_order_margin
from labeled_orders
group by
    is_weekend,
    time_of_day

)

select
    g.is_weekend,
    g.time_of_day,
    d.active_days,
    g.order_count,
    round(safe_divide(g.order_count, d.active_days), 2) as orders_per_day,
    g.revenue,
    round(safe_divide(g.revenue, d.active_days), 2) as revenue_per_day,
    g.cost,
    round(safe_divide(g.cost, d.active_days), 2) as cost_per_day,
    g.gross_margin,
    round(safe_divide(g.gross_margin, d.active_days), 2) as gross_margin_per_day,
    round(
        100 * safe_divide(g.gross_margin, g.revenue),
        1
    ) as gross_margin_percent,
    g.average_order_margin
from grouped g
join date_counts d
    on g.is_weekend = d.is_weekend
