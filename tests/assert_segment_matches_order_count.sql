-- Business-logic test: a customer's segment must agree with their order count.
-- This is the check that would have caught the original bug, where customers
-- with 0 delivered orders fell through to 'Loyal'. dbt treats any row returned
-- here as a failure, so the test passes only when the query returns nothing.
select
    customer_unique_id,
    total_orders,
    customer_segment
from {{ ref('mart_customer_segments') }}
where (total_orders = 0 and customer_segment != 'No delivered orders')
   or (total_orders = 1 and customer_segment != 'One-time')
   or (total_orders between 2 and 4 and customer_segment != 'Repeat')
   or (total_orders >= 5 and customer_segment != 'Loyal')
