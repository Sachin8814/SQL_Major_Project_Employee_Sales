# SQL_Major_Project_Employee_Sales
“Industry-level SQL project managing Employees, Departments, Sales, Attendance, Projects”

Project Overview:

Industry-level SQL project managing Employees, Departments, Sales, Attendance, Projects

Features: Advanced joins, aggregations, CTEs, window functions

Dataset: 100+ employees, 10 departments, 1000+ sales & attendance records

Tables & Schema:

Table	Columns	Notes
Employees	employee_id, name, email, city, department_id, hire_date, salary	Employee master data
Departments	department_id, dept_name, manager_id	Department master data
Projects	project_id, project_name, start_date, end_date, department_id	Project info
Sales	sale_id, employee_id, sale_amount, sale_date	Sales data per employee
Attendance	attendance_id, employee_id, date, status	Daily attendance
Employee_Project	emp_proj_id, employee_id, project_id, role	Employee assigned to projects

Features / Highlights:

Advanced queries: INNER JOIN, LEFT JOIN, SELF JOIN

Aggregation + GROUP BY + KPIs

Window functions: TOP 10% employees per department

Data cleaning: NULL handling, duplicates removed

Sample Queries (Code Snippets)

Department-wise salary summary

Top performing employees

Project-wise employee allocation

Attendance reports
