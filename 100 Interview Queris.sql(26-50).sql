--Question 26 Convert data from columns into Rows | Unpivot
CREATE TABLE Sales4(
    Category VARCHAR(50),
    [2015] INT,
    [2016] INT,
    [2017] INT,
    [2018] INT,
    [2019] INT,
    [2020] INT
);
select * from Sales4
INSERT INTO Sales4(Category, [2015], [2016], [2017], [2018], [2019], [2020])
VALUES
    ('Hot Drinks', 20000, 15000, 28000, 12000, 40000, 10000),
    ('Cold Drinks', 18000, 36000, 10000, 12000, 8000, 20000);
	select * from Sales4

Select Category , [Year], sales 
from (
select * from Sales4)p
unpivot 
(Sales for [Year] in (
[2015],[2016],[2017],[2018],[2019],[2020])
)as un_pivot;

--Question 27 How to convert data from rows into comma separated single column | FOR XML PATH | STUFF
select  t2.Name ,
(select','+ t1.Name
from  AdventureWorks2022.Production.ProductSubcategory as t1
where t1.ProductCategoryID= t2.ProductCategoryID
for XML Path(''),TYPE).value('.','varchar(max)')as Product_subCategory
from AdventureWorks2022.Production.ProductCategory as t2;
select *  from AdventureWorks2022.Production.ProductCategory




--Question 28 How to find employees hired in last n months | Datediff
drop table EMP;
CREATE TABLE EMP(

	[FirstName] [nvarchar](50) NOT NULL,

	[LastName] [nvarchar](50) NOT NULL,

	[HireDate] [date] NULL );
	
	INSERT INTO EMP([FirstName], [LastName], [HireDate])
VALUES
    ('Alice', 'Ciccu', '2021-01-07'),
    ('Paula', 'Barreto de Mattos', '2021-01-06'),
    ('Alejandro', 'McGuel', '2020-12-06'),
    ('Kendall', 'Keil', '2020-11-05'),
    ('Ivo', 'Salmre', '2020-10-04'),
    ('Paul', 'Komosinski', '2020-08-04'),
    ('Ashvini', 'Sharma', '2020-07-04'),
    ('Zheng', 'Mu', '2020-04-03'),
    ('Stuart', 'Munson', '2019-11-02'),
    ('Greg', 'Alderson', '2019-10-02'),
    ('David', 'Johnson', '2019-01-02');

	select * from [EMP];

select * , DATEDIFF(month , HireDate,GETDATE())
from EMP
where DATEDIFF(month , HireDate,GETDATE())<=50;

--Question 29  How to capitalize first letter of a string
select * ,Lower(LEFT(FirstName, 1))+''+Upper(SUBSTRING(FirstName,2,len(FirstName)))
from EMP;

--Question 30 How to find employees retiring at the end of the month |
CREATE TABLE Emp2(
    [FirstName] VARCHAR(50),
    [LastName] VARCHAR(50),
    [BirthDate] DATE
);
INSERT INTO Emp2([FirstName], [LastName], [BirthDate])
VALUES
    ('Guy', 'Gilbert', '1981-11-12'),
    ('Kevin', 'Brown', '1960-02-29'),
    ('Roberto', 'Tamburello', '1961-03-01'),
    ('Rob', 'Walters', '1974-07-23'),
    ('Rob', 'Walters', '1974-07-23'),
    ('Thierry', 'D''Hers', '1961-02-26'),
    ('David', 'Bradley', '1974-10-17'),
    ('David', 'Bradley', '1974-10-17'),
    ('JoLynn', 'Dobney', '1961-02-16'),
    ('Ruth', 'Elerbrock', '1961-02-28');
select * , DATEADD(Year,60,BirthDate)
from Emp2
Where DATEADD(Year,60,BirthDate)<=EOMONTH(Getdate());

