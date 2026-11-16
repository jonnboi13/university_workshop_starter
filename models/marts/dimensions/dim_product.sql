select
    sku,
    product_name,
    product_type,
    product_price,
    product_description
from {{ ref('stg_jaffle_shop__raw_products') }}
