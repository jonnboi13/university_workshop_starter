# Customer Value by Segment

## Analytics question

How do one-time, returning, and loyal customers differ in purchase frequency, order size, and profitability—and what actions could increase customer value?

## Finding

One-time customers place larger individual orders, but loyal customers create more value through repeat purchasing. The segments have nearly identical gross margin percentages, so the main opportunity is customer behavior rather than cost efficiency.

## Evidence

The analysis covers 128 customers:

| Segment | Customers | Average orders per customer | Average order value | Average gross margin per customer | Gross margin |
|---|---:|---:|---:|---:|---:|
| One-time | 10 | 1.00 | $35.93 | $26.68 | 78.7% |
| Returning | 26 | 2.50 | $19.36 | $34.57 | 79.3% |
| Loyal | 92 | 6.64 | $10.08 | $46.16 | 79.4% |

Loyal customers make smaller purchases more often. One-time customers make larger purchases but do not return within the observed period.

## Recommended actions

- Send a follow-up offer or loyalty incentive to one-time customers to encourage a second order.
- Test bundles, add-ons, and upsells to increase loyal customers’ average order value.
- Track these segments over a longer period before making major operational decisions.

## dbt model path

```text
raw seeds
  → staging models
  → int_customer_orders and int_item_finance
  → dim_customer and fact_orders
  → mart_customer_behavior
  → mart_customer_segments
```

Model grains:

- `fact_orders`: one row per order
- `mart_customer_behavior`: one row per customer
- `mart_customer_segments`: one row per customer segment

Customer segments are defined by order count:

- **One-time:** 1 order
- **Returning:** 2–3 orders
- **Loyal:** 4 or more orders

## Data quality

The project includes `not_null` and `unique` tests for primary keys, source-key tests, composite uniqueness testing for supplies, and relationship tests connecting orders to customers and stores.

## Presentations

This repository includes two short presentations. Each one answers a different business question using a different reporting mart.

### 1. Customer segments — who should we retain or grow?

[View the customer-segment presentation](presentation/customer_segments_presentation.pptx)

This presentation uses `mart_customer_segments` to compare one-time, returning, and loyal customers. It focuses on customer count, order frequency, average order value, revenue, and gross margin to identify retention and upsell opportunities.

### 2. Margin by time — when are the most profitable times to sell?

[View the margin-by-time presentation](presentation/margin_by_time_presentation.pptx)

This presentation uses `mart_margin_by_time` to compare morning, afternoon, and evening performance across weekdays and weekends. It focuses on orders per day, revenue per day, cost per day, and gross margin per day to support a targeted weekend-afternoon promotion or similar experiment.
