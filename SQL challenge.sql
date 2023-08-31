create table employees (
		emp_no INT PRIMARY KEY NOT NULL,
		emp_title_id VARCHAR NOT NULL,
		birth_date DATE NOT NULL,
		first_name 	VARCHAR NOT NULL,
		last_name VARCHAR NOT NULL,
		sex VARCHAR NOT NULL,
		hire_date DATE NOT NULL
	
);

create table departments (
		dept_no VARCHAR primary key NOT NULL,
		dept_name VARCHAR NOT NULL

);


create table dept_emp (
		emp_no INT NOT NULL,
		dept_no VARCHAR NOT NULL,
	foreign key (emp_no) references employees (emp_no),
	foreign key (dept_no) references departments (dept_no) 
	
);


create table dept_manager ( 
		dept_no VARCHAR NOT NULL,
		emp_no INT NOT NULL,
	foreign key (emp_no) references employees (emp_no),
	foreign key (dept_no) references departments (dept_no) 
	
);


create table salaries (
		emp_no INT NOT NULL,
		salary INT NOT NULL,
	foreign key (emp_no) references employees (emp_no)
	
);


create table titles (
		title_id VARCHAR NOT NULL,
		title VARCHAR NOT NULL,
		PRIMARY KEY (title_id)
);



--change to_date years that hold 9999 to current date for dept_manager,
-- dept emp, and titles 

update dept_manager 
set to_date = CURRENT_DATE 
where extract(year from to_date) = 9999;


update department_employee
set to_date = CURRENT_DATE
where extract (year from to_date) = 9999;

update titles
set to_date = CURRENT_DATE 
where extract(year from to_date) = 9999;


-- List the employee number, last name, first name, sex and salary of each employee.
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees as e
inner join salaries as s on e.emp_no = s.emp_no
order by e.emp_no;

--List tje first name, last name, and hire date for the employees who were hired in 1986
select emp_no, last_name, first_name, hire_date
from employees
where extract(year from hire_date) = 1986;

--List the manager of each department along with their dept number, dept name, employee number, last name and first name.
select distinct on(dept_manager.dept_no) dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name,employees.first_name 
from dept_manager 
inner join departments 
on dept_manager.dept_no = departments.dept_no
inner join employees 
on dept_manager.emp_no = employees.emp_no
order by dept_manager.dept_no;

--List the department number for each employee along with the employee's emp number, last name, first name and dept name
select distinct on (e.emp_no) e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
left join dept_emp as de
on e.emp_no = de.emp_no
inner join departments as d
on de.dept_no = d.dept_no
order by e.emp_no;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select e.last_name, e.first_name, e.sex
from employees as e
where (e.first_name = 'Hercules') and (lower(e.last_name) like 'b%')
order by e.last_name;

--List each employee in the sales department, including their employee number, last name and first name
select e.emp_no, e.last_name, e.first_name
from employees as e
inner join dept_emp as de on e.emp_no = de.emp_no
inner join departments as d on de.dept_no = d.dept_no
where d.dept_name = 'sales';


--List each employee in the Sales and Development departmetns, including their emp number, last name, first name and department name 
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS cde ON e.emp_no = cde.emp_no
INNER JOIN departments AS d ON cde.dept_no = d.dept_no
WHERE (LOWER(d.dept_name) = 'sales') OR (LOWER(d.dept_name) = 'development');

-- List the frequency counts, in decending order, of all the employee last names( that is, how many employees share each last name)
select last_name, count(last_name) as Frequency
from employees
group by last_name
order by frequency desc;