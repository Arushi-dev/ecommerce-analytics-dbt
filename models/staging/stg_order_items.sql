with source as (
    select * from {{ source('ecommerce', 'order_items') }}
),

cleaned as (
    select
        order_id,
        product_id,
        seller_id,
        cast(price as double) as item_price,
        cast(freight_value as double) as freight_value,
        cast(price as double) + cast(freight_value as double) as total_item_value
    from source
    where order_id is not null
      and price > 0
)

select * from cleaned