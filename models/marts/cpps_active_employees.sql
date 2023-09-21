with

source as (

    select * from {{ source('cpps_active', 'cpps_active_employees') }}

),

renamed as (

    select
        ----------  ids
        emp_id as employee_id,
        
        ---------- properties
        is_active

    from source

)

select * from renamed
