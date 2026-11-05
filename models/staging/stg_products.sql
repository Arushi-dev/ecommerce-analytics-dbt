with source as (
    select * from {{ source('ecommerce', 'products') }}
),

cleaned as (
    select
        product_id,
        coalesce(product_category_name, 'unknown') as product_category,
        cast(product_weight_g as integer) as product_weight_g
    from source
    where product_id is not null
)

select * from cleaned