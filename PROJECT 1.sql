--CREATE DATABASE <Employee_Db_For_Hr_Dept>
--CREATE TABLE <TableName>(<column name> <data type> constant)
--INSERT INTO <TableName>(<COLUMN1>,<COLUMN2> ...OPTIONAL) VALUES(<VALUE1>,<VALUE2> ,VALUE3>)
CREATE DATABASE EMPLOYEEDbForHrDept_5
USE EMPLOYEEDbForHrDept_5
CREATE TABLE Employee_11 (EmpID NVARCHAR(10)primary key, EmpName nvarchar(50), 
Salary int not null,DepartmentID NVARCHAR(5), StateID NVARCHAR(5)) 
INSERT INTO Employee_11(EmpID, EmpName, Salary, DepartmentID, StateID)
VALUES ('A01', 'Monika Singh', 10000, '1', '101'),
('A02', 'Vishal Kumar', 25000, '2','101'),
('B01', 'Sunil Rana', 10000, '3', '102'),
('B02','SAURAV Rawat',15000,'2','103'), 
('B03', 'VIVEK Kataria', 19000, '4', '104'), 
('C01', 'Vipul Gupta', 45000, '2', '105'),
('C02', 'Geetika Basin', 33000, '3', '101'), 
('C03', 'Satis Sharama', 45000, '1', '103'),
('C04', 'Sagar Kumar', 50000, '2', '102'),
('C05', 'Amitabh Singh', 37000, '3', '108')
SELECT * FROM Employee_11
 


--DROP DATABASE [EMPLOYEEDbForHrDept_5]

CREATE TABLE Department_5(DepartmentID NVARCHAR(5) PRIMARY KEY,DepartmentName nvarchar(20))
INSERT INTO Department_5(DepartmentID, DepartmentName)
VALUES ('1', 'IT'),
       ('2', 'HR'),
       ('3', 'ADMIN'),
       ('4', 'Account')
SELECT * FROM Department_5


CREATE TABLE Projectmanager_5 (ProjectManagerID NVARCHAR(4)PRIMARY KEY,
ProjectManagerName nvarchar(30), DepartmentID NVARCHAR(3))
INSERT INTO Projectmanager_5(ProjectManagerID, ProjectManagerName, DepartmentID)
VALUES('1', 'Monika', '1'),
      ('2', 'Vivek', '1'),
	  ('3', 'Vipul', '2'),
      ('4', 'Satish', '2'),
	  ('5', 'Amitabh', '3')

SELECT * FROM Projectmanager_5

CREATE TABLE STATEMASTER_5(Stateid nvarchar(5) primary key, Statename nvarchar(12))
INSERT INTO STATEMASTER_5(Stateid, Statename)
VALUES ('101', 'Lagos'),
       ('102', 'Abuja'),  
	   ('103', 'Kano'), 
       ('104', 'Delta'), 
	   ('105', 'Edo'), 
	   ('106', 'Ibadan')
SELECT * FROM STATEMASTER_5




--PROJECT SOLUTION

--QUESTION 1
--SQL code to fetch the list of employees with the same salary---
SELECT *
FROM Employee_11
WHERE Salary IN (
    SELECT Salary
	FROM Employee_11
	GROUP BY Salary
	HAVING COUNT(Salary) > 1
	);


	--QUESTION-2
	--SQL code to fetch the second highest salary and the department and name of the earner--
SELECT TOP 1
Employee_11.Salary AS SecondHightestSalary, Department_5.DepartmentName, Employee_11.EmpName
FROM Employee_11
JOIN Department_5 ON Employee_11.DepartmentID = Department_5.DepartmentID
where Employee_11.Salary < (SELECT MAX (Salary) FROM Employee_11)
ORDER BY Employee_11.Salary DESC;
	

	--QUESTION 3
	---Max sal from each dept and name of dept and earners--
	SELECT MAX(Salary) hightest_salary, DepartmentID
	FROM Employee_11
	GROUP BY DepartmentID
	HAVING COUNT(Salary) >= 1;

--TO ADD THE EMP NAME WE DO
SELECT EmpName from Employee_11
where Salary in (select max(salary) highest_salary
from Employee_11
GROUP BY DepartmentID)

--QUESTION 4
--projectmanager-wise count of employees sorted by projectmanager's count in desc order--
SELECT COUNT(DISTINCT Employee_11.EmpName) COUNT_OF_PMS, Employee_11.DepartmentID
FROM Employee_11, Projectmanager_5
WHERE Employee_11.DepartmentID = Projectmanager_5.DepartmentID
group by Projectmanager_5.ProjectManagerID, Employee_11.DepartmentID
ORDER BY COUNT_OF_PMS DESC;

--QUESTION 5
--first name of empName column of employee table and append salary-- 
SELECT CONCAT(LEFT(EmpName,
  CHARINDEX(' ', EmpName) -1), '_', salary) firstName_salary
  FROM Employee_11
  SELECT * FROM Employee_11

  --QUESTION 6
  ---odd salary from the emp table---
  SELECT Salary FROM Employee_11
  WHERE Salary % 2 = 1;


  --QUESTION 7
  --view to fetch empID, EmpName, DeptName, ProjectManagerName where salary is greater than 30000--
CREATE VIEW VW_EMPLOYEE_SALARY_3000
AS 
SELECT
Employee_11.EmpID,
Employee_11.EmpName,
Department_5.DepartmentName,

Projectmanager_5.ProjectManagerName
FROM
Employee_11
INNER JOIN Department_5 ON Employee_11.DepartmentID = Department_5.DepartmentID
inner join Projectmanager_5 on Department_5.DepartmentID = Projectmanager_5.DepartmentID
WHERE Employee_11.Salary > 30000


--STORED PROCEDURES
--view to fetch the top earners from each dept, empName and dept--
  CREATE PROCEDURE SP_UpdateITSalary
  AS
  BEGIN
      UPDATE E
	  SET E.Salary = E.Salary * 1.25
	  from Employee_11 E
	  INNER JOIN Department_5 D ON E.DepartmentID = D.DepartmentID
	  INNER JOIN Projectmanager_5 P ON D.DepartmentID = P.DepartmentID
	  WHERE D.DepartmentName = 'IT' AND P.ProjectManagerName NOT IN ('Vivek', 'satish')
END
GO;
--RUN SP
EXEC SP_Updateitsalary;

SELECT * FROM Employee_11
