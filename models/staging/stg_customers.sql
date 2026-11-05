with source as (
    select * from {{ source('ecommerce', 'customers') }}
),

cleaned as (
    select
        customer_id,
        customer_unique_id,
        customer_city,
        customer_state
    from source
    where customer_id is not null
)

select * from cleaned