SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM projects;


#Find the longest ongoing project for each department.
#Find all employees who are not managers.
#Find all employees who have been hired after the start of a project in their department.
#Rank employees within each department based on their hire date (earliest hire gets the highest rank).
#Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.

#Find the longest ongoing project for each department.

SELECT projects.name, start_date,end_date, DATEDIFF(end_date,start_date) AS days 
FROM projects 
JOIN departments ON projects.department_id=departments.id;


#Find all employees who are not managers.

SELECT NAME FROM employees WHERE job_title NOT LIKE '%manager%';


#Find all employees who have been hired after the start of a project in their department.

SELECT employees.name,start_date,hire_date FROM employees 
JOIN projects ON employees.department_id=projects.department_id
WHERE start_date<hire_date;

#Rank employees within each department based on their hire date (earliest hire gets the highest rank).

SELECT employees.name,departments.name,
DENSE_RANK() OVER(PARTITION BY departments.name ORDER BY employees.hire_date DESC) AS ranks
 FROM employees 
 JOIN departments ON employees.department_id=departments.id;

#Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.
  
WITH cte AS (SELECT employees.name,departments.name AS dep_name,
hire_date, LEAD(hire_date) OVER(PARTITION BY departments.name ORDER BY employees.hire_date) AS dates
FROM employees 
 JOIN departments ON employees.department_id=departments.id)
 
 SELECT cte.name, DATEDIFF(dates,hire_date) FROM cte WHERE dates IS NOT NULL;
 
