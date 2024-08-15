--Question 1 How to Delete Duplicate from a table 
--Creating a table 
use [100 Interview Queries ];
Drop TABLE  if exists Employee;
CREATE TABLE Employee
(
 EmployeeID INT , 
 FirstName  varchar(50) ,
 LastName varchar(50) ,
 Phone varchar(20) ,
 Email varchar(50)
);
-- Inserting Values 
INSERT INTO Employee VALUES 
(1, 'Adam', 'Owens', '444345999' , 'adam@demo.com'),
(2, 'Mark', 'Wilis', '245666921' , 'mark@demo.com'),
(3, 'Natasha', 'Lee', '321888909' , 'natasha@demo.com'),
(4, 'Adam', 'Owens', '444345999' , 'adam@demo.com'),
(5, 'Riley', 'Jones', '123345959' , 'riley@demo.com'),
(6, 'Natasha', 'Lee', '321888909' , 'natasha@demo.com');
/*Delete from Employee
where EmployeeID NOT IN(
Select MAX(EmployeeID)
from Employee
Group By FirstName,LastName);
Select* from Employee;*/

/*With Employee_CTE As (
select *,
RANK()Over(partition by FirstName,LastName order by EmployeeID Desc) as rank
from Employee) 
Delete from Employee_CTE
where rank>1;
*/

-- Question 2 How to find nth highest salary?
-- Create the table
CREATE TABLE Employee2 (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Salary MONEY
);
select * from Employee2;
-- Insert values
INSERT INTO Employee2 (EmployeeID, FirstName, LastName, Phone, Email, Salary)
VALUES
(3, 'Natasha', 'Lee', '321888909', 'natasha@demo.com', 30000),
(2, 'Mark', 'Wilis', '245666921', 'mark@demo.com', 85000),
(1, 'Melissa', 'Rhodes', '1893456702', 'melissa@demo.com', 40000),
(4, 'Adam', 'Owens', '444345999', 'adam@demo.com', 60000),
(5, 'Riley', 'Jones', '123345959', 'riley@demo.com', 75000),
(6, 'Nick', 'Adams', '1363456702', 'nick@demo.com', 45000);
Select MAX(Salary) 
from 
Employee2 where Salary <
(select MAX(Salary) from Employee2);

Select top 1 * from (
Select top 2 *
from Employee2
order by Salary Desc) salary_order
order by Salary Asc;

With Salary_rank_CTE as (
Select * , 
RANK()Over(order by Salary Desc) as Rnk,
DENSE_RANK()over(Order by Salary Desc) as DenseRnk
From Employee2) 
Select * from Salary_rank_CTE
where Rnk=2;

select * , NTH_value(FirstName,2)over(order  by salary)
from Employee2

--Question 3 Employee Manager Hierarchy - Self Join
-- Create the Employee table\
Drop Table Employee3;
CREATE TABLE Employee3 (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Salary DECIMAL(10,2),
    ManagerID INT
);

-- Insert values into the Employee table
INSERT INTO Employee3 (EmployeeID, FirstName, LastName, Phone, Email, Salary, ManagerID)
VALUES 
(1, 'Adam', 'Owens', '245666921', 'adam@demo.com', '30000', 3),
(2, 'Mark', 'Hopkins', '321888909', 'mark@demo.com','85000' , Null),
(3, 'Natasha', 'Lee', NULL, 'natasha@demo.com', '85000', 2),
(4, 'Riley', 'Cooper', '1893456702', 'riley@demo.com', '40000', 5),
(5, 'Jennifer', 'Hudson', '444345999', 'jennifer@demo.com', '60000', 3),
(6, 'David', 'Wamer', '1363456702', 'david@demo.com', '45000', 5);
select * from Employee3;
Select emp_tbl.EmployeeID, emp_tbl.FirstName+' '+emp_tbl.LastName as Employeee,manger_tbl.FirstName+' '+ manger_tbl.LastName as manager ,manger_tbl.EmployeeID as Manager_ID from 
Employee3 as emp_tbl
join Employee3 as manger_tbl
on emp_tbl.ManagerID=manger_tbl.EmployeeID;

--Question 4 convert rows to columns using case when statmement 
-- Drop the table if it exists
-- Create the table
CREATE TABLE sales_data (
    sales_date DATE,
    customer_id VARCHAR(30),
    amount VARCHAR(30)
);

