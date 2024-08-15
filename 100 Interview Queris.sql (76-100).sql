--Question 76  How to schedule a SQL command | MS SQL | SQL Server Agent


--Question 77 SQL Mock Interview | Intermediate | Part 1
--Question 78 Learn & Practice SQL Complex Queries | 10 examples (Must DO for Interviews)

CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](250) NOT NULL,
	[DeptID] [int] NULL,
	[Salary] [int] NULL,
	[HireDate] [date] NULL,
	[ManagerID] [int] NULL
) ;

INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (1, 'Owens, Kristy', 1, 35000, '2018-01-22' , 3);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (2, 'Adams, Jennifer', 1, 55000, '2017-10-25' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (3, 'Smith, Brad', 1, 110000, '2015-02-02' , 7);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (4, 'Ford, Julia', 2, 75000, '2019-08-30' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (5, 'Lee, Tom', 2, 110000, '2018-10-11' , 7);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (6, 'Jones, David', 3, 85000, '2012-03-15' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (7, 'Miller, Bruce', 1, 100000, '2014-11-08' , NULL);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (9, 'Peters, Joe', 3, 11000, '2020-03-09' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (10, 'Joe, Alan', 3, 11500, '2020-03-09' , 5);
INSERT [dbo].[Employees] ([EmployeeID], [FullName], [DeptID], [Salary], [HireDate], [ManagerID]) VALUES (11, 'Clark, Kelly', 2, 11500, '2020-03-09' , 5);

SET IDENTITY_INSERT dbo.Employees ON;

select * 
from [dbo].[Employees] ;

-- Find employees with highest salary in a department.
Select EmployeeID, Emp.DeptID, Salary 
from dbo.Employees Emp
INNER JOIN 
(Select DeptID, Max(Salary) as MaxSalary from dbo.EMployees 
Group BY DeptID ) MaxSalEMp 
ON Emp.DeptID = MaxSalEmp.DeptID
AND Emp.Salary = MaxSalEmp.MaxSalary;

-- Find employees with salary lesser than department average 
Select EmployeeID, Emp.DeptID, Salary 
from dbo.Employees Emp
INNER JOIN 
(Select DeptID, AVG(Salary) as AVGSalary from dbo.EMployees 
Group BY DeptID ) AVGSalEMp 
ON Emp.DeptID = AVGSalEmp.DeptID
AND Emp.Salary < AVGSalEMp.AVGSalary

select * from (
select  EmployeeID, Emp.DeptID, Salary , AVG(Salary)
over(partition by DeptID order by salary desc rows between unbounded preceding and unbounded following)as avg_sal
from dbo.Employees Emp) t
where Salary< avg_sal

--Find employees with less than average salary in dept but more than average of ANY other Depts
Select EmployeeID, Emp.DeptID, Salary 
from dbo.Employees Emp
INNER JOIN 
(Select DeptID, Avg(Salary) as AvgSalary from dbo.Employees 
Group BY DeptID ) AvgSalEMp 
ON Emp.DeptID = AvgSalEmp.DeptID
AND Emp.Salary < AvgSalEmp.AvgSalary
WHERE Emp.Salary > ANY (Select Avg(Salary) from dbo.Employees Group By DeptID) 

--- Find employees with same salary
SELECT s1.EmployeeID, s1.Salary
FROM dbo.Employees s1
INNER JOIN dbo.Employees s2 
ON s1.Salary = s2.Salary 
AND s1.EmployeeID <> s2.EmployeeID

--- Find Dept where none of the employees has salary greater than their manager's salary
SELECT DISTINCT (DeptID) FROM dbo.Employees Employee 
WHERE DeptID NOT IN (
SELECT Emp.DeptID FROM dbo.Employees AS Emp, 
dbo.Employees AS Mgr WHERE Emp.ManagerID = Mgr.EmployeeID AND Emp.Salary > Mgr.Salary)

-- Find difference between employee salary and average salary of department
SELECT *, Salary- AVG(Salary)Over(partition by DeptID)
FROM dbo.Employees

--Find Employees whose salary is in top 2 percentile in department
Select * from (
Select EmployeeID, FullName, DeptID, Salary ,
PERCENT_RANK() OVER (Partition by DeptID Order BY Salary desc) as Percentile
from dbo.Employees) as t
where t.Percentile>0.98

--Find Employees who earn more than every employee in dept no 2
SELECT *
FROM dbo.Employees
where Salary >ALL(
SELECT Salary 
FROM dbo.Employees
where DeptID=2)

--Department names(with employee name) with more than or equal to 2 employees 
--whose salary greater than 90% of respective department average salary
select * from dbo.Employees;
WITH AVGSAL AS (
select * ,AVG(Salary)Over( Partition by DeptID ) as AVG_SAL
from dbo.Employees),
TOP90 as (
Select * from AVGSAL
where Salary>0.9*AVGSAL.AVG_SAL) , 
Count_TOP as (
Select * ,Count(FullName)OVER(Partition by DeptID) as cnt
from TOP90) 
select * from Count_TOP
where cnt >=2;

-- Select Top 3 departments with at least two employees 
--and rank them according to the percentage of their employees making over 100K in salary

select DeptID, 
100*sum(case when salary>100000 then 1 else 0 end)/  
count(EmployeeID)
from dbo.employees
group by DeptID
having count(EmployeeID)>=2;


--Question 79 SQL Query | How to find 'n' consecutive days EXCLUDING Weekends | LAG | Windows function | streaks
Drop Table Attendance;
CREATE TABLE [dbo].[Attendance](
	[Id] [int] NOT NULL,
	[Employeeid] [int] NULL,
	[LoginDt] [date] NULL);

INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (1, 1, '2022-09-01');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (2, 2, '2022-09-01');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (3, 3, '2022-09-01');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (4, 1, '2022-09-02');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (5, 2, '2022-09-02');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (6, 3, '2022-09-02');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (7, 1, '2022-09-05');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (8, 2, '2022-09-05');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (9, 1, '2022-09-06');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (10, 2, '2022-09-06');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (11, 3, '2022-09-06');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (12, 1, '2022-09-07');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (13, 2, '2022-09-07');
INSERT [dbo].[Attendance] ([Id], [Employeeid], [LoginDt]) VALUES (14, 3, '2022-09-07');

-- here what i have done  i have excluded the weekend from previous day and check it with lag date 

WITH CTE AS (
select * , DateAdd(dd , -1 ,LoginDt )as Prev_date  ,
Lag(LoginDt)over(partition by Employeeid order by LoginDt)As Lag_Date ,
DateAdd(dd, -1*
(DATEDIFF(Week ,Lag(LoginDt)over(partition by Employeeid order by LoginDt) , LoginDt)*2)
,DateAdd(dd , -1 ,LoginDt )) as Prev_date_adjusting_WKND
from Attendance)  , 
batch as (
select * , case when Lag_Date=Prev_date_adjusting_WKND then 0 else 1 end as flag
from CTE )  , 
CTE_2 as (
select * , sum(flag)over(partition by Employeeid order by LoginDt ) as GRP
from batch), 
batchcnt_cte as (
select * , Row_number()over(partition by Employeeid , GRP order by LoginDt ) as batch_cnt
from CTE_2) 
select * from batchcnt_cte
;
 
-- 2nd approach 
With CTE AS (
Select EmployeeID, 
	LoginDt, DateAdd(d, -1, LoginDt) as PrevDt,
	LAG(LoginDt) OVER (Partition by EmployeeID Order by LoginDt) as LagDt 
	from Attendance) 
	,CTE_2 as (
	select * , 
	case when prevDt=LagDt 
	or (datename(DW,LoginDt)='Monday' and Dateadd(dd,-3,LoginDt)=LagDt)
	then 0 else 1 end as consecutive_flag 
	from CTE) , 
	CTE_3 as (
	select * , sum(consecutive_flag)over(partition by EmployeeID order by LoginDt
	 )as GRP
	from CTE_2) 
	select * , count(GRP)Over(partition by EMployeeId,GRP order by LoginDt
	rows between unbounded preceding and unbounded following) as CNT
	from CTE_3;




--Question 80 SQL Interview Query | Forward Fill Values for NULL Records | Last Not NULL puzzle |
DROP TABLE  [dbo].[CurrencyRate];
CREATE TABLE [dbo].[CurrencyRate](

	[CurrencyKey] [int] NOT NULL,

	[DateKey] [int] NOT NULL,

	[EndOfDayRate] [float] NULL,

	[Date] [datetime] NULL );

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201229,0.999800039992002, '2020-12-29');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201230,1.00090081072966, '2020-12-30');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201231,0.999600159936026, '2020-12-31');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210101,Null, '2021-01-01');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210102,Null, '2021-01-02');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210103,Null, '2021-01-03')

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210104,0.999500249875062, '2021-01-04');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210105,1.000200040008, '2021-01-05');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210106,0.999200639488409, '2021-01-06');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210107,1.000200040008, '2021-01-07');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210108,0.999600159936026, '2021-01-08');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210109,Null, '2021-01-09');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210110,Null, '2021-01-10');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210111,1.00090081072966, '2021-01-11');

