select
    store_id,
    store_name,
    opened_date,
    tax_rate
from {{ ref('stg_jaffle_shop__raw_stores') }}
