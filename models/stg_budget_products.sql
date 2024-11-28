{{ config(materialized="incremental") }}

with
    stg_budget_products as (select * from {{ source("google_sheets", "budget") }}),

    renamed_casted as (
        select _row, month, quantity, _fivetran_synced from stg_budget_products
    )

select *
from renamed_casted

{% if is_incremental() %}

    where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
