with

source as (

    select * from {{ source('employee_data', 'steps_sample_data') }}

),

renamed as (

    select
        ----------  ids
        emp_id as employee_id,
        ssn as employee_ssn,
        
        ---------- properties
        emp_name as employee_name,
        agency as org_code,
        job_begin_date,
        job_end_date,
        effective_date,
        action_code,
        sub_action_code,
        position_nbr,
        salary,
        job_class,
        memo,
        separation_reason,
        part_or_full_time,
        employment_status,
        employment_status_date,
        rate_code,
        pay_frequency,
        employee_type

    from source

)

select * from renamed