--Question 31 How to identify Overlapping Date Ranges
CREATE TABLE EMP3(
    [FirstName] VARCHAR(50),
    [LastName] VARCHAR(50),
    [Title] VARCHAR(100),
    [DepartmentName] VARCHAR(50),
    [Phone] VARCHAR(20),
    [StartDate] DATE,
    [EndDate] DATE
);

INSERT INTO  EMP3([FirstName], [LastName], [Title], [DepartmentName], [Phone], [StartDate], [EndDate])
VALUES
    ('Guy', 'Gilbert', 'Production Technician - WC60', 'Production', '320-555-0195', '2006-01-28', NULL),
    ('Kevin', 'Brown', 'Marketing Assistant', 'Marketing', '150-555-0189', '2006-08-26', NULL),
    ('Roberto', 'Tamburello', 'Engineering Manager', 'Engineering', '212-555-0187', '2007-06-11', NULL),
    ('Rob', 'Walters', 'Senior Tool Designer', 'Tool Design', '612-555-0100', '2007-07-05', '2009-12-28'),
    ('Rob', 'Walters', 'Senior Tool Designer', 'Tool Design', '412-595-6754', '2009-12-27', NULL),
    ('Thiery', 'D''Hers', 'Tool Designer', 'Tool Design', '168-555-0183', '2007-07-11', NULL),
    ('David', 'Bradley', 'Marketing Manager', 'Marketing', '412-985-1234', '2007-07-20', '2009-02-11'),
    ('David', 'Bradley', 'Marketing Manager', 'Marketing', '913-555-0172', '2009-02-12', NULL),
    ('JoLynn', 'Dobney', 'Production Supervisor - WC60', 'Production', '903-555-0145', '2007-07-26', NULL),
    ('Ruth', 'Elerbrock', 'Production Technician - WC10', 'Production', '145-555-0130', '2007-08-06', NULL),
    ('Gail', 'Erickson', 'Design Engineer', 'Engineering', '849-555-0139', '2007-08-06', NULL);
	select * from EMP3
	select e1.*
	from EMP3 as e1, EMP3 as e2
	where e1.FirstName=e2.FirstName and  e1.LastName=e2.LastName and 
	e1.StartDate<e2.StartDate and e1.EndDate>e2.StartDate;

--Question 32 Count the occurrence of a character in a string
CREATE TABLE SurveyResponses(
    [SurveyID] INT,
    [Response] VARCHAR(MAX)
);
INSERT INTO SurveyResponses([SurveyID], [Response])
VALUES
    (1, 'YYNNXYXNNNXXYXNXXYYYXXXXNNN'),
    (2, 'XXXNNKYYYNYNYNYXYXYXYN');
	select * from SurveyResponses;
select * , Len(Response) as TotalLen , LEN(Replace(Replace(REPLACE(Response,'Y',''),'X',''),'K','')) TotalNCount ,
LEN(Replace(Replace(REPLACE(Response,'N',''),'X',''),'K','')) TotalYcount
from SurveyResponses;

--Question 33 Find names that start/end with 'a' | More examples | Like | Pattern Matching
select FirstName+' '+LastName as FUllName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName like '%a';

select FirstName+' '+LastName as FUllName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName like 'a%';


select FirstName+' '+LastName as FullName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName like '[ACD]%';

select FirstName+' '+LastName as FullName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName like '[A-P]%';

select FirstName+' '+LastName as FullName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName  NOT like '[A-P_]%';

select FirstName+' '+LastName as FullName
from AdventureWorks2022.HumanResources.vEmployee
Where FirstName+' '+LastName like '[^A-P]%';

select ProductNumber
from AdventureWorks2022.Production.Product
where ProductNumber like '__-%';

select ProductNumber
from AdventureWorks2022.Production.Product
where ProductNumber like '__\-%'  escape '\';--- to use escape character for reserve keywork like % in 20% discount 






