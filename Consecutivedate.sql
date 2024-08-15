-- Queries Related to consecutive day 

--How to find n consecutive date records | Sales for at least n consecutive days.
with CTE AS (
select 
*  , DateAdd(dd,- ROW_NUMBER()Over(order by SalesDate) ,SalesDate) as D1
from Sales5) , 
CTE_2 as (
select *,
count(1)over(partition by D1 order by D1 range between unbounded preceding and unbounded following ) CNT
from CTE )
select SalesDate 
from CTE_2
where cnt=3;

--No sales for n consecutive days | Identify date gaps
select * from (
Select *,
LEAD(SalesDate)Over(Order by SalesDate) as LeadDate, 
DateDiff(d,SalesDate, LEAD(SalesDate)Over(Order by SalesDate))-1as Gap
From 
Sales5) Sale_5
where sale_5.Gap>1

--How to find 'n' consecutive days EXCLUDING Weekends | LAG | Windows function | streaks
CREATE TABLE [dbo].[Attendance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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

SET IDENTITY_INSERT [dbo].[Attendance] ON;
WITH CTE AS (
select * , DateAdd(DD,-RN, LoginDt) as GRP  from(
select *  , 
Row_Number()over(partition by Employeeid order by LoginDt) RN
from Attendance) t) 
Select * , count(GRP)Over(Partition by Employeeid , GRP order by LoginDt  ROWS Between Unbounded preceding and unbounded following) as NTIMES
from CTE ;
-- or other way to handle it including weekend approach 
With Consecutive_cte as (
select Employeeid , LoginDt  , DATEADD(dd,-1 ,LoginDt) as Prev  , 
Lag(LoginDt)Over(Partition by Employeeid order by LoginDt) as Lag_date,
case when DATEADD(dd,-1 ,LoginDt) = Lag(LoginDt)Over(Partition by Employeeid order by LoginDt)
or 
DATENAME(WEEKDAY,LoginDt)='Monday' and DATEADD(dd,-3 ,LoginDt) = Lag(LoginDt)Over(Partition by Employeeid order by LoginDt)
then 0 else 1 end as consecutive
from 
dbo.Attendance) ,
Batch_Streak as (
Select Employeeid , LoginDt,Prev,Lag_date,consecutive
,sum(consecutive)over(partition by Employeeid order by LoginDt) as Grp
from Consecutive_cte
) ,
GRP_CNT As (
select * ,
count(*)over(Partition by Employeeid , Grp order by LoginDt Range between unbounded preceding and unbounded following )as cnt
from Batch_Streak) 
select  Employeeid , LoginDt
from GRP_CNT
where cnt>3;

-- Ankit Bansal 60 


-- Learn at knowstar 




-Question 79 SQL Query | How to find 'n' consecutive days EXCLUDING Weekends | LAG | Windows function | streaks
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


-

From the login_details table, fetch the users who logged in consecutively 3 or more times
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

INSERT INTO login_details (login_id, user_name, login_date)
VALUES
(101, 'Michael', GETDATE()),
(102, 'James', GETDATE()),
(103, 'Stewart', DATEADD(DAY, 1, GETDATE())),
(104, 'Stewart', DATEADD(DAY, 1, GETDATE())),
(105, 'Stewart', DATEADD(DAY, 1, GETDATE())),
(106, 'Michael', DATEADD(DAY, 2, GETDATE())),
(107, 'Michael', DATEADD(DAY, 2, GETDATE())),
(108, 'Stewart', DATEADD(DAY, 3, GETDATE())),
(109, 'Stewart', DATEADD(DAY, 3, GETDATE())),
(110, 'James', DATEADD(DAY, 4, GETDATE())),
(111, 'James', DATEADD(DAY, 4, GETDATE())),
(112, 'James', DATEADD(DAY, 5, GETDATE())),
(113, 'James', DATEADD(DAY, 6, GETDATE()));

select Distinct Repeated_name from (
select *, 
case when user_name=lead(user_name)over(order by login_id)  and user_name=lead(user_name, 2)over(order by login_id)
then user_name
else null
end as Repeated_name
from login_details) as t
where t.Repeated_name is not null;


--2.G From the weather table, 
--fetch all the records when London had extremely cold temperature for 3 consecutive days or more.
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);

INSERT INTO weather (id, city, temperature, day)
VALUES
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

select * from (
select *  ,
case when temperature <0 
and lead(temperature)over(order by day)<0 
and lead(temperature,2)over(order by day)<0 
then 'Y'
when temperature <0 
and lag(temperature)over(order by day)<0 
and lag(temperature,2)over(order by day)<0 
then 'Y'
when temperature <0 
and lead(temperature)over(order by day)<0 
and lag(temperature)over(order by day)<0 
then 'Y'
else 'N'
end as 'Flag'      
from 
weather) t 
where t.flag='Y';