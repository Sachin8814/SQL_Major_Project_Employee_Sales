create table Departments(
department_id serial primary key,
dept_name varchar(50),
manager_id int
);

create table emoloyees(
employee_id serial primary key,
name varchar(50),
email varchar(120) unique,
city varchar(30),
deparment_id int references departments(department_id) on delete restrict,
hire_date date not null,
salary numeric(10,2) not null check(salary>0)
);

alter table emoloyees rename to employees

alter table employees rename column deparment_id to department_id

create table sales (
sales_id serial Primary key,
emp_id int references employees(employee_id) on delete cascade,
sale_date date not null,
amount numeric(12,2) not null check(amount >= 0)
);

alter table sales
add column product_name bigint;

alter table sales
alter column product_name type varchar(50)

create table Attendance(
attendance_id serial primary key,
emp_id int references employees(employee_id) on delete cascade,
attendance_date date not null,
status varchar(10) not null check(status in ('Present','Absent','Leave'))
);

create table projects(
project_id serial primary key,
project_name varchar(150) unique not null,
start_date Date,
end_date date,
department_id int references departments(department_Id) on delete set null
);


create table employee_project(
emp_proj_id serial primary key,
employee_id int references employees(employee_id) on delete cascade,
project_id int references projects(project_id) on delete cascade,
role varchar(50),
unique(employee_id, project_id)
);


insert into departments(dept_name)
values ('Sales'),
('IT'),
('HR'),
('Finance'),
('Marketing');

select * from departments



-- Make sure Departments table already hai
INSERT INTO Employees (name, email, city, department_id, hire_date, salary)
SELECT
  'Emp' || gs AS name,
  'emp' || gs || '@example.com' AS email,
  (ARRAY['Delhi','Mumbai','Bengaluru','Chennai','Pune','Noida','Gurgaon','Hyderabad','Jaipur','Kolkata'])[floor(random()*10)+1] AS city,
  (floor(random()*5)+1)::int AS department_id,   -- dept_id 1..5
  DATE '2016-01-01' + (floor(random()*3500))::int AS hire_date,
  round((30000 + random()*70000)::numeric,2) AS salary
FROM generate_series(1,100) gs;

select * from employees


with mgr as(
select department_id, min(employee_id) as manager_id
from employees
group by department_id
)
update departments as d
set manager_id = m.manager_id
from mgr as m
where d.department_id = m.department_id;

select * from departments

INSERT INTO Sales (emp_id, sale_date, amount, product_name)
SELECT
  (floor(random()*100)+1)::int AS employee_id,  -- 1 to 100 employees
  DATE '2023-01-01' + (floor(random()*365))::int AS sale_date,
  round((500 + random()*9500)::numeric,2) AS amount,
  (ARRAY['Laptop','Mobile','Tablet','Headphones','Monitor','Keyboard','Mouse','Printer','Camera','Smartwatch'])[floor(random()*10)+1] AS product_name
FROM generate_series(1,1000);

select * from sales
limit 30;


INSERT INTO Attendance (emp_id, attendance_date, status)
SELECT
  (floor(random()*100)+1)::int AS employee_id,  -- 1 to 100 employees
  DATE '2023-01-01' + (floor(random()*365))::int AS attendance_date,
  (ARRAY['Present','Absent','Leave'])[floor(random()*3)+1] AS status
FROM generate_series(1,1000);


select * from attendance
limit 30;

INSERT INTO Projects (project_name, start_date, end_date, department_id)
VALUES
('E-commerce Website', '2023-01-01', '2023-06-30', 1),
('Mobile App Development', '2023-02-15', '2023-08-15', 2),
('HR Automation', '2023-03-01', '2023-09-30', 3),
('Finance Dashboard', '2023-01-20', '2023-07-20', 4),
('Marketing Campaign', '2023-04-01', '2023-10-01', 5),
('Customer Portal', '2023-02-01', '2023-08-01', 1),
('Inventory System', '2023-03-15', '2023-09-15', 2),
('Data Analytics Tool', '2023-01-10', '2023-06-10', 2),
('Internal CRM', '2023-04-05', '2023-09-30', 1),
('Website Redesign', '2023-05-01', '2023-11-01', 5);

select * from projects

INSERT INTO Employee_Project (employee_id, project_id, role)
SELECT
  (floor(random()*100)+1)::int AS employee_id,
  (floor(random()*10)+1)::int AS project_id,
  (ARRAY['Developer','Tester','Manager','Analyst'])[floor(random()*4)+1] AS role
FROM generate_series(1,200)
ON CONFLICT (employee_id, project_id) DO NOTHING;


select * from employee_project


SELECT d.dept_name, COUNT(e.employee_id) AS total_employees,
       SUM(e.salary) AS total_salary,
       AVG(e.salary) AS avg_salary,
       MAX(e.salary) AS highest_salary,
       MIN(e.salary) AS lowest_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.dept_name
ORDER BY total_salary DESC;

SELECT e.employee_id, e.name, SUM(s.amount) AS total_sales
FROM Employees e
JOIN Sales as s ON e.employee_id = s.emp_id
GROUP BY e.employee_id, e.name
ORDER BY total_sales DESC
LIMIT 10;

select s.emp_id,sum(s.amount) as tot
from sales s
group by emp_id
order by tot desc
limit 10;

SELECT p.project_name, COUNT(ep.employee_id) AS employee_count
FROM Projects p
LEFT JOIN Employee_Project ep ON p.project_id = ep.project_id
GROUP BY p.project_name
ORDER BY employee_count DESC;


SELECT d.dept_name, m.name AS manager_name, COUNT(e.employee_id) AS total_employees
FROM Departments d
JOIN Employees m ON d.manager_id = m.employee_id
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.dept_name, m.name
ORDER BY total_employees DESC;

SELECT *
FROM (
    SELECT e.employee_id,
           e.name,
           e.salary,
           d.dept_name,
           RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) AS salary_rank,
           COUNT(*) OVER (PARTITION BY d.department_id) AS total_employees,
           0.1 * COUNT(*) OVER (PARTITION BY d.department_id) AS top_10_percent_limit
    FROM Employees e
    JOIN Departments d ON e.department_id = d.department_id
) sub
WHERE salary_rank <= top_10_percent_limit
ORDER BY dept_name, salary DESC;


SELECT e.employee_id, e.name,
       SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_days,
       SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END) AS absent_days,
       SUM(CASE WHEN a.status='Leave' THEN 1 ELSE 0 END) AS leave_days
FROM employees as e
JOIN Attendance as a ON e.employee_id = a.emp_id
GROUP BY e.employee_id, e.name
ORDER BY present_days DESC;

select * from attendance


