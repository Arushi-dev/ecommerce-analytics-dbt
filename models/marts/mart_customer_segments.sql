with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
    where order_status = 'delivered'
),

items as (
    select * from {{ ref('stg_order_items') }}
),

customer_orders as (
    select
        c.customer_unique_id,
        c.customer_state,
        count(distinct o.order_id)      as total_orders,
        sum(i.total_item_value)         as lifetime_value,
        min(o.order_date)               as first_order_date,
        max(o.order_date)               as last_order_date
    from customers c
    left join orders o on c.customer_id = o.customer_id
    left join items i on o.order_id = i.order_id
    group by c.customer_unique_id, c.customer_state
)

select
    *,
    case
        when total_orders = 0 then 'No delivered orders'
        when total_orders = 1 then 'One-time'
        when total_orders between 2 and 4 then 'Repeat'
        else 'Loyal'
    end as customer_segment,
    case
        when lifetime_value >= 500 then 'High Value'
        when lifetime_value >= 200 then 'Mid Value'
        else 'Low Value'
    end as value_tier
from customer_orders