-- Fundamental Of Database Systems - Chapter 4 & 5 Queries

-- Query 0. 
-- Retrieve the birth date and address of the employee(s) whose name is ‘John B.Smith’.
SELECT Bdate, Address 
FROM Company.Employee 
WHERE Fname='John' AND Minit='B' AND Lname='Smith';

-- Query 1. 
-- Retrieve the name and address of all employees who work for the ‘Research’ department.
SELECT Fname, Lname, Address 
FROM Company.Employee, Company.Department 
WHERE Dname='Research' AND Dnumber=Dno; 
-- Q1B
SELECT E.Fname, E.LName, E.Address 
FROM Company.Employee E, Company.Department D 
WHERE D.DName='Research' AND D.Dnumber=E.Dno

-- Query 2. 
-- For every project located in ‘Stafford’, list the project number, the controlling 
-- department number, and the department manager’s last name, address,and birth date.
SELECT Pnumber, Dnum, Lname, Address, Bdate 
FROM Company.Project, Company.Department, Company.Employee 
WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Plocation='Stafford'; 

-- Query 8. 
-- For each employee, retrieve the employee’s first and last name and the first and
-- last name of his or her immediate supervisor. 
SELECT E.Fname, E.Lname, S.Fname, S.Lname 
FROM Company.Employee AS E, Company.Employee AS S 
WHERE E.Super_ssn=S.Ssn; 

-- Queries 9 and 10. 
-- Select all EMPLOYEE Ssns (Q9) and all combinations of EMPLOYEE Ssn and DEPARTMENT Dname (Q10) in the database.
SELECT Ssn 
FROM Company.Employee; 

SELECT Ssn, Dname 
FROM Company.Employee, Company.Department;

-- Query 11.
-- Retrieve the salary of every employee (Q11) and all distinct salary values (Q11A).
SELECT ALL Salary 
FROM Company.Employee;
-- Q11A:
SELECT DISTINCT Salary 
FROM Company.Employee;

-- Query 14.
-- Query 4. Make a list of all project numbers for projects that involve an employee 
-- whose last name is ‘Smith’, either as a worker or as a manager of the department that controls the project.
(SELECT DISTINCT Pnumber 
FROM Company.Project, Company.Department, Company.Employee 
WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Lname='Smith') 
UNION 
(SELECT DISTINCT Pnumber 
FROM Company.Project, Company.Works_On, Company.Employee 
WHERE Pnumber=Pno AND Essn=Ssn AND Lname='Smith'); 

-- Query 12. 
-- Retrieve all employees whose address is in Houston,Texas.
SELECT Fname, Lname 
FROM Company.Employee 
WHERE Address LIKE '%Houston, TX%';

-- Query 12A. 
-- Find all employees who were born during the 1950s.
SELECT Fname, Lname 
FROM Company.Employee 
WHERE Bdate LIKE '__5_______';

-- Query 13. 
-- Show the resulting salaries if every employee working on the ‘ProductX’project is given a 10 percent raise.
SELECT E.Fname, E.Lname, 1.1 * E.Salary AS Increased_sal 
FROM Company.Employee AS E, Company.Works_On AS W, Company.Project AS P 
WHERE E.Ssn=W.Essn AND W.Pno=P.Pnumber AND P.Pname='ProductX';

-- Query 14. 
-- Retrieve all employees in department 5 whose salary is between $30,000 and $40,000. 
SELECT * 
FROM Company.Employee 
WHERE (Salary BETWEEN 30000 AND 40000) AND Dno = 5;

-- Query 15. 
-- Retrieve a list of employees and the projects they are working on, ordered by department and,
-- within each department,ordered alphabetically by last name,then first name.
SELECT D.Dname, E.Lname, E.Fname, P.Pname 
FROM Company.Department D, Company.Employee E, Company.Works_On W, Company.Project P 
WHERE D.Dnumber= E.Dno AND E.Ssn= W.Essn AND W.Pno= P.Pnumber 
ORDER BY D.Dname, E.Lname, E.Fname;

-- Query 18. 
-- Retrieve the names of all employees who do not have supervisors.
SELECT Fname, Minit, Lname 
FROM Company.Employee
WHERE Super_ssn IS null;

-- Query ?.
-- Retrieve the Ssn of all employees who work the same (project,hours) combination on 
-- some project that employee ‘John Smith’ (whose Ssn = ‘123456789’) works on.
SELECT DISTINCT Essn
FROM Company.Works_On
WHERE CONCAT(CAST(Pno AS varchar), CAST(Hours AS varchar)) IN (SELECT CONCAT(CAST(Pno AS varchar), CAST(Hours AS varchar)) FROM Company.Works_On WHERE Essn='123456789');

-- Query ?.
-- Retrieve the names of employees whose salary is greater than the salary of all the employees in department 5
SELECT Fname, Lname
FROM Company.Employee
Where Salary > ALL (SELECT Salary FROM Company.Employee WHERE Dno=5);

