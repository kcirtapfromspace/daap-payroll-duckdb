State Orginizations {$page.params.org} 📊

```opening
select
    org_code as organization,
    min(employment_status_date) as founded_month_mmmyyyy
from ${employee_stats}
group by org_code
order by founded_month_mmmyyyy desc
```
{#if opening[0].org_code === $page.params.org}

{$page.params.org} is our newest division, founded in <Value data={opening.filter(d => d.org_code === $page.params.org)} column=founded_month_mmmyyyy />.

{:else}

The {$page.params.org} division was founded in <Value data={opening.filter(d => d.org_code === $page.params.org)} column=founded_month_mmmyyyy />.

{/if}

```employee_stats
with
employee_stats as (
    select 
        date_trunc('month', employment_status_date) as month,
        org_code,
        count(distinct employee_id) as total_employees

    from analytics.employee_status
    group by month, org_code
    order by month desc
)

select 
    *,
    total_employees / (lag(total_employees, -1) over (order by month desc)) - 1 as employee_growth_pct1,
    monthname(month) as month_name
from employee_stats
```

<BigValue
data={employee_stats.filter(data => data.org_code === $page.params.org)}
value=active_employees
comparison=employee_churn_rate
title="Active Employees"
comparisonTitle="Churn Rate"
/>

<BigValue
data={employee_stats.filter(data => data.org_code === $page.params.org)}
value=inactive_employees
title="Inactive Employees"
/>

State Orginizations {$page.params.org} currently employs <Value data={employee_stats.filter(d => d.org_code === $page.params.org)} column=active_employees/> team members. The average tenure for these employees is <Value data={employee_stats.filter(d => d.org_code === $page.params.org)} column=average_tenure/> days.

```employees_per_month
select
    org_code as department,
    date_trunc('month', EMPLOYMENT_STATUS_DATE) as month,
    count(*) as active_employees

from analytics.employee_status

group by 1, 2
order by 1, 2
```

Active Employees per Month in {$page.params.org}
<LineChart
data={employees_per_month.filter(data => data.department === $page.params.org)}
x=month
y=active_employees
yAxisTitle="Active employees per month in {$page.params.org}"
/>

This report offers an overview of the employee statistics for a given orginization. You can tailor the query to better fit your data model and add additional sections or visualizations as necessary. Adjust the placeholders such as "analytics.employee_status" with the actual reference to your tables or models in your dbt project.