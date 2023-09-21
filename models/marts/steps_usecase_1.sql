-- models/marts/steps_usecase_1.sql

{{ config(
        materialized='incremental',
        unique_key='employee_id'
    )
}}

-- Step 1: Counting unique job series and organizations
with employee_latest_record as (
    select 
        employee_id,
        left(job_class, 3) as job_series,
        org_code,
        max(effective_date) as latest_effective_date,
        employment_status
    from {{ ref('stg_employees') }}
    group by employee_id, job_series, org_code, employment_status
),

-- Step 2: Define Job and employment status flags
employee_status_flags as (
    select 
        employee_id,
        org_code,
        concat(job_series, '-', org_code) as job,
        case 
            when employment_status not in ('T', 'O', 'X') then 'Potentially Active'
            when employment_status in ('T', 'O', 'X') then 'Potentially Inactive'
        end as status_flag
    from employee_latest_record
),

-- Step 2d & 2e & 2f: Flag as suspect, active and inactive employees
flagged_employees as (
    select
        employee_id,
        org_code,
        max(case when status_flag = 'Potentially Active' then 1 else 0 end) as is_potentially_active,
        max(case when status_flag = 'Potentially Inactive' then 1 else 0 end) as is_potentially_inactive
    from employee_status_flags
    group by employee_id, org_code
),

-- Step 3: Remove employees with IHE Org codes
filtered_employees as (
    select 
        *
    from flagged_employees
    where org_code not in ('GFB', 'GGB', 'GGJ', 'GKA', 'GLA', 'GMA', 'GSA', 'GTA', 'GWA', 'GYA', 'GZA')
),

-- Step 4: Compare to CPPS dataset (assuming you have it in your dbt project as ref('cpps_active_employees'))
final_comparison as (
    select 
        a.*,
        case when b.is_active then 1 else 0 end as cpps_is_active
    from filtered_employees a
    left join {{ ref('cpps_active_employees') }} b
        on a.employee_id = b.employee_id
)


select * from final_comparison
