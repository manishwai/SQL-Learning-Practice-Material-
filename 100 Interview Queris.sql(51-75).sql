-- Question 51 How many times a substring occurs in a value ? | REPLACE | LEN

Declare @str varchar(max)='Yes,No,Yes,No,Yes,No'
Declare @Replace_str varchar(max)='yes'

select REPLACE(@str,@replace_str,''),(LEN(@str)-LEN(REPLACE(@str,@replace_str,'')))/Len(@Replace_str)

--Question 52 How to generate missing date records | How to create Reports showing data for each day
-- Create the Orders table
CREATE TABLE Orders2(
    OrderID INT,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE
);

-- Insert values into the Orders table
INSERT INTO Orders2(OrderID, CustomerID, ProductID, OrderDate)
VALUES
(6, 7, 111, '2022-01-01'),
(6, 7, 111, '2022-01-02'),
(6, 7, 111, '2022-01-03'),
(6, 7, 111, '2022-01-04'),
(6, 7, 111, '2022-01-05'),
(6, 7, 111, '2022-01-06'),
(6, 7, 111, '2022-01-07'),
(6, 7, 111, '2022-01-08'),
(6, 7, 111, '2022-01-09'),
(6, 7, 111, '2022-01-11'),
(1, 123, 7, '2022-01-21'),
(1, 123, 8, '2022-01-12'),
(1, 123, 9, '2022-01-13'),
(1, 123, 10, '2022-01-14'),
(1, 123, 11, '2022-01-15'),
(1, 123, 12, '2022-01-17'),
(1, 123, 13, '2022-01-18'),
(1, 123, 14, '2022-01-22'),
(1, 123, 15, '2022-01-25');

Select * from Orders2;

Declare @StartDate Date='2022-01-01';
Declare @EndDate Date='2022-01-31';
With Dates_cte as (
Select @StartDate as[Date]
Union ALL
Select Dateadd(dd,1,[Date]) 
from 
Dates_cte
where Dateadd(dd,1,[Date]) 
<=@EndDate)
Select count(*)
from Dates_cte as d
Left Join Orders2 as o 
on d.Date=o.OrderDate
Where o.OrderID is null;

--QUestion 53 How to pad zeroes to a number | LEFT

With Num_CTE as (
select 1 as Number 
union all 
select Number+1 
from Num_CTE
where Number <99 )
select  Number , Right(Concat('0000',Number),4)
from Num_CTE;

--Question 54 How to replace multiple commas with a single comma
declare @var varchar(100)='abc,,def,,,,,ghi,,jkl,,mnop,qrst,,uvw,,xy,z';

Select REPLACE(@var,',','*,'),Replace(REPLACE(@var,',','*,'),',*',''),Replace(Replace(REPLACE(@var,',','*,'),',*',''),'*','')

--Question 55 Sort by one country always at top and others in ascending order | Custom sorting
-- Create the Countries table
CREATE TABLE Countries (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100)
);

-- Insert values into the Countries table
INSERT INTO Countries (CountryID, CountryName) VALUES
(1, 'United States'),
(2, 'Canada'),
(3, 'United Kingdom'),
(4, 'Germany'),
(5, 'France'),
(6, 'Australia'),
(7, 'Japan'),
(8, 'China'),
(9, 'India'),
(10, 'Brazil'),
(11, 'Italy'),
(12, 'Spain'),
(13, 'Mexico'),
(14, 'South Korea'),
(15, 'Russia'),
(16, 'Netherlands'),
(17, 'Switzerland'),
(18, 'Sweden'),
(19, 'Norway'),
(20, 'Denmark');
select * 
from Countries
Order by 
(case when CountryName ='India' then 0 
when CountryName='China' then 1
when CountryName='Italy' then 2 
else 3 end ) , 
CountryName;

--Question 56 How to find the closest matching string | best match | 2 methods
-- Create the Rivers table
CREATE TABLE Rivers (
    RiverName VARCHAR(100)
);