--Question 34 How to find departments having only female employees?
CREATE TABLE  EMP4(
    [DepartmentName] VARCHAR(100),
    [Gender] CHAR(1)
);
INSERT INTO EMP4([DepartmentName], [Gender])
VALUES
    ('Document Control', 'F'),
    ('Document Control', 'M'),
    ('Engineering', 'M'),
    ('Engineering', 'F'),
    ('Executive', 'M'),
    ('Executive', 'F'),
    ('Facilities and Maintenance', 'M'),
    ('Facilities and Maintenance', 'F'),
    ('Finance', 'M'),
    ('Finance', 'F'),
    ('Human Resources', 'F'),
    ('Human Resources', 'M'),
    ('Information Technology', 'F'),
    ('Information Technology', 'M'),
    ('Legal', 'M'),
    ('Legal', 'F'),
    ('Marketing', 'F'),
    ('Marketing', 'M'),
    ('Operations', 'M'),
    ('Operations', 'F'),
    ('Product Management', 'M'),
    ('Product Management', 'F'),
    ('Quality Assurance', 'F'),
    ('Quality Assurance', 'M'),
    ('Research and Development', 'M'),
    ('Research and Development', 'F'),
    ('Sales', 'F'),
    ('Sales', 'M'),
    ('Supply Chain', 'M'),
    ('Supply Chain', 'F'),
    ('Customer Service', 'F'),
    ('Customer Service', 'M'),
    ('Training and Development', 'M'),
    ('Training and Development', 'F'),
    ('Accounting', 'F'),
    ('Accounting', 'M'),
    ('Administration', 'M'),
    ('Administration', 'F'),
    ('Business Development', 'F'),
    ('Business Development', 'M'),
    ('Corporate Communications', 'M'),
    ('Corporate Communications', 'F'),
    ('Customer Success', 'F'),
    ('Customer Success', 'M'),
    ('Data Science', 'M'),
    ('Data Science', 'F'),
    ('E-commerce', 'F'),
    ('E-commerce', 'M'),
    ('Health and Safety', 'M'),
    ('Health and Safety', 'F'),
    ('Internal Audit', 'F'),
    ('Internal Audit', 'M'),
    ('Investor Relations', 'M'),
    ('Investor Relations', 'F'),
    ('Logistics', 'F'),
    ('Logistics', 'M'),
    ('Public Relations', 'M'),
    ('Public Relations', 'F'),
    ('Risk Management', 'F'),
    ('Risk Management', 'M'),
    ('Sustainability', 'M'),
    ('Sustainability', 'F'),
    ('Technical Support', 'F'),
    ('Technical Support', 'M'),
    ('Warehouse', 'M'),
    ('Warehouse', 'F'),
    ('Compliance', 'F'),
    ('Compliance', 'M'),
    ('Customer Experience', 'M'),
    ('Customer Experience', 'F'),
    ('Employee Relations', 'F'),
    ('Employee Relations', 'M'),
    ('Legal Affairs', 'M'),
    ('Legal Affairs', 'F'),
    ('Product Marketing', 'F'),
    ('Product Marketing', 'M'),
    ('Strategic Planning', 'M'),
    ('Strategic Planning', 'F'),
    ('Talent Acquisition', 'F'),
    ('Talent Acquisition', 'M'),
    ('Brand Management', 'M'),
    ('Brand Management', 'F'),
    ('Competitive Intelligence', 'F'),
    ('Competitive Intelligence', 'M'),
    ('Corporate Affairs', 'M'),
    ('Corporate Affairs', 'F'),
    ('Customer Insights', 'F'),
    ('Customer Insights', 'M'),
    ('Diversity and Inclusion', 'M'),
    ('Diversity and Inclusion', 'F');
Insert Into EMP4 Values('Production Control','F') , 
			           ('abcdefgh' , 'M')

select * from EMP4;
	select Distinct DepartmentName
	from EMP4
	where Gender='F'
	Except 
	select Distinct DepartmentName
	from EMP4
	where Gender<>'F';