INSERT [dbo].[CurrencyRate] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210112,0.99930048965724, '2021-01-12');

select * 
from  [dbo].[CurrencyRate];

With CurrencyGrp as 
(Select * ,
Count(EndOfDayRate) OVER (Partition by CurrencyKey Order by DateKey) as Grp 
From CurrencyRate) 
Select *,	
FIRST_VALUE(EndOfDayRate) OVER(Partition by CurrencyKey , Grp Order by DateKey) as CurrencyRate 
FROM CurrencyGrp

-- Tweek in the above table CREATE TABLE [dbo].[CurrencyRate2](
Drop TABLE [dbo].[currencyrate2];
	CREATE TABLE [dbo].[currencyrate2](

	[CurrencyKey] [int] NOT NULL,

	[DateKey] [int] NOT NULL,

	[EndOfDayRate] [float] NULL,

	[Date] [datetime] NULL );
INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201229,0.999800039992002, '2020-12-29');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201230,1.00090081072966, '2020-12-30');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20201231,0.999600159936026, '2020-12-31');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210101,Null, '2021-01-01');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210102,Null, '2021-01-02');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (4, 20210103,Null, '2021-01-03');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (4, 20210104,0.999500249875062, '2021-01-04');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (4, 20210105,1.000200040008, '2021-01-05');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (4, 20210106,0.999200639488409, '2021-01-06');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (5, 20210107,1.000200040008, '2021-01-07');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (5, 20210108,0.999600159936026, '2021-01-08');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (5, 20210109,Null, '2021-01-09');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210110,Null, '2021-01-10');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210111,1.00090081072966, '2021-01-11');

