# Welcome to DAP Steps Payroll 🥪

```active_employees_monthly_stats
with
active_employees_monthly_stats as (
    select 
        date_trunc('month', EMPLOYMENT_STATUS_DATE) as month,
        count(employee_id)::float as active_employees,
        org_code

    from employee_status
    where employee_status = 'Active'
    group by month, org_code
    order by month desc
)

select 
    *,
    active_employees / (lag(active_employees, -1) over (order by month desc)) - 1 as active_employee_growth_pct1,
    monthname(month) as month_name
from active_employees_monthly_stats

```

<BigValue
    data={active_employees_monthly_stats}
    value=active_employees
    comparison=active_employee_growth_pct1
    title="Active Employees"
    comparisonTitle="vs. prev. month"
/>

DAAP had <Value data={active_employees_monthly_stats} column=active_employees/> active employees in <Value data={active_employees_monthly_stats} column=month_name/>. This was a change of <Value data={active_employees_monthly_stats} column=active_employee_growth_pct1/> from <Value data={active_employees_monthly_stats} column=month_name row=1/>.