-- Query 16. 
-- Retrieve the name of each employee who has a dependent with the same first name 
-- and is the same sex as the employee.
SELECT e.Fname, e.Lname
FROM Company.Employee e
WHERE e.Ssn IN (SELECT Essn FROM Company.Dependent d WHERE Dependent_name=e.Fname AND d.Sex=e.Sex);
-- 16B:
SELECT E.Fname, E.Lname 
FROM Company.Employee AS E 
WHERE EXISTS (SELECT * FROM Company.Dependent AS D WHERE E.Ssn=D.Essn AND E.Sex=D.Sex AND E.Fname=D.Dependent_name);

-- Query 6. 
-- Retrieve the names of employees who have no dependents.
SELECT Fname, Lname 
FROM Company.Employee
WHERE NOT EXISTS (SELECT * FROM Company.Dependent WHERE Ssn=Essn);

-- Query 7. 
-- List the names of managers who have at least one dependent.
SELECT Fname, Lname
FROM Company.Employee
WHERE Ssn IN (SELECT Mgr_ssn FROM Company.Department) AND EXISTS (SELECT Essn FROM Company.Dependent WHERE Ssn=Essn);

-- Query 3A.
-- Retrieve the name of each employee who works on all the projects controlled by department number 5
SELECT Fname, Lname FROM Company.Employee 
WHERE NOT EXISTS (
	(SELECT Pnumber FROM Company.Project WHERE Dnum=5) 
	EXCEPT 
	(SELECT Pno FROM Company.Works_On WHERE Ssn=Essn)
);

-- Query 17. 
-- Retrieve the Social Security numbers of all employees who work on project numbers 1,2,or 3. 
SELECT DISTINCT Essn 
FROM Company.Works_On
WHERE Pno IN (1, 2, 3);

-- Query 19. 
-- Find the sum of the salaries of all employees,the maximum salary, the minimum salary,and the average salary.
SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary) 
FROM Company.Employee;

-- Query 20. 
-- Find the sum of the salaries of all employees of the ‘Research’ department, as well as the maximum salary,
-- the minimum salary, and the average salary in this department.
SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary) 
FROM (Company.Employee JOIN Company.Department ON Dno=Dnumber) 
WHERE Dname='Research';

-- Queries 21 and 22. 
-- Retrieve the total number of employees in the company (Q21) and the number of employees in the ‘Research’department (Q22). 
-- Q21:
SELECT COUNT(*) FROM Company.Employee;
-- Q22:
SELECT COUNT(*) 
FROM Company.Employee, Company.Department 
WHERE Dno=Dnumber AND Dname='Research';

-- Query 23. 
-- Count the number of distinct salary values in the database.
SELECT COUNT(DISTINCT Salary) 
FROM Company.Employee;

-- Query 24. 
-- For each department, retrieve the department number, the number of employees in the department, and their average salary.
SELECT Dno, COUNT(*), AVG(Salary) 
FROM Company.Employee 
GROUP BY Dno;

-- Query 25. 
-- For each project, retrieve the project number, the project name, and the number of employees who work on that project. 
SELECT Pnumber, Pname, COUNT(*) 
FROM Company.Project, Company.Works_On 
WHERE Pnumber=Pno 
GROUP BY Pnumber, Pname;

-- Query 26. 
-- For each project on which more than two employees work, retrieve the project number, the project name, 
-- and the number of employees who work on the project.
SELECT Pnumber, Pname, COUNT(*) 
FROM Company.Project, Company.Works_On 
WHERE Pnumber=Pno 
GROUP BY Pnumber, Pname 
HAVING COUNT(*) > 2; 

-- Query 27. 
-- For each project,retrieve the project number,the project name, and the number of employees from department 5 
-- who work on the project.
SELECT Pnumber, Pname, COUNT(*) 
FROM Company.Project, Company.Works_On, Company.Employee 
WHERE Pnumber=Pno AND Ssn=Essn AND Dno=5 
GROUP BY Pnumber, Pname; 

-- Query ?.
-- Retrieve the name of each employee who works on at least one of the projects controlled by department number 5
SELECT Fname, Lname
FROM Company.Employee
WHERE Ssn IN (
	SELECT Essn FROM Company.Works_On WHERE Pno IN (
		SELECT Pnumber FROM Company.Project WHERE Dnum=5
	)
);

-- Query 28. 
-- For each department that has more than two employees, retrieve the department number
-- and the number of its employees who are making more than $40,000.
SELECT Dnumber, COUNT(*) Emp_cnt
FROM Company.Department, Company.Employee 
WHERE Dnumber=Dno AND Salary>40000 AND Dnumber IN (SELECT Dno FROM Company.Employee GROUP BY Dno HAVING COUNT(*) > 2)
GROUP BY Dnumber;