INSERT INTO [dbo].[currencyrate2] ([CurrencyKey], [DateKey], [EndOfDayRate], [Date]) VALUES (3, 20210112,0.99930048965724, '2021-01-12');

select *
from [dbo].[currencyrate2];

WITH CurrencyGrp AS (
    SELECT *,
           COUNT(EndOfDayRate) OVER (PARTITION BY CurrencyKey ORDER BY DateKey) AS Grp 
    FROM  [dbo].[currencyrate2]
),
FilledRates AS (
    SELECT *,
           LAG(EndOfDayRate) OVER (PARTITION BY CurrencyKey ORDER BY DateKey) AS PrevRate,
		    LEAD(EndOfDayRate) OVER (PARTITION BY CurrencyKey ORDER BY DateKey) AS NEXTRate, 
			FIRST_VALUE(EndOfDayRate) OVER(Partition by CurrencyKey , Grp Order by DateKey) as CurrencyRate 

    FROM CurrencyGrp
)

Select * Into NEWFILELD2
FROM FilledRates

Select currencykey , Datekey , Coalesce(EndofDayRate ,CurrencyRate , PrevRate , NEXTRate )
from NEWFILELD2;





--81 (Reset Running Total When negative) / (Reset based on column value)
DROP TABLE Inventory;