--Question 35 How to find strings with lower case characters | Case Insensitive | Collate
drop Table dbo.Currency ;
CREATE TABLE [dbo].[Currency] (
    [CurrencyKey] INT PRIMARY KEY,
    [CurrencyAlternateKey] VARCHAR(3) UNIQUE,
    [CurrencyName] VARCHAR(50)
);
INSERT INTO [dbo].[Currency] ([CurrencyKey], [CurrencyAlternateKey], [CurrencyName])
VALUES
    (25, 'HRK', 'Croatian Kuna'),
    (26, 'CYP', 'Cyprus Pound'),
    (27, 'CZK', 'Czech Koruna'),
    (28, 'DKK', 'Danish Krone'),
    (29, 'DEM', 'Deutsche Mark'),
    (30, 'DOP', 'Dominican Peso'),
    (31, 'VND', 'Dong'),
    (32, 'GRD', 'Drachma'),
    (33, 'egp', 'Egyptian Pound'),
    (34, 'SVC', 'El Salvador Colon'),
    (35, 'AED', 'Emirati Dirham');


select CurrencyAlternateKey,UPPER(CurrencyAlternateKey)
from dbo.Currency
Where UPPER(CurrencyAlternateKey)!=CurrencyAlternateKey;
-- To Make case insentive compariosn we have to change default collation 
select SERVERPROPERTY('collation');

select CurrencyAlternateKey,UPPER(CurrencyAlternateKey)
from dbo.Currency
Where UPPER(CurrencyAlternateKey) COLLATE Latin1_General_CS_AS !=CurrencyAlternateKey;

--Question 36  Difference between Count(*), Count(1), Count(colname) | Which is fastest

--Question 37 How to find Maximum of multiple columns | Values
Select Category, 
(Select MAX(Sales) 
from(Values ([2015]),([2016]),([2017]),([2018]),([2019]),([2020])) As SalesTB1(Sales) ) As MaxSales
from Sales4;

-- Question 38 How to find n consecutive date records | Sales for at least n consecutive days.
CREATE TABLE Sales5 (
    SalesDate DATE
);

INSERT INTO Sales5(SalesDate)
VALUES
    ('2023-01-01'),
    ('2023-01-02'),
    ('2023-01-03'),
    ('2023-01-07'),
    ('2023-01-08'),
    ('2023-01-09'),
    ('2023-01-10'),
    ('2023-01-11'),
    ('2023-01-15'),
    ('2023-01-16'),
    ('2023-01-17'),
    ('2023-01-18'),
    ('2023-01-21'),
    ('2023-01-22'),
    ('2023-01-23'),
    ('2023-01-24'),
    ('2023-01-25'),
    ('2023-01-29'),
    ('2023-01-30'),
    ('2023-01-31'),
    ('2023-02-01'),
    ('2023-02-04'),
    ('2023-02-05'),
    ('2023-02-06'),
    ('2023-02-07'),
    ('2023-02-08'),
    ('2023-02-11'),
    ('2023-02-12'),
    ('2023-02-13'),
    ('2023-02-14'),
    ('2023-02-15'),
    ('2023-02-18'),
    ('2023-02-19'),
    ('2023-02-20'),
    ('2023-02-21'),
    ('2023-02-22'),
    ('2023-02-25'),
    ('2023-02-26'),
    ('2023-02-27'),
    ('2023-02-28'),
    ('2023-03-01'),
    ('2023-03-04'),
    ('2023-03-05'),
    ('2023-03-06'),
    ('2023-03-07'),
    ('2023-03-11'),
    ('2023-03-12'),
    ('2023-03-13');
select * from Sales5;
With CTE as (
select SalesDate ,
DateAdd(d , -ROW_NUMBER()Over(Order by SalesDate),SalesDate) as Date1 
from Sales5)

Select MIn(SalesDate), count(Date1) 
from CTE 
Group BY Date1;

