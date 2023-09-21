-- models/marts/employee_status.sql

with base as (
    select 
        employee_id,
        job_begin_date,
        job_end_date,
        action_code,
        employment_status as employment_status,
        employment_status_date as employment_status_date
    from {{ ref('stg_employees') }}
),

status_determination as (
    select 
        employee_id,
        case
            when job_end_date > current_date then 'active'
            when job_end_date <= current_date then 'inactive'
            else 'unknown'
        end as employee_status
    from base
),

-- Get status flags from the steps_usecase_1 model
status_flags as (
    select 
        employee_id,
        is_potentially_active,
        is_potentially_inactive,
        cpps_is_active
    from {{ ref('steps_usecase_1') }}
)

-- Combine data from both CTEs
select 
    s.*,
    f.is_potentially_active,
    f.is_potentially_inactive,
    f.cpps_is_active
from status_determination s
left join status_flags f
    on s.employee_id = f.employee_id