-- Insert values into the Rivers table
INSERT INTO Rivers (RiverName) VALUES
('Blue Nile'),
('Amazon'),
('Congo'),
('Nile'),
('Ganges'),
('Seine'),
('White Nile');
--Method 1
select * from Rivers
where RiverName like '%Nile%'
order by Len(RiverName)-Len('Nile');
--Method 2 
select * , SOUNDEX(RiverName) ,DIFFERENCE(soundex(RiverName),SOUNDEX('Nile'))
from Rivers
where RiverName like '%Nile%'
order by DIFFERENCE(soundex(RiverName),SOUNDEX('Nile')) Desc ;


-- Question 57Dynamically Pass Values to IN clause | Parametrize Values | String_Split
declare @var Varchar(100) ='Mountain Bikes ,Road Bikes,Forks,Pedals';
select * 
from AdventureWorks2022.Production.ProductSubcategory
where Name in (select [value] from string_split(@var ,','));

-- Question 58 How to extract numbers from String | Split word into characters | Two methods
DECLARE @string VARCHAR(100) = '22November20245A';
DECLARE @characters TABLE (Character VARCHAR(1));
DECLARE @index INT = 1;
DECLARE @length INT = LEN(@string);

WHILE @index <= @length
BEGIN
    INSERT INTO @characters (Character)
    VALUES (SUBSTRING(@string, @index, 1));

    SET @index = @index + 1;
END

SELECT string_agg(Character,'')
FROM @characters
where Character like '%[aA-Zz]%'




-- Method 1 
Declare @string  varchar(100) ='22November20245A';
with Position as (
Select 1 as NUM 
union all 
select NUM+1 from Position
where NUM<=len(@string)),
 Char_1 as (
select col from position 
CROSS APPLY
(select SUBSTRING(@string,NUM,1)as col)as char)
select  STRING_AGG(col,'')
from Char_1
where col like '%[aA-zZ]%';

--Method 2 
Declare @string  varchar(100) ='22November20245A';
with Position as (
Select 1 as NUM 
union all 
select NUM+1 from Position
where NUM<=len(@string)),
Char_1 as (
select STUFF(@string , 1,1,'') as Rem_str ,Left(@string,1) as col
union all
select Stuff(Rem_str,1,1,'') as rem_str , Left(Rem_str,1) as col
from char_1
where len(Rem_str)>0)
select STRING_AGG(COL,'') 
from Char_1
WHERE COL LIKE '%[Aa-Zz]%';

--Question 59  How to sort alphanumeric data | alphabets and numbers in correct order | PATINDEX
CREATE TABLE dbo.ID_Key (
    ID nvarchar(100) NULL
);

INSERT INTO dbo.ID_Key (ID) VALUES ('1');
INSERT INTO dbo.ID_Key (ID) VALUES ('2');
INSERT INTO dbo.ID_Key (ID) VALUES ('21');
INSERT INTO dbo.ID_Key (ID) VALUES ('10');
INSERT INTO dbo.ID_Key (ID) VALUES ('Alpha11');
INSERT INTO dbo.ID_Key (ID) VALUES ('Alpha2');
INSERT INTO dbo.ID_Key (ID) VALUES ('210');
INSERT INTO dbo.ID_Key (ID) VALUES ('Alpha1');

select * from dbo.ID_Key;

select ID , 
LEFT(ID,PATINDEX('%[0-9]%',ID)-1),
SUBSTRING(ID,PATINDEX('%[0-9]%',ID),LEN(ID))
from dbo.ID_Key
Order by 
LEFT(ID,PATINDEX('%[0-9]%',ID)-1),
SUBSTRING(ID,PATINDEX('%[0-9]%',ID),LEN(ID))
;


--Question 60  How to update part of a string | UPDATE
-- Create table command
CREATE TABLE Employee10(
    EmployeeID NVARCHAR(10),
    Email NVARCHAR(100)
);

-- Insert values command
INSERT INTO Employee10(EmployeeID, Email) VALUES 
('1', 'adam@demo.com'),
('3', 'mike@demo.com'),
('2', 'mila@demo.com'),
('4', 'david@demo.com'),
('5', 'tina@demo.com');
update Employee10
set Email=REPLACE(Email,'@demo.com','demo1.com')

