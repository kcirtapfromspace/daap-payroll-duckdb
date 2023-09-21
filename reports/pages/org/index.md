# Orginization

```employees_per_org
select
    org_code as organization,
    concat('/Agency/', org_code) as  org_code,
    count(distinct employee_id) as total_employees

from {{ ref('stg_employees') }}

group by 1, 2

```

Click a row to see the report for that store:
<DataTable data={employees_per_org} link=department_link/>