--Question 39 No sales for n consecutive days | Identify date gaps
select * from (
Select *,
LEAD(SalesDate)Over(Order by SalesDate) as LeadDate, 
DateDiff(d,SalesDate, LEAD(SalesDate)Over(Order by SalesDate))-1as Gap
From 
Sales5) Sale_5
where sale_5.Gap>1

select * from sales5;

--40 Question How to find First and Last day of week | Date functions
select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',GETDATE()),'1990-01-01') as weekstartingdate

select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',GETDATE())+1,'1990-01-01')-1

--Question 41 How to find top n salaries in a department and sum the remaining as 'Others'
CREATE TABLE Emp6(
    FullName VARCHAR(50),
    DepartmentName VARCHAR(50),
    Salary INT
);
INSERT INTO Emp6(FullName, DepartmentName, Salary)
VALUES
    ('Gail Erickson', 'Engineering', 51000),
    ('Jossef Goldberg', 'Engineering', 60000),
    ('Tem Duffy', 'Engineering', 85000),
    ('Roberto Tamburello', 'Marketing', 72000),
    ('David Bradley', 'Marketing', 85000),
    ('David Bradley', 'Marketing', 60000),
    ('Kevin Brown', 'Marketing', 66000),
 ('Sariya Hampadoungsataya', 'Engineering', 95000);

 select * from emp6;
Select FullName , DepartmentName, Salary from ( 
Select FullName , DepartmentName , Salary , Rank()Over(Partition BY DepartmentName  Order By Salary ) as RNK
from Emp6) as temp
Where temp.RNK<=2
Union All 
Select 'Other' as FullName , DepartmentName, SUM(Salary) from ( 
Select FullName , DepartmentName , Salary , Rank()Over(Partition BY DepartmentName  Order By Salary ) as RNK
from Emp6) as temp2
Where temp2.RNK>=2
Group by DepartmentName;

--Question 42  Compare monthly sales with previous month, same month previous year, first month of year
with CTE AS (
Select Year(ModifiedDate) as Yr, Month(ModifiedDate)as M_No, Sum(LineTotal)as sales
from AdventureWorks2022.Sales.SalesOrderDetail
Group by Year(ModifiedDate) , Month(ModifiedDate)
) 
Select * , 
lag(sales)Over(Partition by Yr  Order by  Yr , M_No)
from CTE 
Order  by Yr , M_No;
-- same month previous year 

with CTE AS (
Select Year(ModifiedDate) as Yr, Month(ModifiedDate)as M_No, Sum(LineTotal)as sales
from AdventureWorks2022.Sales.SalesOrderDetail
Group by Year(ModifiedDate) , Month(ModifiedDate)
) 
Select * , 
lag(sales,12)Over(  Order by  Yr , M_No)
from CTE 
Order  by Yr , M_No;

-- 
with CTE AS (
Select Year(ModifiedDate) as Yr, Month(ModifiedDate)as M_No, Sum(LineTotal)as sales
from AdventureWorks2022.Sales.SalesOrderDetail
Group by Year(ModifiedDate) , Month(ModifiedDate)
) 
Select * , 
lag(sales,M_No-1)Over(  Order by  Yr , M_No)
from CTE 
Order  by Yr , M_No;

-- other way of finding first month order value 
with CTE AS (
Select Year(ModifiedDate) as Yr, Month(ModifiedDate)as M_No, Sum(LineTotal)as sales
from AdventureWorks2022.Sales.SalesOrderDetail
Group by Year(ModifiedDate) , Month(ModifiedDate)
) 
Select * , 
First_value(sales)Over(Partition by Yr Order by  Yr , M_No Rows Between unbounded preceding and unbounded following )
from CTE 
Order  by Yr , M_No;

-- Question 43 How to find number of emails from the same domain | CharIndex 
CREATE TABLE Users (
    ID INT,
    Email VARCHAR(50)
);