select * 
from Employee10;

--Question 61 How to insert line breaks in data | Carriage return | Line feed
declare @data nvarchar(100);
set @data = 'This is line1.This is line2.This is line3.This is line4.';
--set @data1 = 'This is line1.' + CHAR(10) + CHAR(13) + 'This is line2.'

--This is line3.This is line4.';

Select REPLACE(@data, '.', '.' + CHAR(10) + CHAR(13))

-- QUestion 62 How to generate random passwords | Unique Random values | NEWID function | PART - 1
--Using NEWID 
select NEWID();
select CHECKSUM(NEWID());
select ABS(CHECKSUM(NEWID()));
select ABS(CHECKSUM(NEWID()))%10000;

--Question  63How to generate random passwords | Unique Random values | NEWID function | PART - 2
--Using Random function 
select Rand();
Select Rand(3);
declare @upperlimit int  =10 ;
declare @lowerlimit int =2;
Select Floor(Rand()*(@upperlimit-@lowerlimit)+@lowerlimit);
select char(Rand()*(26)+65)+char(Rand()*(26)+65)+char(Rand()*(26)+65);

--Question  64 SQL Incremental data load | 3 ways to perform Upsert | Update else Insert| EXISTS | ROWCOUNT | MERGE
CREATE TABLE dbo.Employee20 (
    EmployeeID smallint NOT NULL,
    Name nvarchar(50) NOT NULL,
    DeptID smallint NULL,
    Salary int NULL
);

INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (1, 'Mia', 5, 50000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (2, 'Adam', 2, 50000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (3, 'Sean', 5, 60000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (4, 'Robert', 2, 50000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (5, 'Jack', 2, 45000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (6, 'Neo', 5, 60000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (7, 'Jennifer', 2, 55000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (8, 'Lisa', 2, 85000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (9, 'Martin', 2, 35000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (10, 'Brad', 5, 90000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (11, 'Cathy', 2, 60000);
INSERT INTO dbo.Employee20 (EmployeeID, Name, DeptID, Salary) VALUES (12, 'David', 5, 60000);

Select * from Employee20;
-- Method  1 
BEGIN Transaction
declare @EmployeeID int = 17;
declare @Name varchar(max) = 'Brad';

If Exists ( Select * from Employee20 With (UPDLOCK , SERIALZATION) 
where EmployeeID=@EmployeeID)
Update dbo.Employee20
set Name =@Name
where EmployeeID=@EmployeeID
ELSE 
Insert Into dbo.Employee20(EmployeeID,Name) values (@EmployeeID,@Name)
COMMIT TRANSACTION ; 

-- Method 2 
BEGIN Transaction
declare @EmployeeID int = 17;
declare @Name varchar(max) = 'Brad';

Update dbo.Employee20
set Name =@Name
where EmployeeID=@EmployeeID
IF @@ROWCOUNT = 0  
Insert Into dbo.Employee20(EmployeeID,Name) values (@EmployeeID,@Name)
COMMIT TRANSACTION ;

-- Method 3 Merge 
declare @EmployeeID int = 17;
declare @Name varchar(max) = 'Brad';

MERGE dbo.Employee20 with (HOLDLOCK) as Target 
USING (VALUES(@EmployeeID,@Name )) as source(EmployeeID, Name)
on Target.EmployeeId=Source.EmployeeID
WHEN MATCHED 
THEN
UPDATE
SET Target.Name=Source.Name
WHEN NOT MATCHED 
THEN 
INSERT (EmployeeID, NAME) Values(Source.EmployeeID, Source.Name);


--Question 65  Convert data from rows into single concatenated and delimited string | STRING_AGG
CREATE TABLE Projects(

	[ProjectID] [smallint] NOT NULL,

	[ProjectName] [nvarchar](250) NULL,

	[ManagerName] [nvarchar](250) NOT NULL

)
INSERT INTO Projects([ProjectID],[ProjectName],[ManagerName])
VALUES 
(100, 'Data Quality', 'Tom'),
(101, 'Data Warehouse', 'Jen'),
(102, 'Profiling', 'Brad'),
(103, 'Data Lake', 'Brad'),
(104, 'Data Analytics', 'Amy'),
(105, 'Reporting', 'Amy'),
(106, 'Lineage', 'Tom'),
(107, 'Management', 'Matt'),
(108, 'Big Data', 'Tom'),
(109, NULL, 'Tom');

select ManagerName , STRING_AGG(ProjectName,'|') 
Within Group (Order by ProjectName) as Projects
from Projects
Group by ManagerName
;
--Question 66 How to Store Images in Database 
Create table dbo.Images
(id int null,
Img varbinary(max) null)

Insert into dbo.Images values
(1, (Select * from Openrowset (BULK 'C:\SQL\Images\SQL.png' , Single_Blob) as T))
/*now this will generate a text or locarion of image what 
we can do is we can use front end application like power bi or visual basic
what we can do we can connect the server with ower bi use the database and then table and from 
there transform it in power query in power bi 
how can we do that ?
WE CAN USE A FORMULA TO CONVERT VARBINARY TO IMAGE URL 
FORMULA IS 
*/
--Question 67 Regex 

select ProductID,Name
from AdventureWorks2022.Production.Product
where name like '%Bike%';

--   Second character is 'R'
select ProductID,Name
from AdventureWorks2022.Production.Product
where name like '_R%';

--   Third character is '-' and 4th character is 'U'
select ProductID,Name
from AdventureWorks2022.Production.Product
where name like '__-U%';

/*Check for Product Number pattern
Any 2 characters followed by '-' followed
by any 4 characters followed by '-' followed
 by any single character  - HL-U509-R
 */
/*Select * from SalesLT.Product 
Where ProductNUmber like '__-____-_'
*/

-- [ ]	Any single character within the specified range
--     Above pattern with last char L or M
/*
Select * from SalesLT.Product 
Where ProductNUmber like '__-____-[LM]'
*/

--    Above pattern with last char between L and S
/*
Select * from SalesLT.Product 
Where ProductNUmber like '__-____-[L-S]'
*/

--      Above pattern with last char not between L and R
/*
Select * from SalesLT.Product 
Where ProductNUmber like '__-____-[^L-R]'
*/

--      Product number not starting with F
/*
Select * from SalesLT.Product 
Where ProductNUmber like '[^F]%'
*/

--     Product number not starting with F or H
/*
Select * from SalesLT.Product 
Where ProductNUmber like '[^FH]%'
*/

--  Product Number with 4th and 5th chars as numbers
/*
 Select * from SalesLT.Product 
where ProductNumber like '___[0-9][0-9]%'
*/

-- Product Number - after 1st hyphen has either numbers or special characters
/*
Select * from SalesLT.Product 
where ProductNumber like '__-[^A-Z]%'
*/




select ProductID,Name
from AdventureWorks2022.Production.Product
where name like '__-U%';





-- Question 68 Load data from CSV File 
Create table dbo.Demo
(ID int null,
Product varchar(100) null);
BULK INSERT dbo.Demo 
FROM 'C:\SQL\Files\Test.csv' 
WITH (FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
BATCHSIZE = 25000,
MAXERRORS = 2);

-- Method 2 Openrowset 
Select * into dbo.Demo1
from 
OPENROWSET( BULK 'C:\SQL\Files\Test.csv' ,
FORMATFILE = 'C:\SQL\Files\Test.fmt',
FIRSTROW = 2) as a;


--Question 69 How to trim leading zeroes | PATINDEX
declare @col varchar(100) = '000001' ;
-- Method 1 
Select Substring(@col ,Patindex('%[^0]%',@col),len(@col))
 -- But this method wont work if all numbers are 0 so method 2 
Select Substring(@col ,Patindex('%[^0]%',@col+'-'),len(@col))

--Question 70  How to swap column values
Create table Coordinates
(x int,
y int);

Insert into Coordinates Values (1,2);
Insert into Coordinates Values (1,4);
Insert into Coordinates Values (4,2);
Insert into Coordinates Values (2,4);
Insert into Coordinates Values (3,3);
Insert into Coordinates Values (3,0);

select * 
from Coordinates;

Update Coordinates
set x=y , y=x;
select * 
from Coordinates;

--Question 71 How to identify reverse pairs in data records | Self Join
select A.x , A.Y 
from Coordinates A 
Join Coordinates B 
on A.x=B.y and A.y=B.x and A.x>A.y;

-- Question 72  Calculate Yearly, Quarterly, Monthly totals in a single SQL Query |Grouping Sets
CREATE TABLE Sales10(
	[SalesOrderID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SubTotal] [money] NOT NULL
) 
INSERT INTO Sales10 ([SalesOrderID], [OrderDate], [SalesOrderNumber], [CustomerID], [SubTotal]) 
VALUES 
(71774, CAST(N'2021-01-10T00:00:00.000' AS DateTime), N'SO71774', 29847, 880.3484),
(71776, CAST(N'2021-02-21T00:00:00.000' AS DateTime), N'SO71776', 30072, 78.8100),
(71780, CAST(N'2021-02-21T00:00:00.000' AS DateTime), N'SO71780', 30113, 38418.6895),
(71782, CAST(N'2021-02-27T00:00:00.000' AS DateTime), N'SO71782', 29485, 39785.3304),
(71783, CAST(N'2021-03-07T00:00:00.000' AS DateTime), N'SO71783', 29957, 83858.4261),
(71784, CAST(N'2021-03-17T00:00:00.000' AS DateTime), N'SO71784', 29736, 108561.8317),
(71796, CAST(N'2021-03-20T00:00:00.000' AS DateTime), N'SO71796', 29660, 57634.6342),
(71797, CAST(N'2021-04-10T00:00:00.000' AS DateTime), N'SO71797', 29796, 78029.6898),
(71815, CAST(N'2021-06-01T00:00:00.000' AS DateTime), N'SO71815', 30089, 1141.5782),
(71816, CAST(N'2021-05-01T00:00:00.000' AS DateTime), N'SO71816', 30027, 3398.1659),
(71831, CAST(N'2021-03-04T00:00:00.000' AS DateTime), N'SO71831', 30019, 2016.3408),
(71832, CAST(N'2020-03-04T00:00:00.000' AS DateTime), N'SO71832', 29922, 35775.2113),
(71845, CAST(N'2020-02-04T00:00:00.000' AS DateTime), N'SO71845', 29938, 41622.0511),
(71846, CAST(N'2020-06-22T00:00:00.000' AS DateTime), N'SO71846', 30102, 2453.7645),
(71856, CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'SO71856', 30033, 602.1946),
(71858, CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'SO71858', 29653, 13823.7083),
(71863, CAST(N'2021-05-18T00:00:00.000' AS DateTime), N'SO71863', 29975, 3324.2759),
(71867, CAST(N'2021-01-18T00:00:00.000' AS DateTime), N'SO71867', 29644, 1059.3100),
(71885, CAST(N'2020-01-08T00:00:00.000' AS DateTime), N'SO71885', 29612, 550.3860),
(71895, CAST(N'2020-02-11T00:00:00.000' AS DateTime), N'SO71895', 29584, 246.7392),
(71897, CAST(N'2020-02-25T00:00:00.000' AS DateTime), N'SO71897', 29877, 12685.8899),
(71898, CAST(N'2020-05-25T00:00:00.000' AS DateTime), N'SO71898', 29932, 63980.9884),
(71899, CAST(N'2021-05-25T00:00:00.000' AS DateTime), N'SO71899', 29568, 2415.6727),
(71902, CAST(N'2021-06-30T00:00:00.000' AS DateTime), N'SO71902', 29929, 74058.8078),
(71915, CAST(N'2021-06-30T00:00:00.000' AS DateTime), N'SO71915', 29638, 2137.2310),
(71917, CAST(N'2020-06-30T00:00:00.000' AS DateTime), N'SO71917', 30025, 40.9045),
(71920, CAST(N'2020-05-31T00:00:00.000' AS DateTime), N'SO71920', 29982, 2980.7929),
(71923, CAST(N'2021-02-01T00:00:00.000' AS DateTime), N'SO71923', 29781, 106.5408),
(71935, CAST(N'2021-02-11T00:00:00.000' AS DateTime), N'SO71935', 29531, 6634.2961),
(71936, CAST(N'2021-02-02T00:00:00.000' AS DateTime), N'SO71936', 30050, 98278.6910),
(71938, CAST(N'2021-03-11T00:00:00.000' AS DateTime), N'SO71938', 29546, 88812.8625),
(71946, CAST(N'2021-05-15T00:00:00.000' AS DateTime), N'SO71946', 29741, 38.9536);

select YEAR(OrderDate) as Yr , DATEPART(Quarter,OrderDate) as Q_Num, SUM(SubTotal) as Total_value
from Sales10 
Group by Rollup ( YEAR(OrderDate)  , DATEPART(Quarter,OrderDate))

select YEAR(OrderDate) as Yr , MONTH(OrderDate) as Month_Num , DATEPART(Quarter,OrderDate) as Q_Num, SUM(SubTotal) as Total_value
from Sales10 
Group by YEAR(OrderDate)  , MONTH(OrderDate)  , DATEPART(Quarter,OrderDate) 
Union ALL 
select Distinct YEAR(OrderDate) as Yr , MONTH(OrderDate) as Month_Num , DATEPART(Quarter,OrderDate) as Q_Num, SUM(SubTotal) as Total_value
from Sales10 
Group by 
GROUPING sets(YEAR(OrderDate)  , 
YEAR(OrderDate)  , MONTH(OrderDate)  ,
YEAR(OrderDate)  , DATEPART(Quarter,OrderDate),
MONTH(OrderDate)  , DATEPART(Quarter,OrderDate)
);

--Question 73 How to compare date from different time zones? Time Zone conversion | AT TIME ZONE
select GETDATE();
select GETUTCDATE();
select SYSDATETIMEOFFSET();

Declare @dt Datetime ='2024-03-05 12:52:38';

Select GETUTCDATE();
Select GETDATE() AT TIME ZONE 'INDIA STANDARD TIME';
select GETDATE() AT TIME ZONE 'EASTERN STANDARD TIME';

select Case when
@dt AT TIME ZONE 'INDIA STANDARD TIME' >GETDATE() AT TIME ZONE 'EASTERN STANDARD TIME' 
then 1 
else 0 
end as DateTIMEDIff;

--Question 74 
select Cast(CurrencyRateDate as Date)as Date,EndOfDayRate , 
AVG(EndOfDayRate)Over(order by Cast(CurrencyRateDate as Date ) Rows Between 6 Preceding and current row )
from AdventureWorks2022.Sales.CurrencyRate
Where ToCurrencyCode='MXN';

-- Question 75 How many times does a number occur consecutively | Leetcode | Consecutive Nums
Create table Logs 
	( id integer identity,
	  num varchar(50));
INSERT INTO Logs VALUES ('1');
INSERT INTO Logs VALUES ('1');
INSERT INTO Logs VALUES ('1');
INSERT INTO Logs VALUES ('2');
INSERT INTO Logs VALUES ('1');
INSERT INTO Logs VALUES ('2');
INSERT INTO Logs VALUES ('2');
INSERT INTO Logs VALUES ('2');
INSERT INTO Logs VALUES ('2');
INSERT INTO Logs VALUES ('2');

select * from logs ;

WITH CTE AS (
select *  , 
Lead(num)over(Order by id) as lead_num , 
LAG(num)Over(Order by id) as lag_num
from Logs)
select * from 
CTE 
where num =lead_num and num=lag_num;

-- Method  2 
WITH CTE_2 as (
Select * ,
ROW_NUMBER() Over(Order by id ) -ROW_NUMBER()over(Partition by num order by id) as GRP
from logs) 
select num  , Count(*)
from CTE_2
Group by num ,GRP;