CREATE TABLE Inventory (TransactionDate DATE, ProductID INT , Qty   INT);

INSERT INTO Inventory VALUES ('2022-09-01', 1, 100);  

INSERT INTO Inventory VALUES ('2022-09-02', 1, 200); 

INSERT INTO Inventory VALUES ('2022-09-03',1, -500); 

INSERT INTO Inventory VALUES ('2022-09-04', 1, 150); 

INSERT INTO Inventory VALUES ('2022-09-05', 1, 400); 

INSERT INTO Inventory VALUES ('2022-09-06', 1, 250);  

INSERT INTO Inventory VALUES ('2022-09-07', 1,-850);  

INSERT INTO Inventory VALUES ('2022-09-08', 1, 600); 

INSERT INTO Inventory VALUES ('2022-09-01', 2, 150); 

INSERT INTO Inventory VALUES ('2022-09-02', 2, -200);  

INSERT INTO Inventory VALUES ('2022-09-04', 2, 200); 

INSERT INTO Inventory VALUES ('2022-09-05', 2, 500);

INSERT INTO Inventory VALUES ('2022-09-06', 2, 500);

select * from Inventory;
/*WITH CTE AS (
select * , 
Case when Qty<0 then 0 else Qty end as Updated_Qty
from Inventory)
Select TransactionDate , ProductID , Qty ,
SUM(Updated_Qty)Over(Partition by ProductID Order by TransactionDate) as RunningTotal
from 
CTE; 
*/
WITH CTE AS (
select TransactionDate, ProductID,Qty , 
Case when Qty<0 then 0 else Qty end as Updated_Qty , 
sum(Case when Qty<0 then 1 else 0 end )over(partition by ProductID order by productID rows between unbounded preceding and current row ) as GRP
from Inventory
)
select TransactionDate ,ProductID,Qty, Updated_Qty  ,SUM(Updated_Qty)over(partition by ProductID , GRP order by Grp 
rows between unbounded preceding and current row )
from CTE





with Running_total as(
Select * , Sum(Qty)Over(Partition by ProductID order by TransactionDate)as Running_Total_1
from Inventory 
), 
Min_Running_Total as (
select * ,
MIN(Running_Total_1)Over(Partition by ProductID Order by TransactionDate) as MIN_Total
from Running_total)

Select * ,Running_Total_1 +
IIF(MIN_Total<0,-MIN_Total,0) as RESET_TOTAL from Min_Running_Total

Select * from Inventory;

-- Question 82 Customer Lifecycle | Identify New, Active, Repeat, Lapsed Customers
Create table TblOrders 
(OrderDate date null,
OrderKey varchar(50) null,
CustomerID integer null
);
Insert into TblOrders VALUES ('2021-01-03', 'AAA1', 11);

Insert into TblOrders VALUES ('2021-02-13', 'ABA1', 11);

Insert into TblOrders VALUES ('2021-04-30', 'BAA1', 11);

Insert into TblOrders VALUES ('2021-12-20', 'YAA1', 11);

Insert into TblOrders VALUES ('2022-03-03', 'AYA1', 11);

Insert into TblOrders VALUES ('2022-05-11', 'AZA1', 11);

Insert into TblOrders VALUES ('2022-01-30', 'HAA1', 18);

Insert into TblOrders VALUES ('2022-07-03', 'GBA1', 18);

Insert into TblOrders VALUES ('2022-09-08', 'KHA1', 18);

