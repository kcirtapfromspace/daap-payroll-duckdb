
    select * from {{ source('employee_data', 'steps_sample_data') }}
