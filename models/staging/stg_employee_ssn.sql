-- staging/stg_employees.sql

with

source as (
    select * from {{ source('employee_data', 'steps_sample_data') }}
),

renamed as (
    select
        ----------  ids
        emp_id as employee_id,
        ssn as employee_ssn,
        

    from source

)

select * from renamed