select * from TblOrders;
-- In the first scenario, we are going to simply identify New and Repeat Customers.

WITH CTE AS (
select *, 
MIN(OrderDate)Over(Partition by CustomerID  ORDER BY OrderDate 
Rows Between Unbounded Preceding and unbounded following) as MIN_ORDER_DATE
From TblOrders)
Select *, 
Case when MIN_ORDER_DATE=OrderDate Then 'New Cusotmer' else 'Repeat Customer' End as customer_Category 
from CTE ;

--In the second scenario, we are going to identify New, Active and Lapsed (Inactive) Customers.
WITH LAG_CTE AS (
select * , 
LAG(OrderDate)Over(PARTITION BY CustomerID ORDER BY OrderDate )as Prev_Order_date 
from TblOrders)
select * , 
Case when Prev_Order_date IS NULL THEN 'New Customer'
WHEN DATEDIFF(DD,Prev_Order_date,OrderDate)<90 Then 'Active Customer'
ELSE 'Lapsed Customer'
END as Customer_category
from LAG_CTE;

-- QUestion 83 Diff Between Charindex and patindex
declare @address varchar(100)=
'Hno 145 StreetName Main St';
Select Charindex( 'streetName', @address)
Select PATINDEX('StreetName',@address)-- This wont work since patindex work when we give a pattern 
Select PATINDEX('%StreetName%',@address)

-- Question 84 How to perform conditional / dynamic joins on multiple tables based on column value
Create table Emp11
(EmpID int identity NOT NULL,
 DeptID int NULL,
 IsExternal char(1) NULL
);

Create table Dept
(DeptID int NOT NULL,
 DeptName varchar(100) NULL
);

Create table DeptExt
(DeptID int NOT NULL,
 DeptName varchar(100) NULL
);
Insert into Emp11 VALUES (2,' ');
Insert into Emp11 VALUES (1,' ');
Insert into Emp11 VALUES (1,'X');
Insert into Emp11 VALUES (3,' ');

Insert into Dept VALUES (1,'Sales');
Insert into Dept VALUES (2,'Marketing');
Insert into Dept VALUES (3,'HR');

Insert into DeptExt VALUES (1,'Software');
Insert into DeptExt VALUES (2,'Retail');

select * from Emp11;
Select * from Dept;
select * from DeptExt;

-- Method 1
Select EMP11.* , Dept.DeptName 
from Emp11
join Dept 
on Emp11.DeptID=Dept.DeptID
and Emp11.IsExternal<>'X'
union all 
Select EMP11.* , DeptExt.DeptName 
from Emp11
join DeptExt
on Emp11.DeptID=DeptExt.DeptID
and Emp11.IsExternal='X';

--Method 2 
Select EMP11.* ,
Coalesce(Dept.DeptName,DeptExt.DeptName ) 
from Emp11
join Dept on Emp11.DeptID=Dept.DeptID and Emp11.IsExternal<>'X'
join DeptExt on Emp11.DeptID=DeptExt.DeptID and Emp11.IsExternal='X';

--QUestion 85 Extract extension from filename | Extract last occurrence of substring | REVERSE
declare @FN varchar(100) = 'Filename.ext';
Select SUBSTRING(@FN , CharIndex('.', @FN) +1, LEN(@FN))
Select RIGHT(@FN, CharIndex('.', REVERSE(@FN)) - 1)

