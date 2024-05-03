CREATE DATABASE employee;
USE employee;

--1
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    fname VARCHAR(50),
    mname VARCHAR(50),
    lname VARCHAR(50), 
    birth_date DATE,
    address VARCHAR(60),
    sex VARCHAR(1),
    salary VARCHAR(50),
    super_id INT,
    dept_number INT
);

--2
CREATE TABLE department(
    dname VARCHAR(60),
    dept_number INT PRIMARY KEY,
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN key(mgr_id) REFERENCES employee(emp_id)
);

--3
ALTER TABLE employee 
ADD CONSTRAINT FOREIGN KEY(dept_number) REFERENCES department(dept_number);

ALTER TABLE employee
ADD CONSTRAINT FOREIGN key(super_id) REFERENCES employee(emp_id);

INSERT INTO employee (emp_id, fname, mname, lname, birth_date, address, sex, salary)
VALUES (101, 'Pritam', 'Kumar', 'Shukla', '1989-05-23', 'Jharkhand', 'M', 80000);

INSERT INTO department
VALUES ('DEFENCE', 1, 101, '2000-01-20');

INSERT INTO employee
VALUES(102, 'Rahul', 'kumar', 'Mishra', '1975-02-21', 'Bihar', 'M', 40000, 101, 1);

INSERT INTO employee (emp_id, fname, lname, birth_date, address, sex, salary)
VALUES(103, 'Sidharth', 'Malhotra', '1972-02-21', 'Ranchi', 'M', 90000), (104, 'Kevin', 'Sharma', '1978-05-12', 'Ranchi', 'M', 80000),
(105, 'Raj', 'Gupta', '1988-02-27', 'Kota', 'M', 75000),
(106, 'Priya', 'Mehta', '1987-06-26', 'UP', 'F', 77000);

INSERT INTO department values('NAVY', 2, 103, '2001-02-24');

INSERT INTO employee values
(107, 'Preeti', 'Kumari', 'Jha', '1985-04-23', 'Madhya Pradesh', 'F', 35000, 103, 2);

INSERT INTO department values('Cultural', 2, 102, '2000-08-17');

INSERT INTO department values
('MEDICAL', 3, 103, '2005-06-12'),
('SECURITY', 4, 105, '2004-02-15'),
('RESEARCH', 5, 106, '2007-05-24');

INSERT INTO employee (emp_id, fname, lname, birth_date, address, sex, salary, super_id, dept_number)
values(108, 'Vani', 'Kapur', '1985-09-18', 'Mumbai', 'F', 50000, 102, 2),
(109, 'Karan', 'Johar', '1979-07-27', 'Mumbai', 'M', 45000, 102, 3);

--4
CREATE TABLE dept_loaction(
    dept_number INT,
    dlocation VARCHAR(50),
    PRIMARY KEY(dept_number, dlocation),
    FOREIGN key(dept_number) REFERENCES department(dept_number)
);

INSERT INTO dept_loaction values(1, 'Bihar'),(2, 'Ladakh'),
(3, 'Mumbai'), (4, 'Delhi'), (5, 'UP');

--5
CREATE TABLE project(
    pname VARCHAR(50),
    pnumber INT PRIMARY key,
    plocation VARCHAR(50),
    dept_number INT ,
    FOREIGN key(dept_number) REFERENCES department(dept_number)
);

INSERT INTO project values('PROJECT ultra', 1001, 'BIHAR', 1),
('PROJECT_XYZ', 1002, 'LADAKH', 2),
('PROJECT_ASD', 1003, 'LADAKH', 3),
('PROJECT_JAWAN', 1004, 'UP', 4),
('PROJECT_NIGHT', 1005, 'DELHI', 5);

--6
CREATE TABLE works_on(
    emp_id INT ,
    pnumber INT,
    hours INT,
    PRIMARY KEY(emp_id, pnumber),
    FOREIGN key(emp_id) REFERENCES employee(emp_id),
    FOREIGN key(pnumber) REFERENCES project(pnumber)
);

INSERT INTO works_on VALUES(101, 1001, 40), 
(102, 1001, 20), 
(103, 1003, 10), 
(103, 1002, 8), 
(104, 1003, 5), 
(104, 1002, 6);

--7
CREATE TABLE dependent(
    emp_id INT,
    dependent_name VARCHAR(50),
    sex VARCHAR(1),
    birth_date DATE,
    relationship VARCHAR(50),
    PRIMARY key(emp_id, dependent_name),
    FOREIGN key(emp_id) REFERENCES employee(emp_id)
);

INSERT INTO dependent values(101, 'Preeti Shukla', 'F', '1989-04-15', 'Spouse'),
(102, 'Rishab Mishra', 'M', '2005-06-26', 'Son'),
(102, 'Naina Mishra', 'F', '2002-02-21', 'Daughter'),
(103, 'Shalini Malhotra', 'F', '1980-01-12', 'Spouse'),
(104, 'Priya Jha', 'F', '2006-03-29', 'Daughter');

INSERT INTO dependent values
(105, 'Raj', 'M', '2002-05-12', 'Son'),
(106, 'Priya', 'F', '2003-02-12', 'Daughter');

update department set dname = 'FINANCE' where dept_number = 2;

INSERT into works_on values
(108, 1002, 5);

insert into department values('TESTING', 40, 106, '2001-02-12'),
('Development', 10, 104, '2005-05-15'),
('Typing', 20, 107, '2002-01-24'), 
('Codnig', 30, 105 ,'1999-03-23');

-- 1. for each department whose average employee salary is more than Rs. 50000,
--    retreive the department name and its number of employees working for that department
SELECT d.dname, count(DISTINCT e.emp_id) as number_of_employee
FROM department d
JOIN employee e ON d.dept_number = e.dept_number
GROUP BY d.dname
HAVING avg(salary) > 50000;

-- 2. Retreive the naemes of all employes in dept 5 who work more than 10 hrs in a week on the project_ultra;
SELECT e.fname
from employee e
join works_on w on e.emp_id = w.emp_id
where w.hours > 10;

-- 3. list the name of all employees who have a dependent with the same firstname as themselves;
select e.fname as same_name
from employee e
join dependent d on e.emp_id = d.emp_id
where e.fname = d.dependent_name;

--4. find the employees whose salary is greater than at least one employee of 'finance' deppartment (without aggregate fucntion)
select e.fname
from employee e 
join department d on e.dept_number = d.dept_number
where d.dname = 'FINANCE' AND e.salary > SOME(
    select salary from empLoyee 
    join department on employee.dept_number = department.dept_number
    where department.dname = 'FINANCE'
);

-- 5, find all employee names who work for highest working hours per week
select e.fname , w.hours
from employee e
join works_on w on e.emp_id = w.emp_id
order by w.hours desc limit 1;

-- 6. find all the employees who work for either project_xyz or project_asd or both
select e.fname, p.pname
from employee e 
join works_on w on w.emp_id = e.emp_id
join project p on p.pnumber = w.pnumber
where p.pname = 'PROJECT_XYZ' OR p.pname = 'PROJECT_ASD';

--7. find the employee names who work in the projects run by the 'DEFENCE' dept 
select e.fname
from employee e 
join department d on e.dept_number = d.dept_number
join project p on d.dept_number = p.dept_number
join works_on w on w.pnumber = p.pnumber
where d.dname = 'DEFENCE';

--8. find the employees names who are not working in either of these dept numbers 10,20,30,40
select e.fname, e.emp_id
from employee e 
left join works_on w on w.emp_id = e.emp_id
left join department d on d.dept_number = e.dept_number
where e.dept_number not in (10, 20, 30, 40);