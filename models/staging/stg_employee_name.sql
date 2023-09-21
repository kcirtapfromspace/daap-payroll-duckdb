-- staging/stg_employees.sql

with

source as (
    select * from {{ source('employee_data', 'steps_sample_data') }}
),

renamed as (
    select
        ----------  names
        emp_name as employee_name,


    from source

)

select * from renamed