declare @FN Varchar(100)=
'C:\Program Files\Microsoft SQL Server\MSSQL\DAATA\master.mdf'
Select RIGHT(@FN, CharIndex('\', REVERSE(@FN)) - 1)

--Question 86 How to implement Conditional Count
-- count the number of employees in each departmene whose salary is in between 30000 to 80000
-- Create the table
CREATE TABLE Employees12(
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255),
    DeptID INT,
    Salary MONEY,
    HireDate DATE,
    ManagerID INT
);

-- Insert values into the table
INSERT INTO Employees12(EmployeeID, FullName, DeptID, Salary, HireDate, ManagerID) 
VALUES 
    (1, 'Owens, Kristy', 2, 35000, '2018-01-22', 3),
    (2, 'Adams, Jennifer', 5, 55000, '2017-10-25', 5),
    (3, 'Smith, Brad', 3, 110000, '2015-02-02', 7),
    (4, 'Ford, Julia', 4, 75000, '2019-08-30', 5),
    (5, 'Lee, Tom', 2, 110000, '2018-10-11', 7),
    (6, 'Jones, David', 3, 85000, '2012-03-15', 5),
    (7, 'Miller, Bruce', 5, 100000, '2014-11-08',NULL);

	select * from employees12;

-- Show the table structure
SELECT DeptID,Count(*) as Total_count , 
sum(Case when Salary Between 30000 and 80000 then 1 else 0 end)  as Salary_count_employees
FROM Employees12
Group by DeptID;

-- Question 87 How to find most frequently purchased together items
CREATE TABLE CustOrders (
Orderid INTEGER NULL,
Customerid INTEGER NULL,
Productid Varchar(40) NULL
);
Insert into CustOrders VALUES (111, 1, 'AAA');
Insert into CustOrders VALUES (111, 1,'BBB');
Insert into CustOrders VALUES (2222, 2,'CCC');
Insert into CustOrders VALUES (2222, 2,'AAA');
Insert into CustOrders VALUES (2222, 2,'DDD');
Insert into CustOrders VALUES (3333, 3,'BBB');
Insert into CustOrders VALUES (3333, 3,'AAA');
Insert into CustOrders VALUES (3333, 3,'HHH');
Insert into CustOrders VALUES (4444, 4,'AAA');
Insert into CustOrders VALUES (4444, 4,'BBB');
Insert into CustOrders VALUES (4444, 4,'CCC');

select * 
from CustOrders;


select o1.Productid , o2.Productid , count(*) 
from CustOrders o1
join CustOrders o2
on o1.Orderid=o2.Orderid and o1.Customerid=o2.Customerid and 
o1.Productid<o2.Productid
group by o1.Productid , o2.Productid; 

-- Question 88 How to generate page recommendations for user based on friends likes 
-- Create the table
CREATE TABLE user_Friends (
    userid INT,
    friendid INT
);

-- Insert values into the table
INSERT INTO user_Friends (userid, friendid) 
VALUES 
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 3),
    (2, 4),
    (3, 5);

	-- Create the table
CREATE TABLE UserPage (
    userid INT,
    pageid INT
);

-- Insert values into the table
INSERT INTO UserPage (userid, pageid) 
VALUES 
    (1, 11),
    (1, 12),
    (2, 11),
    (2, 15),
    (2, 33),
    (1, 1);

-- Show the table contents
select * from user_Friends;
SELECT * FROM UserPage;-- this shows the page like by  user 


select  uf.userid , p.pageid as Frnd_like , pl.pageid as user_like
from user_Friends uf
Join UserPage p 
on uf.friendid=p.userid
Left join UserPage pl 
on uf.userid=pl.userid and p.pageid=pl.pageid
where pl.pageid is null




-- Question 89 How to find value in multiple columns ?
-- Create the table
CREATE TABLE YourTableName (
    col1 VARCHAR(255),
    col2 VARCHAR(255),
    col3 VARCHAR(255),
    col4 VARCHAR(255),
    col5 VARCHAR(255)
);

-- Insert values into the table
INSERT INTO YourTableName (col1, col2, col3, col4, col5) 
VALUES 
    ('Demo scheduled', 'Completed demo', 'Training postponed', 'Cancelled', 'Free day'),
    ('Demo planned', 'Cancelled', 'Completed training', 'Demo postponed', NULL);
declare @col  nvarchar(100) 
declare @sql nvarchar(500)

set @col = (select String_AGG(column_name,',') from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='YourTablename')

