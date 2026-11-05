with items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

orders as (
    select order_id
    from {{ ref('stg_orders') }}
    where order_status = 'delivered'
)

select
    coalesce(p.product_category, 'unknown') as category,
    count(distinct i.order_id)      as total_orders,
    count(distinct i.product_id)    as unique_products,
    sum(i.item_price)               as total_revenue,
    avg(i.item_price)               as avg_price
from items i
left join products p on i.product_id = p.product_id
inner join orders o on i.order_id = o.order_id
group by coalesce(p.product_category, 'unknown')
order by total_revenue desc