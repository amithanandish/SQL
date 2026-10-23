CREATE DATABASE HRSalaryLab;
USE HRSalaryLab;

CREATE TABLE departments (
    dept_id    INT           AUTO_INCREMENT PRIMARY KEY,
    dept_name  VARCHAR(50)   NOT NULL UNIQUE,
    location   VARCHAR(50)   NOT NULL
);

CREATE TABLE employees (
    emp_id              INT            AUTO_INCREMENT PRIMARY KEY,
    emp_name            VARCHAR(80)    NOT NULL,
    dept_id             INT            NOT NULL,
    job_title           VARCHAR(60)    NOT NULL,
    employment_type     VARCHAR(15)    NOT NULL,          
    hire_date           DATE           NOT NULL,
    salary              DECIMAL(10,2)  NOT NULL,           
    performance_rating  DECIMAL(2,1)   NULL,                
    status              VARCHAR(15)    NOT NULL DEFAULT 'Active',
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE salary_payments (
    payment_id   INT            AUTO_INCREMENT PRIMARY KEY,
    emp_id       INT            NOT NULL,
    pay_month    DATE           NOT NULL,                  
    basic_pay    DECIMAL(10,2)  NOT NULL,
    bonus        DECIMAL(10,2)  NOT NULL DEFAULT 0,
    deductions   DECIMAL(10,2)  NOT NULL DEFAULT 0,         
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE leave_records (
    leave_id    INT          AUTO_INCREMENT PRIMARY KEY,
    emp_id      INT          NOT NULL,
    leave_type  VARCHAR(15)  NOT NULL,                      
    start_date  DATE         NOT NULL,
    days        INT          NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO departments (dept_name, location) VALUES
('Human Resources',        'Bengaluru'),
('Finance',                'Mumbai'),
('Information Technology', 'Bengaluru'),
('Marketing',              'Delhi'),
('Operations',             'Chennai'),
('Legal',                  'Mumbai');                        -- no employees yet (useful for LEFT JOIN)

INSERT INTO employees (emp_name, dept_id, job_title, employment_type, hire_date, salary, performance_rating, status) VALUES
('Rajesh Menon',    1, 'HR Manager',            'Full-time', '2018-04-02',  95000, 4.5, 'Active'),
('Kavya Hegde',     1, 'HR Executive',          'Full-time', '2022-07-04',  42000, 4.0, 'Active'),
('Neha Kapoor',     1, 'HR Executive',          'Full-time', '2026-08-01',  40000, NULL, 'Active'),
('Rahul Bhatt',     1, 'Recruiter',             'Contract',  '2025-02-10',  38000, 3.8, 'Active'),
('Sunita Rao',      2, 'Finance Manager',       'Full-time', '2017-06-15',  98000, 4.6, 'Active'),
('Naveen Joshi',    2, 'Accountant',            'Full-time', '2021-02-15',  48000, 3.9, 'Active'),
('Priya Desai',     2, 'Financial Analyst',     'Full-time', '2020-11-09',  65000, 4.2, 'Active'),
('Gaurav Sethi',    2, 'Accountant',            'Full-time', '2023-04-17',  46000, 3.5, 'Active'),
('Arvind Kulkarni', 3, 'IT Manager',            'Full-time', '2016-01-20', 125000, 4.7, 'Active'),
('Sameer Khan',     3, 'Software Engineer',     'Full-time', '2021-08-23',  82000, 4.4, 'Active'),
('Lakshmi Prasad',  3, 'Software Engineer',     'Full-time', '2022-01-17',  76000, 4.1, 'Active'),
('Deepak Verma',    3, 'Data Analyst',          'Full-time', '2023-05-29',  68000, 4.0, 'Active'),
('Anil Mishra',     3, 'Software Engineer',     'Contract',  '2025-09-01',  70000, NULL, 'Active'),
('Tanya Arora',     3, 'QA Engineer',           'Full-time', '2024-03-11',  58000, 3.7, 'Active'),
('Pooja Bhat',      4, 'Marketing Manager',     'Full-time', '2019-03-11',  92000, 4.3, 'Active'),
('Isha Malhotra',   4, 'Digital Marketer',      'Full-time', '2022-10-10',  54000, 4.0, 'Active'),
('Farhan Ali',      4, 'Brand Executive',       'Full-time', '2023-02-06',  47000, 3.6, 'Resigned'),
('Manoj Shetty',    5, 'Operations Manager',    'Full-time', '2018-09-01',  90000, 4.4, 'Active'),
('Ritu Sinha',      5, 'Logistics Coordinator', 'Full-time', '2021-12-01',  44000, 3.8, 'Active'),
('Tarun Bose',      5, 'Supply Chain Analyst',  'Full-time', '2020-06-22',  60000, 4.1, 'Active'),
('Imran Sheikh',    5, 'Warehouse Supervisor',  'Contract',  '2025-11-03',  36000, NULL, 'Active');

INSERT INTO leave_records (emp_id, leave_type, start_date, days) VALUES
(1,  'Earned', '2026-07-06', 3),
(2,  'Casual', '2026-07-14', 1),
(2,  'Sick',   '2026-08-20', 2),
(6,  'Casual', '2026-07-21', 1),
(6,  'Earned', '2026-09-07', 5),
(7,  'Earned', '2026-09-21', 6),
(9,  'Casual', '2026-07-30', 1),
(10, 'Sick',   '2026-08-04', 2),
(10, 'Casual', '2026-09-18', 1),
(11, 'Earned', '2026-07-27', 4),
(12, 'Casual', '2026-08-12', 1),
(14, 'Sick',   '2026-09-02', 3),
(15, 'Sick',   '2026-08-17', 2),
(16, 'Casual', '2026-07-09', 1),
(16, 'Earned', '2026-08-24', 3),
(18, 'Casual', '2026-09-24', 1),
(19, 'Sick',   '2026-09-11', 2),
(20, 'Casual', '2026-08-28', 1);

SELECT (SELECT COUNT(*) FROM departments)     AS departments,
       (SELECT COUNT(*) FROM employees)       AS employees,
       (SELECT COUNT(*) FROM salary_payments) AS payments,
       (SELECT COUNT(*) FROM leave_records)   AS leaves;


SELECT COUNT(*) AS total_employees FROM employees;

SELECT COUNT(*) AS active_employees FROM employees WHERE status = 'Active';

SELECT COUNT(*)                   AS all_employees,
       COUNT(performance_rating)  AS employees_with_a_rating
FROM   employees;


SELECT COUNT(DISTINCT job_title) AS different_job_titles,
       COUNT(DISTINCT dept_id)   AS departments_with_staff
FROM   employees;


SELECT SUM(salary) AS monthly_salary_bill FROM employees WHERE status = 'Active';


SELECT ROUND(AVG(salary), 2) AS average_salary FROM employees WHERE status = 'Active';


SELECT MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary
FROM   employees
WHERE  status = 'Active';

SELECT COUNT(*)                AS headcount,
       SUM(salary)             AS total_salary,
       ROUND(AVG(salary), 2)   AS average_salary,
       MIN(salary)             AS lowest_salary,
       MAX(salary)             AS highest_salary
FROM   employees
WHERE  status = 'Active';

SELECT SUM(salary)       AS monthly_payroll,
       SUM(salary) * 12  AS yearly_payroll
FROM   employees
WHERE  status = 'Active';

SELECT ROUND(AVG(performance_rating), 2)                   AS avg_rating_ignoring_null,
       ROUND(SUM(performance_rating) / COUNT(*), 2)        AS sum_divided_by_all_rows
FROM   employees;

SELECT MIN(hire_date) AS first_joiner_date,
       MAX(hire_date) AS latest_joiner_date,
       MIN(emp_name)  AS first_name_alphabetically,
       MAX(emp_name)  AS last_name_alphabetically
FROM   employees;

SELECT emp_name, job_title, salary
FROM   employees
WHERE  salary = (SELECT MAX(salary) FROM employees WHERE status = 'Active');