set @sql ='SELECT * FROM YourTableName where ''Free day'' in  (' + @col +')' 

Exec (@sql)
--Question 90 Christmas tree 
--Question 91 Cross APPLY 

-- Question 92  NOT IN Vs NOT EXISTS (Which one to use?)

-- Question 93  How to add a column if it already does not exist | Error handling
/*
IF NOT EXIST(
Select * 
from sys.columns 
where object_id=OBJECT_ID(N'TableNAME')
AND name='Column Name to check')
BEGIN 
ALTER TABLE TABLENAME
Add COLUMNNAME DATATYPE()
END*/

--Question 94 How to find number of Sundays between two dates
declare  @StartDate DateTime = '2023-03-05',
 @EndDate DateTime = '2023-03-26';

WITH CTE_date AS (
SELECT @StartDate as dt
UNION ALL
SELECT DATEADD(day,1,dt) as dt FROM CTE_date 
WHERE dt<=@EndDate
)
Select COUNT(*)
from CTE_date
Where DATENAME(WeekDay,dt) ='sunday';

--Question 95  How to find Start and End Day of the Week
Declare @dt date='2024-04-25'
select Datepart(weekday, @dt)
Select Dateadd(day,7-DATEPART(Weekday , @dt),@dt) as END_WEEK_DATE ,
DATEADD(Day,1-Datepart(WeekDay,@dt),@dt) as Start_Week_Date
,DATENAME(WeekDay,@dt)

--Question 96 

--Question 97 9 complex Sql Queries 

--How to trim multiple spaces into a single space?
declare @str varchar(100);
Set @str = 'This is best      SQL     Learning    Video';
Select Replace(@str,' ', ' ,');
Select Replace(Replace(@str,' ', ' ,'),', ','');
Select Replace(Replace(Replace(@str,' ', ' ,'),', ',''),' ,','-');

--How to find string values containing special characters like Latin characters?

declare @address varchar(100) = 'ABC ß';
Select 1 
WHERE @address like '%[^A-Za-z0-9]%';

--How to dynamically select columns in a SELECT query?
declare @col varchar(100) = 'EmployeeID , DeptID'  
declare @sql varchar(250) = 'Select ' + @col + ' from Employees'
--print(@sql)

exec(@sql)

--How to select customers who have ordered every single day in the last month?
 Create Table Orders3
 (OrderDate date ,
 CustomerID int)
  INSERT into Orders3 VALUES 
 ('2023-05-01', 1), ('2023-05-02', 1), ('2023-05-03', 1), ('2023-05-04', 1), ('2023-05-05', 1),
 ('2023-05-01', 2), ('2023-05-03', 2), ('2023-05-01', 3), ('2023-05-02', 3), ('2023-05-03', 3)

 select * from Orders3;
 Select CustomerID 
  From Orders3
  Group by CustomerID
  Having Count(distinct Orderdate) = DAY(EOMONTH(DATEADD(m,-1,Getdate())));

--How to find Top 5 and Bottom 5 Employees based on Salary in a single SQL Query?
With EmpSAL AS 
(Select * ,
ROW_NUMBER() OVER (Order By Salary ) AS Bottom5 ,
ROW_NUMBER() OVER (Order By Salary Desc) AS Top5 
FROM Employees )
Select *, 
CASE WHEN Bottom5 <= 5 THEN 'Bottom' 
WHEN Top5 <= 5 Then 'Top'
END as TopORBottom
FROM EmpSAL 
WHERE Bottom5 <= 5 OR Top5 <= 5;

--How to check if a column is masked or not?

--How to remove NULL values from a LEFT JOIN?
Select Dept.DeptID, COALESCE(Emp.EmployeeID ,0)
FROM Dept LEFT Join Employees Emp 
ON Dept.DeptID = Emp.DeptID 

-- How to find monthly sales from first Tuesday of current month to first Thursday of next month?
--Hint - 1 - Find first day of current month and first day of next month

