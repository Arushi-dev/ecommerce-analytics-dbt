with source as (
    select * from {{ source('ecommerce', 'orders') }}
),

cleaned as (
    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as date) as order_date,
        cast(order_approved_at as date) as approved_date,
        cast(order_delivered_customer_date as date) as delivery_date,
        cast(order_estimated_delivery_date as date) as estimated_delivery_date
    from source
    where order_id is not null
      and order_status not in ('unavailable', 'canceled')
)

select * from cleaned