INSERT INTO Users (ID, Email)
VALUES
    (1, 'jon24@adventure-works.com'),
    (2, 'ruben35@knowstar.org'),
    (3, 'elizabeth5@gmail.com'),
    (4, 'marco14@adventure-works.com'),
    (5, 'shannon38@knowstar.org'),
    (6, 'seth46@toyfactory.com'),
    (7, 'ethan20@adventure-works.com'),
    (8, 'russell7@gmail.com'),
    (9, 'jimmy9@skill.com'),
    (10, 'denise10@yahoo.com');
	select * from users;
select  substring(Email ,CHARINDEX('@',Email)+1, len(Email) ) , count(*)from Users
Group BY substring(Email ,CHARINDEX('@',Email)+1, len(Email) );

--Question 44 How to dynamically convert rows into columns | Dynamic Pivot
Drop Table EmployeeData;
CREATE TABLE EmployeeData (
    Name VARCHAR(50),
    value varchar(max),
	Id  int
);
Insert Into EmployeeData  (Name, Value , ID)
Values('Name', 'Adam',1),
	  ('Gender','Male',1),
	  ('Salary','50000',1),
	  ('Name','Mila',2),
	  ('Gender','Female',2),
	  ('Salary','60000',2);

select * from EmployeeData;

Declare @col nvarchar(max)
set @col=(Select STRING_AGG([Name],',') from 
(select Distinct Name from EmployeeData) t )
Declare @sql nvarchar(max)
set @sql=
'select ID ,'+ @col +' from
(Select ID, Name as Ename , value
from EmployeeData) as source_tbl
pivot
( max(value) for Ename  in (' +@col +')) as Pivot_tbl'

Exec(@sql)




----------------------------------Recursive --------------------------------
--Question 45 How to find all levels of Employee Manager Hierarchy | Recursion
CREATE TABLE Employees7(
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    DepartmentID INT,
    ManagerID INT
);
INSERT INTO Employees7(EmployeeID, EmployeeName, DepartmentID, ManagerID)
VALUES
    (1, 'Adam Owens', 103, 3),
    (2, 'Smith Jones', 102, 2),
    (3, 'Hilary Riles', 101, 4),
    (4, 'Richard Robinson', 103, 6),
    (5, 'Samuel Pitt', 101, 7),
    (6, 'Mark Miles', NULL, 7),
    (7, 'Jenny Jeff', 999, NULL);

	select * from Employees7;
 With EMP_CTE as (   
Select e1.* , 1 as Level 
from Employees7 e1
where e1.ManagerID is NUll
Union ALL 
Select e1.* , e2.Level+1 
from Employees7 e1
join EMP_CTE as e2 
on e1.ManagerID=e2.EmployeeID)
Select * from EMP_CTE;

-- Display Number 1 to 10 using recursive 
with NUM_CTE AS (
select 1 as Number 
UNION ALL
Select NUmber +1 
from NUM_CTE 
where Number<=9)
select * from NUM_CTE;

---Find the Hieararchy of employees under a given manager asha 
Drop TABLE Employees8;
CREATE TABLE Employees8 (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER,
    salary INTEGER,
    designation VARCHAR(100)
);
select * from Employees8;
INSERT INTO Employees8(id, name, manager_id, salary, designation)
VALUES
    (1, 'Shripadh', NUll, 10000, 'CEO'),
    (2, 'Satya', 3, 1400, 'Software Engineer'),
    (3, 'Jia', 5, 500, 'Data Analyst'),
    (4, 'David', 5, 1800, 'Data Scientist'),
    (5, 'Michael', 7, 3000, 'Architect'),
    (6, 'Arvind', 7, 2400, 'CTO'),
    (7, 'Asha', 1, 4200, 'Manager'),
    (8, 'Maryam', 1, 3500, 'Manager'),
    (9, 'Reshma', 8, 2000, 'Business Analyst'),
    (10, 'Akshay ', 8, 2500, 'Java Developer');



