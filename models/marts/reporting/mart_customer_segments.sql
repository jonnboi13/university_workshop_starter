with customer_behavior as (

    select *
    from {{ ref('mart_customer_behavior') }}

),

segmented_customers as (

    select
        *,
        case
            when order_count = 1 then 'One-time'
            when order_count between 2 and 3 then 'Returning'
            else 'Loyal'
        end as customer_segment
    from customer_behavior
    where order_count is not null

)

select
    customer_segment,
    count(*) as customer_count,
    sum(order_count) as total_orders,
    round(avg(order_count), 2) as average_orders_per_customer,
    round(
        safe_divide(sum(total_order_value), sum(order_count)),
        2
    ) as average_order_value,
    round(
        safe_divide(sum(total_gross_margin), sum(order_count)),
        2
    ) as average_gross_margin_per_order,
    round(avg(total_gross_margin), 2) as average_gross_margin_per_customer,
    round(
        100 * safe_divide(sum(total_gross_margin), sum(total_revenue)),
        1
    ) as gross_margin_percent,
    sum(total_revenue) as total_revenue,
    sum(total_gross_margin) as total_gross_margin
from segmented_customers
group by customer_segment
