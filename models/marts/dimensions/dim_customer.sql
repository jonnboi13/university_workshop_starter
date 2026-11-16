select
    customer_id,
    customer_name
from {{ ref('stg_jaffle_shop__raw_customers') }}
