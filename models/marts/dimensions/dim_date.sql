with date_bounds as (

    select
        min(ordered_date) as first_date,
        max(ordered_date) as last_date
    from {{ ref('int_customer_orders') }}

),

calendar as (

    select date_day
    from date_bounds,
    unnest(generate_date_array(first_date, last_date)) as date_day

)

select
    date_day,
    cast(format_date('%Y%m%d', date_day) as int64) as date_key,
    format_date('%A', date_day) as day_name,
    extract(dayofweek from date_day) as day_of_week,
    extract(isoweek from date_day) as week_of_year,
    date_trunc(date_day, week(monday)) as week_start_date,
    extract(month from date_day) as month_number,
    format_date('%B', date_day) as month_name,
    extract(quarter from date_day) as quarter_number,
    extract(year from date_day) as year,
    extract(dayofweek from date_day) in (1, 7) as is_weekend

from calendar
