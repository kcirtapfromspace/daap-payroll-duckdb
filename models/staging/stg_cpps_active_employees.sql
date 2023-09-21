-- models/staging/stg_active_cpp_employees.sql
with

source as (

    select * from {{ source('cpps_active', 'cpps_active_employees') }}

),

filtered_active AS (
    SELECT *
    FROM source
    WHERE is_active = TRUE
)

SELECT *
FROM filtered_active
