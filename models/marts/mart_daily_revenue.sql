with orders as (
    select * from {{ ref('stg_orders') }}
    where order_status = 'delivered'
),

items as (
    select * from {{ ref('stg_order_items') }}
),

joined as (
    select
        o.order_date,
        o.order_id,
        i.item_price,
        i.freight_value,
        i.total_item_value
    from orders o
    left join items i on o.order_id = i.order_id
)

select
    order_date,
    count(distinct order_id)     as total_orders,
    sum(item_price)              as gross_revenue,
    sum(freight_value)           as total_freight,
    sum(total_item_value)        as total_revenue,
    sum(item_price) / count(distinct order_id) as avg_order_value
from joined
group by order_date
order by order_date