-- Insert values into the table
INSERT INTO sales_data VALUES ('2021-01-01', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-02', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-03', 'Cust-1', '50$');
INSERT INTO sales_data VALUES ('2021-01-01', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-01-02', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-01-03', 'Cust-2', '100$');
INSERT INTO sales_data VALUES ('2021-02-01', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-02-02', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-02-03', 'Cust-2', '-100$');
INSERT INTO sales_data VALUES ('2021-03-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-04-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-05-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-06-01', 'Cust-3', '1$');
INSERT INTO sales_data VALUES ('2021-07-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-08-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-09-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-10-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-11-01', 'Cust-3', '-1$');
INSERT INTO sales_data VALUES ('2021-12-01', 'Cust-3', '-1$');

select * from sales_data;

WITH sales AS (
    SELECT
        customer_id AS Customer,
        FORMAT(sales_date, 'MMM-yy') AS sales_date,
        REPLACE(REPLACE(amount, '$', ''), ',', '') AS amount  -- Removing both '$' and ',' characters
    FROM
        sales_data
),
sales_per_cust AS (
    SELECT
        Customer,
        SUM(CASE WHEN sales_date = 'Jan-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jan_21,
        SUM(CASE WHEN sales_date = 'Feb-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Feb_21,
        SUM(CASE WHEN sales_date = 'Mar-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Mar_21,
        SUM(CASE WHEN sales_date = 'Apr-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Apr_21,
        SUM(CASE WHEN sales_date = 'May-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS May_21,
        SUM(CASE WHEN sales_date = 'Jun-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jun_21,
        SUM(CASE WHEN sales_date = 'Jul-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jul_21,
        SUM(CASE WHEN sales_date = 'Aug-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Aug_21,
        SUM(CASE WHEN sales_date = 'Sep-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Sep_21,
        SUM(CASE WHEN sales_date = 'Oct-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Oct_21,
        SUM(CASE WHEN sales_date = 'Nov-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Nov_21,
        SUM(CASE WHEN sales_date = 'Dec-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Dec_21,
        SUM(CAST(amount AS DECIMAL(10,2))) AS Total
    FROM
        sales s
    GROUP BY
        Customer
),
sales_per_month AS (
    SELECT
        'Total' AS Customer,
        SUM(CASE WHEN sales_date = 'Jan-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jan_21,
        SUM(CASE WHEN sales_date = 'Feb-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Feb_21,
        SUM(CASE WHEN sales_date = 'Mar-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Mar_21,
        SUM(CASE WHEN sales_date = 'Apr-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Apr_21,
        SUM(CASE WHEN sales_date = 'May-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS May_21,
        SUM(CASE WHEN sales_date = 'Jun-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jun_21,
        SUM(CASE WHEN sales_date = 'Jul-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Jul_21,
        SUM(CASE WHEN sales_date = 'Aug-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Aug_21,
        SUM(CASE WHEN sales_date = 'Sep-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Sep_21,
        SUM(CASE WHEN sales_date = 'Oct-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Oct_21,
        SUM(CASE WHEN sales_date = 'Nov-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Nov_21,
        SUM(CASE WHEN sales_date = 'Dec-21' THEN CAST(amount AS DECIMAL(10,2)) ELSE 0 END) AS Dec_21,
        '' AS Total
    FROM
        sales s
),
final_data AS (
    SELECT * FROM sales_per_cust
    UNION
    SELECT * FROM sales_per_month
)
Select * from final_data;


--Question 5 Convert row to column using pivot 
select * from sales_data;
with sales as
        (select *
        from
            (
                select customer_id as Customer
                , format(sales_date, 'MMM-yy') as sales_date
                , cast(replace(amount, '$', '') as int) as amount
                from sales_data
            ) as sales
        pivot
            (
                sum(amount)
                for sales_date in ([Jan-21], [Feb-21], [Mar-21], [Apr-21]
                                ,[May-21], [Jun-21], [Jul-21], [Aug-21]
                                ,[Sep-21], [Oct-21], [Nov-21], [Dec-21])
            ) as pivot_table
        UNION
        select *
        from
            (
                select 'Total' Customer
                , format(sales_date, 'MMM-yy') as sales_date
                , cast(replace(amount, '$', '') as int) as amount
                from sales_data
            ) as sales
        pivot
            (
                sum(amount)
                for sales_date in ([Jan-21], [Feb-21], [Mar-21], [Apr-21]
                                ,[May-21], [Jun-21], [Jul-21], [Aug-21]
                                ,[Sep-21], [Oct-21], [Nov-21], [Dec-21])
            ) as pivot_table ),
    final_data as
        (select Customer
        , coalesce([Jan-21], 0) as Jan_21
        , coalesce([Feb-21], 0) as Feb_21
        , coalesce([Mar-21], 0) as Mar_21
        , coalesce([Apr-21], 0) as Apr_21
        , coalesce([May-21], 0) as May_21
        , coalesce([Jun-21], 0) as Jun_21
        , coalesce([Jul-21], 0) as Jul_21
        , coalesce([Aug-21], 0) as Aug_21
        , coalesce([Sep-21], 0) as Sep_21
        , coalesce([Oct-21], 0) as Oct_21
        , coalesce([Nov-21], 0) as Nov_21
        , coalesce([Dec-21], 0) as Dec_21
        from sales)
	select * from final_data;

--Question 6 Custom Sorting | Order by Month in an Year
-- Drop the table if it already exists
  DROP TABLE sales2;

-- Create the sales2 table
CREATE TABLE sales2 (
    start_date DATE,
    sales_value DECIMAL(10, 2)
);

-- Insert values for each month
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-01-01', 10000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-02-01', 12000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-03-01', 15000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-04-01', 14000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-05-01', 16000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-06-01', 18000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-07-01', 20000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-08-01', 22000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-09-01', 21000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-10-01', 19000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-11-01', 17000.00);
INSERT INTO sales2 (start_date, sales_value) VALUES ('2024-12-01', 23000.00);

select * from sales2;
-- IF instead of date ,month name is present we  can use case when statement  for each month name and assign values 1 to 12 as per month name and then sort it as oper that column assin value 

select *  from sales2
order by  MONTH(start_date) asc;

-- Question 7 Compare with Previous Quarter's sales | Analytical Functions | Lead | Lag
-- Drop the table if it already exists
IF OBJECT_ID('sales3', 'U') IS NOT NULL
    DROP TABLE sales3;

-- Create the sales3 table
CREATE TABLE sales3 (
    Year INT,
    QuarterName VARCHAR(10),
    Sales DECIMAL(10, 2)
);

-- Insert values into the sales3 table
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2018, 'Q1', 5000.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2018, 'Q2', 5500.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2018, 'Q3', 2500.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2018, 'Q4', 10000.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2019, 'Q1', 10000.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2019, 'Q2', 5500.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2019, 'Q3', 3000.00);
INSERT INTO sales3 (Year, QuarterName, Sales) VALUES (2019, 'Q4', 6000.00);

select * from sales3;
select * , LEAD(Sales) over (Partition by year   order by QuarterName  ) as Next_Month_Sales  , 
lag(sales) over( partition by year order by QuarterName) as prev_month_sales
from sales3;

-- Question 8 Split Concatenated String into Columns | CharIndex
-- Drop the table if it already exists
IF OBJECT_ID('Employee4', 'U') IS NOT NULL
    DROP TABLE Employee4;

-- Create the Employee4 table
CREATE TABLE Employee4 (
    EmployeeID INT,
    Name NVARCHAR(100)
);

-- Insert data into the Employee4 table
INSERT INTO Employee4 (EmployeeID, Name) VALUES (1, 'Owens, Adam');
INSERT INTO Employee4 (EmployeeID, Name) VALUES (2, 'Hopkins, David');
INSERT INTO Employee4 (EmployeeID, Name) VALUES (3, 'Jones, Mary');
INSERT INTO Employee4 (EmployeeID, Name) VALUES (4, 'Rhodes, Susan');

select * , 
Left(Name, Charindex(',',Name)-1) as last_name, 
RIGHT(Name , Len(Name)-Charindex(',',Name)) as First_name
from Employee4;

select * from Employee4;
--Question 9 Split concatenated string into columns | STRING_SPLIT function
with name_cte as (
select EmployeeID , Value , 
ROW_NUMBER()over(partition by EmployeeID order by EmployeeID )as RowNum
from Employee4
cross apply 
string_split(Name , ',')) 
select EmployeeID , [1] as last_name , [2] as first_name from name_cte
pivot 
(max(value) for RowNum in ([1],[2])) as pvt

--Question 10  Replace special characters | Control Characters | REPLACE function
-- Drop the table if it already exists
IF OBJECT_ID('Employee5', 'U') IS NOT NULL
    DROP TABLE Employee5;

-- Create the Employee5 table
CREATE TABLE Employee5 (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(100)
);

-- Insert data into the Employee5 table
INSERT INTO Employee5 (EmployeeID, FirstName, LastName, Phone, Email, Address)
VALUES 
(1, 'Adam', 'Owens', '444345999', 'adam@demo.com', '108 Main Street'),
(1, 'Mark', 'Wilis', '245666921', 'mark@demo.com', '2002 Ocean And Park Street'),
(1, 'Natasha', 'Lee', '321888909', 'natasha@demo.com', '15 Roosevelt Rd'),
(1, 'Adam', 'Owens', '321888909123', 'adam@demo.com', '10 Main Street'),  -- Inserting empty string for Phone
(1, 'Riley', 'Jones', NULL, 'nley@demo.com', '8754 NewMarket'),
(1, 'Natasha', 'Lee', NULL, 'natasha@demo.com', '875456 NewMarket');     

-- Verify data inserted
SELECT * , REPLACE(
Replace(
Replace(
REPLACE(Address,' ',''), CHAR(9),''),CHAR(10),''),CHAR(13),'') as Clean_address
FROM Employee5;

--Question 11 Calculate number of weekdays between two dates | Exclude Weekends | DateDiff | DateName
CREATE TABLE sales1(
    OrderDate DATE,
    ShipDate DATE
);
INSERT INTO sales1(OrderDate, ShipDate)
VALUES
    ('2015-01-01', '2015-01-09'),
    ('2015-01-02', '2015-01-04'),
    ('2015-01-06', '2015-01-09'),
    ('2015-01-08', '2015-01-11'),
    ('2015-01-08', '2015-01-10'),
    ('2015-01-09', '2015-01-12'),
    ('2015-01-09', '2015-01-11'),
    ('2015-01-11', '2015-01-24'),
    ('2015-01-11', '2015-01-13'),
    ('2015-01-11', '2015-01-13'),
    ('2024-02-07', '2024-02-10');

select * from sales1;
Insert into sales1 values('2024-02-07','2024-02-12')
select * ,(DATEDIFF(DW,OrderDate,ShipDate)+1)-
(DATEDIFF(ww,OrderDate,ShipDate)*2) -
(case when DATENAME(dw,ShipDate)='Saturday' then 1 else 0 end )
-(case when DATENAME(dw,OrderDate)='Sunday' then 1 else 0 end )
from sales1;

--Question 12 Date Functions | Find Age from Birth Date
-- Create the table
CREATE TABLE People (
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

-- Insert values into the table
INSERT INTO People (FirstName, LastName, BirthDate) VALUES
('Guy', 'Gilbert', '1981-11-12'),
('Kevin', 'Brown', '1986-12-01'),
('Roberto', 'Tamburello', '1974-06-12'),
('Rob', 'Walters', '1974-07-23'),
('Rob', 'Walters', '1974-07-23'),
('Thierry', 'D''Hers', '1959-02-26'),
('David', 'Bradley', '1974-10-17'),
('David', 'Bradley', '1974-10-17'),
('JoLynn', 'Dobney', '1955-08-16'),
('Ruth', 'Elerbrock', '1956-01-03'),
('Gail', 'Erickson', '1952-04-27');

select * from people;

select FirstName ,LastName ,BirthDate,
case when DATEADD(year ,Datediff(YY,BirthDate, getdate()),BirthDate) >GETDATE()
then Datediff(YY,BirthDate , getdate())-1
else Datediff(YY,BirthDate, getdate())
end as AGE
from people;

--Question 13 How to check for Alphanumeric values | Like | Wildcards
-- Create the table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

-- Insert values into the table
INSERT INTO Product (ProductID, ProductName) VALUES
(1, 'All-Purpose Bike Stand'),
(2, 'Bike Wash'),
(3, 'Cable Lock'),
(4, 'Chain'),
(5, 'Classic Vest'),
(6, 'Cycling Cap'),
(7, 'Fender Set - Mountain'),
(8, 'Front Brakes'),
(9, 'Front Derailleur'),
(10, 'Full-Finger Gloves'),
(11, 'Half-Finger Gloves');

select * 
from Product
 where ProductName like '%[a-z0-9]%';

 --Question 14 Remove leading and trailing zeroes from a decimal
 -- the best way is to convert the data type to float 
 -- select column name , cast( column name as float) from table name 

 --Question 15 How to Extract Numbers and Alphabets from an alphanumeric string | Translate function
 /*Lets suppose we have a column with empidandname 
 101raghu ,202manu 
 what we can do is we can use convert function 
 convert('1234567890','','101raghu')
 raghu
 convert(convert('1234567890','','101raghu'),'','101raghu')
 101
 */

 --Question 16 How to calculate Running Totals and Cumulative Sum ?
 -- Create the table
 Drop table Employees6;
-- Create the table
CREATE TABLE Employees6 (
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    EmailAddress VARCHAR(100),
    Phone VARCHAR(20),
    Gender CHAR(1),
    DepartmentName VARCHAR(50),
    Salary BIGINT -- Change the data type to BIGINT
);

-- Insert values into the table
INSERT INTO Employees6 (FirstName, LastName, EmailAddress, Phone, Gender, DepartmentName, Salary) VALUES
('Guy', 'Gilbert', 'guy1@adventure-works.com', '320-555-0195', 'M', 'Production', 400000),
('Kevin', 'Brown', 'kevin0@adventure-works.com', '150-555-0189', 'M', 'Marketing', 700000),
('Roberto', 'Tamburello', 'roberto0@adventure-works.com', '212-555-0187', 'M', 'Engineering', 200000),
('Renee', 'Lewis', 'renee.lewis@adventure-works.com', '4568379810', 'F', 'Marketing', 4679991000),
('Renee', 'Thomas', 'renee.thomas@adventure-works.com', '206-555-0180', 'F', 'Production', 300000),
('Thierry', 'D''Hers', 'thiery0@adventure-works.com', NULL, 'M', 'Tool Design', 200000),
('Guy', 'Gilbert', 'guy@adventureworks.com', '168-555-0183', NULL, NULL, NULL),
('JoLynn', 'Dobney', 'jolynn0@adventure-works.com', NULL, 'F', 'Production', 800000),
('Ruth', 'Elerbrock', 'ruth0@adventure-works.com', NULL, 'F', 'Production', NULL),
('Gail', 'Erickson', 'gail0@adventure-works.com', NULL, 'F', 'Engineering', 100000),
('Bany', 'Johnson', 'bany0@adventure-works.com', '903-555-0145', 'M', 'Production', NULL);

--This table has duplicate values so 
select *, 
sum(salary) over(order by salary , LastName desc) as CMSUM,
sum(salary) over(partition by DepartmentName order by salary , LastName desc)as CMSUM1
from Employees6;

--Question 17 How to calculate YTD and MTD totals | Window Functions
-- Create the "Order" table
drop table Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    TotalValue DECIMAL(10, 2)
);

-- Insert sample records into the "Order" table
INSERT INTO Orders (OrderID, OrderDate, TotalValue) VALUES
(1, '2023-01-01', 100.50),
(2, '2023-01-01', 100.50),
(3, '2023-01-10', 200.00),
(4, '2023-02-01', 100.50),
(5, '2023-02-05', 300.50),
(6, '2023-02-15', 125.25),
(7, '2023-02-01', 175.00),
(8, '2023-03-10', 250.75),
(9, '2023-03-20', 180.50),
(10, '2023-04-01', 90.25),
(11, '2023-04-05', 210.00),
(12, '2023-04-15', 150.50),
(13, '2023-05-01', 175.25),
(14, '2023-05-05', 120.00),
(15, '2023-05-10', 190.75),
(16, '2023-06-01', 225.50),
(17, '2023-06-05', 140.25),
(18, '2023-06-15', 260.00),
(19, '2023-07-01', 75.75),
(20, '2023-07-05', 180.50),
(21, '2023-07-10', 300.25),
(22, '2023-08-01', 175.00),
(23, '2023-08-05', 220.75),
(24, '2023-08-15', 120.50),
(25, '2023-09-01', 190.25),
(26, '2023-09-05', 150.00),
(27, '2023-09-10', 275.75),
(28, '2023-10-01', 210.50),
(29, '2023-10-05', 130.25),
(30, '2023-10-15', 240.00);

select * from Orders;
select * ,
sum(TotalValue)Over(partition by year(OrderDate) order by OrderDate
Rows Between Unbounded Preceding and current Row) as YTD , 
sum(TotalValue)Over(partition by year(OrderDate) , Month(OrderDate) order by OrderDate
Rows Between Unbounded Preceding and current Row) as MTD
from Orders;

--Question 18 How to calculate the First and Last Order | FIRST_VALUE | LAST_VALUE | Window Functions
select * ,
First_value(OrderID)Over(partition by year(OrderDate) order by OrderDate
Rows Between Unbounded Preceding and current Row) as firstorder  , 
Last_Value(OrderID)Over(partition by year(OrderDate)  order by OrderDate
Rows Between  current Row and unbounded following) as lastorder
from Orders;

-- Question 19 Find employees with salary less than Dept average but more than average of any other Dept | ANY
-- Create the "Employee" table
Drop Table Employee7;
CREATE TABLE Employee7 (
    EmployeeKey INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert data into the "Employee" table
INSERT INTO Employee7(EmployeeKey, FirstName, LastName, DepartmentName, Salary) VALUES
(10, 'Ruth', 'Elerbrock', 'Production', 66000),
(16, 'Taylor', 'Maxwell', 'Production', 50000),
(19, 'Dons', 'Hartwig', 'Production', 68000),
(24, 'Stuart', 'Munson', 'Production', 76000),
(33, 'Alejandro', 'McGuel', 'Production', 86000),
(39, 'Simon', 'Rapier', 'Production', 96000),
(23, 'Peter', 'Kuppa', 'Production Control', 51000),
(37, 'Vamsi', 'Krebs', 'Shipping and Receiving', 62000);

-- Display the contents of the "Employee" table
SELECT * FROM Employee7;
WITH Dept_AVG AS (
    SELECT *, 
           AVG(salary) OVER (PARTITION BY DepartmentName ORDER BY salary DESC
                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Dept_AVG_Salary 
    FROM Employee7
)
SELECT * 
FROM Dept_AVG
WHERE salary < Dept_AVG_Salary 
  AND salary >ANY(SELECT AVG(salary) FROM Employee7 Group By DepartmentName);

--Question 20 How to find employees with highest salary in a department
Select * from (
select 
* , RANK()Over(Partition by DepartmentName order by salary Desc) as RNK,
MAX(Salary)Over(Partition by DepartmentName order by salary Desc) as MAX_

from 
Employee7) EMP
where EMP.RNK=1;
--Question 21 Find employees with salary greater than department average / and less than company average
WITH Dept_AVG AS (
    SELECT *, 
           AVG(salary) OVER (PARTITION BY DepartmentName ORDER BY salary DESC
                             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Dept_AVG_Salary 
    FROM Employee7
)
SELECT * 
FROM Dept_AVG
WHERE salary > Dept_AVG_Salary 
  AND salary < (SELECT AVG(salary) FROM Employee7);

--Question 22  How to find employees with salary greater than their manager's salary
-- Create the "Employee" table
CREATE TABLE Employee18 (
    EmployeeKey INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentName VARCHAR(50),
    Salary DECIMAL(10, 2),
    ManagerKey INT
);

-- Insert data into the "Employee" table
INSERT INTO Employee18(EmployeeKey, FirstName, LastName, DepartmentName, Salary, ManagerKey) VALUES
(1, 'Guy', 'Gilbert', 'Production', 60000, 11),
(2, 'Kevin', 'Brown', 'Marketing', 60000, 11),
(3, 'Roberto', 'Tamburello', 'Engineering', 66000, 11),
(4, 'Rob', 'Walters', 'Tool Design', 72000, 11),
(5, 'Rob', 'Walters', 'Tool Design', 51000,11),
(6, 'Thiery', 'D''Hers', 'Tool Design', 85000,11),
(7, 'David', 'Bradley', 'Marketing', 72000, 11),
(8, 'David', 'Bradley', 'Marketing', 85000, 11),
(9, 'JoLynn', 'Dobney', 'Production', 60000, 11),
(10, 'Ruth', 'Ellerbrock', 'Production', 60000, 11),
(11, 'Gail', 'Erickson', 'Engineering', 66000, 50);
select * from Employee18;
with CTE AS (
select emp.*, mgr.FirstName as Manager_Name , mgr.salary as Manager_salary
from Employee18 as emp 
join Employee18 as mgr 
on mgr.EmployeeKey=emp.ManagerKey) 
Select * from CTE Where Salary>Manager_salary;

-- Question 23  How to increment salaries of employees who have 2 years with the organization | Datediff
/*Select EmployeeKey, FirstName, LastName, DepartmentName, Salary, Salary*1.15 as IncrSalary   from dbo.Employee emp  
WHERE DATEDIFF(YEAR,HireDate,'2020-12-31') > 2 */

select * ,
AVG(salary)Over(partition by DepartmentName order by salary desc Rows Between Unbounded Preceding and current row ),
AVG(salary)Over(partition by DepartmentName order by salary desc Rows Between Unbounded Preceding and Unbounded Following ),
AVG(salary)Over(partition by DepartmentName order by salary  desc Range Between Unbounded Preceding and current row ),
AVG(salary)Over(partition by DepartmentName order by salary Range Between Unbounded Preceding and Unbounded following )
from Employees6;

select * from Orders;
select * , 
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue  Rows Between Unbounded Preceding and current row)as right_Cummulative,
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue  Range Between Unbounded Preceding and current row)Wrong_cummulative,
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue Rows Between Unbounded Preceding and Unbounded Following) as Correct_monthsale,
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue Range Between Unbounded Preceding and Unbounded Following)AS COORECT_mONTHLY,
avg(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue  Rows Between 2 Preceding and current row)as r_movingavg,
last_value(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue  Rows Between Unbounded Preceding and current row)as Wrong_LastItem,
Last_value(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue Rows Between Unbounded Preceding and Unbounded Following)as Right_lastitem ,
Last_value(OrderDate)Over(Partition BY Month(OrderDate) Order by OrderDate Range Between Unbounded Preceding and Unbounded Following)as wrong_lastitem ,
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue  Range Between Unbounded Preceding and current row)Wrong_cummulative,
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue Rows Between Unbounded Preceding and Unbounded Following),
sum(TotalValue)Over(Partition BY Month(OrderDate) Order by TotalValue Range Between Unbounded Preceding and Unbounded Following)
from orders;
--what range will do, it will take same/duplicate  order date since its in order by clause as one date and sum them and shown there aggregated same value 

--Question 24  How to calculate Biweekly Friday dates in an Year | Date Functions
/* To find Bi-weekly Friday in an year , first we need to first friday of an year 
or you can say first friday in starting month of any year .
Once the frist friday is available we will add the 14 days to that day with conitnous loop for 365 orr 366 days 
since we are calculating Bi-weekly friday in an year 
we can take from master database spt_values table where type is p */
-- frist friday of an year 
--here we are checking the what is the first day of an year 
select Datepart(WEEKDAY,'01-01-2024') ,DATENAME(WEEKDAY,'01-01-2024');
-- here we are subtracting the first day value from 6 since we want to check first friday of any yar 
select Case when Datepart(WEEKDAY,'01-01-2024')> 6 Then 
DATEADD(dw,(6-Datepart(WEEKDAY,'01-01-2024'))+7,'01-01-2024')
Else 
DATEADD(dw,6-Datepart(WEEKDAY,'01-01-2024'),'01-01-2024') End ;

Declare @first_friday date =
Case when Datepart(WEEKDAY,'01-01-2024')> 6 Then 
DATEADD(dw,(6-Datepart(WEEKDAY,'01-01-2024'))+7,'01-01-2024')
Else 
DATEADD(dw,6-Datepart(WEEKDAY,'01-01-2024'),'01-01-2024') End

select DATEADD(DAY,number, @first_friday)as Bi_weekly_friday 
from master..spt_values
where type='p' and number%14=0 and YEAR(DATEADD(DAY,number, @first_friday))=2024

--Question 25 How to generate a two digit alphabetic sequence | Cycle through alphabets
With Alphabets_CTE AS (
select 
ROW_NUMBER()Over(order by column_Id)as ROWNUMBER
from master.sys.columns),
CTE_2 as (
select char(((ROWNUMBER -1)%26 ) +65) as Alpha
from Alphabets_CTE
Where ROWNUMBER<=26)
Select c1.Alpha +''+
c2.Alpha +''+
c3.Alpha 
from CTE_2 as c1 
Cross APPLY 
(Select Alpha from CTE_2) as C2
cross apply 
(Select Alpha from CTE_2) as c3;