With EMP_CTE as (
Select e1.* 
from Employees8 as e1
where e1.name='Asha'
union all 
Select e1.* 
from Employees8 as e1
join EMP_CTE as h1
on e1.manager_id=h1.id )

select * from EMP_CTE;
Select * from Employees8;

--Find the heierarchy of manager above the given employee david 

select * from Employees8;
with EMP_CTE AS (
select e1.* 
from Employees8 e1
where e1.name='David'
UNION ALL 
Select e1.*
from Employees8 e1
join EMP_CTE as m1
on e1.id=m1.manager_id 
)
select * from EMP_CTE;

--Question 46 SQL Query to find a leap year 
-- If an year is divisible by 4 but not by 100 then its a leap year 
-- ifit is divisible by 400 then its a leap year 

declare @year int =2024
Select Case When (
select ISDATE(cast(@year as char(4) )+'0229'))=1 then 'Leap Year' else 'Not a Leap Year' end as Year;
select 
case when (@year%4 =0 and @year%100<>0) or (@year%400=0)
Then 'Leap Year' else 'Not a Leap Year' end as Year;

--Question 47 How to generate date records for a Calendar table
Declare @StartDate Date= '2024-01-01';
Declare @EndDate Date = '2024-12-31';

WITH CTE AS ( 
Select @StartDate as [Date]
union all 
select DATEADD(dd,1,[Date])
from CTE
Where DATEADD(dd,1,[Date]) <=@EndDate)
Select * from CTE
option (MaxRecursion 0) ;

--Question 48 What is the difference between Translate and Replace
Select TRANSLATE('abcdefghijkabcdef','abcdfg','123456');
Select TRANSLATE('AbcdefGHgh','ABCGH','12345');
Select TRANSLATE('ABCDEF','AF','10')
--Replace 
Select Replace('abcdefghijkabcdef','abcd','1234')-- This will work since given a same block of characters which can be find
Select Replace('abcdefghijkabcdef','abcd','123456');--THis will also work though given more  6 characters for group of 4 characters abcd  
Select Replace('abcdefghijkabcdef','abcdfh','123456');-- this will not work 
Select Replace('AbcdefGHgh','ABCGH','12345');--THis will also not WORK 
Select Replace ('ABCDEF','AF','10')-- THis will also not work 

--Question 49  Comparison between ROWNUMBER , RANK , DENSERANK 
CREATE TABLE Employee9
  (EmployeeID smallint NOT NULL,
  Name nvarchar(50) NOT NULL,
  DeptID smallint NULL,
  Salary integer NULL
  );

  INSERT INTO Employee9(EmployeeID, Name, DeptID, Salary)
VALUES
    (1, 'Mia', 5, 50000),
    (2, 'Adam', 2, 50000),
    (3, 'Sean', 5, 60000),
    (4, 'Robert', 2, 50000),
    (5, 'Jack', 2, 45000),
    (6, 'Neo', 5, 60000),
    (7, 'Jennifer', 2, 55000),
    (8, 'Lisa', 2, 85000),
    (9, 'Martin', 2, 35000),
    (10, 'Terry', 5, 90000),
    (12, 'David', 5, 60000);

	select * , 
	ROW_NUMBER()over(Partition by DeptID Order by salary Desc),
	Rank()over(Partition by DeptID Order by salary Desc),
	DENSE_RANK()over(Partition by DeptID Order by salary Desc)
	from 
	Employee9;

--Question 50 Employee with closest salary to average salary in a department | nearest values

select * from Employee9;
WITH CTE AS (
Select E1.* ,E2.AVG_SAL, (Salary-E2.AVG_SAL) as Diff
from Employee9 as E1
Join (
Select DeptID, AVG(Salary)as AVG_SAL
from Employee9
Group by DeptID) E2
on E1.DeptID=E2.DeptID
) 
Select * ,
Rank()Over(Partition by DeptID Order by  ABS(Diff)DESC),
Rank()Over(Partition by DeptID Order by ABS(Diff)ASC)
from CTE