declare @fircurrmonth date = DATEADD(dd,1,EOMONTH(getdate(), -1));
declare @firnextmonth date = DATEADD(dd,1,EOMONTH(getdate()));
--Hint - 2 - Find first Tuesday / Thursday 
-- First subtract the weekday number of the first of the month from 7.
--- Then add the desired weekday number. 
--For ex - Tuesday is weekday number 3. So add 3 to the result. For Thursday, add 5.
Declare @StartDate Date ;
Declare @EndDate Date ;
set @StartDate= Dateadd(dd,((7-Datepart(dw,@fircurrmonth)+3)%7),@fircurrmonth)
set @EndDate= Dateadd(dd,((7-Datepart(dw,@firnextmonth)+5)%7),@firnextmonth)

-- How to dynamically convert row data into dynamic number of columns and split the remaining data into subsequent rows?


-- Question 98SQL | Difference Between Union Vs Union ALL | Delete Vs Truncate | SQL Interview Question
/*The main diff between union and union all is union all  allow duplicate value and uinion doesnt 
Both Delete and truncate helps us deleting records from table , with delete statment you can specify 
where clause which can help you filter out the record from the table 
We can Rollback the transaction in delete case  but in truncate we cannot rollback 
Truncate statment doesnot allow you to specify where clause and filter out , it will delete all the records 
 */

 --Question 99 How to find Customers who placed an Order everyday in a Month
 Select CustomerID
 from Orders3
 Group by CustomerID
 Having COUNT(Distinct OrderDate)=DAY(EOMONTH(DATEADD(m,-1,GETDATE())));

 -- Question 100  ROLLUP 
 use master ;
 Select * 
 from Sales10;

 select YEAR(OrderDate) as Yr , MONTH(OrderDate) as Month_Num , DATEPART(Quarter,OrderDate) as Q_Num, SUM(SubTotal) as Total_value
from Sales10 
Group by YEAR(OrderDate)  , MONTH(OrderDate)  , DATEPART(Quarter,OrderDate) 
Union ALL 
select Distinct YEAR(OrderDate) as Yr , MONTH(OrderDate) as Month_Num , DATEPART(Quarter,OrderDate) as Q_Num, SUM(SubTotal) as Total_value
from Sales10 
Group by   GROUPING sets(
YEAR(OrderDate)  , 
YEAR(OrderDate)  , MONTH(OrderDate)  ,
YEAR(OrderDate)  , DATEPART(Quarter,OrderDate),
MONTH(OrderDate)  , DATEPART(Quarter,OrderDate)
);

Select YEAR(OrderDate) as Yr , MONTH(OrderDate) as Month_Num ,SUM(SubTotal) as Total_value
from Sales10 
Group by 
Rollup(YEAR(OrderDate) , MONTH(OrderDate) )

--Question 101 How to Convert Date / Time Formats ? | Convert | Format
Declare @dt date = '2024-03-16';
--select RIGHT('0'+Cast(MONTH(@dt) as varchar(4)),2) + cast(YEAR(@dt) as varchar(6))
-- THis is very complicated we have 2 functions format and convert to make it easy 
select CONVERT(Varchar(10), @dt,102);
select FORMAT(@dt, 'dd.MMMM.yyyy');
select FORMAT(SYSDATETIME(),N'HH:mm tt')
select FORMAT(SYSDATETIME(),N'hh:mm tt')
Select Datepart(dy,@dt)
Select Datepart(dd,@dt)
Select Datepart(dw,@dt)
Select Datepart(QUARTER,@dt)
Select Datepart(YY,@dt)

Select DATENAME(dw,Getdate())
Select DATENAME(DD,Getdate())
Select DATENAME(WK,Getdate())
Select DATENAME(QQ,Getdate())
Select DATENAME(MM,Getdate())
--MM means month  mm means minute 

-- Question 105 SQL Merge | Insert Update Delete in a Single Statement | Incremental Load


