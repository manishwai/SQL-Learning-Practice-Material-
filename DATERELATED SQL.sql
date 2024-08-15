

-- Question [Ankit Bansal]Business Days Excluding Weekends and Public Holidays
create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from tickets;
select * from holidays;
select *  , 
(DateDiff(dd,create_date,resolved_date)-(DATEDIFF(WEEK,create_date,resolved_date)*2))-t.Holiday_no
from (
select t.ticket_id , t.create_date,t.resolved_date , count(holiday_date) as Holiday_no
from tickets t
left join holidays h
on h.holiday_date between t.create_date and t.resolved_date 
group by t.ticket_id , t.create_date,t.resolved_date ) as t  ;

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
	Insert into sales1 values('2024-02-07','2024-02-12')
select * from sales1;

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
INSERT INTO People (FirstName, LastName, BirthDate) VALUES('Manish','Walia','1995-08-25')
select * from people;

select DateADD(YY,DATEDIFF(yy,BirthDate,Getdate()),BirthDate)from people;

select FirstName ,LastName ,BirthDate,
case when DATEADD(year ,Datediff(YY,BirthDate, getdate()),BirthDate) >GETDATE()
then Datediff(YY,BirthDate , getdate())-1
else Datediff(YY,BirthDate, getdate())
end as AGE
from people;



-- Question 4 Write a sql query to provide a date for nth occurence of sunday in future for a given date 
declare @dt date =getdate();
declare @n int  = 3 ;

select Datepart(WEEKDAY,@dt) ,Dateadd(dd, 8-Datepart(WEEKDAY,@dt),@dt) as next_week_sunday_date , 
Dateadd(dd, (7*(@n-1)),Dateadd(dd, 8-Datepart(WEEKDAY,@dt),@dt)) as desired_nth_week_sunday_date,
Dateadd(dd, -(datepart(weekday,@dt)-1),@dt) as current_week_sunday_date

-- or another approach is  dateadd(dd,7-datepart(weekday,@dt)+1 , @dt) 
-- so what i am doing here is  i am subtracting from 7 and yhen adding one since we want to find sunday and sunday value is 1 
-- we have seen same thing when we were finidng  the first tuedday of current month there we added 3 and then % by 7 to avoid adding high numberrs 
select Datepart(WEEKDAY,@dt) ,Dateadd(dd, 8-Datepart(WEEKDAY,@dt),@dt) as next_week_sunday_date 
-- here we have directly use 8 since we are finidng for sunday but we cant learn or remember this everytime 

select Datepart(WEEKDAY,@dt) ,Dateadd(dd, ((7-Datepart(WEEKDAY,@dt)+1)%7),@dt) as next_week_sunday_date_2


--dw and weekday both are same 
select Datepart(dw,getDate())
select Datepart(Weekday,getdate())

--Question 94 How to find number of Sundays between two dates
declare  @StartDate DateTime = '2023-03-05',
 @EndDate DateTime = '2023-03-26';

WITH CTE_date AS (
SELECT @StartDate as dt
UNION ALL
SELECT DATEADD(day,1,dt) as dt FROM CTE_date 
WHERE dt<=@EndDate
)
Select count(*)
from CTE_date
Where DATENAME(WeekDay,dt) ='sunday';

--Question 95  How to find Start and End Day of the Week
Declare @dt date='2024-04-27'
select Datepart(weekday, @dt) , DATENAME(weekday,@dt)
Select Dateadd(day,7-DATEPART(Weekday , @dt),@dt) as END_WEEK_DATE ,
DATEADD(Day,1-Datepart(WeekDay,@dt),@dt) as Start_Week_Date
,DATENAME(WeekDay,@dt)

-- or 
Declare @dt date='2024-04-25'
select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',@dt),'1990-01-01') as weekstartingdate

select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',@dt)+1,'1990-01-01')-1 weekendingdate


--40 Question How to find First and Last day of week | Date functions
select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',GETDATE()),'1990-01-01') as weekstartingdate
select DateAdd(Wk,
DATEDIFF(wk,'1990-01-01',GETDATE())+1,'1990-01-01')-1  weekendingdate

--

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

select @StartDate , @EndDate

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


-- first friday of an year 
select Datepart(WEEKDAY,'01-01-2024') ,Dateadd(dd, ((7-Datepart(WEEKDAY,'01-01-2024')+2)%7),'01-01-2024') first_mon_of_mentioned_date

select Datepart(WEEKDAY,'01-01-2024') ,Dateadd(dd, ((7-Datepart(WEEKDAY,'01-01-2024')+6)%7),'01-01-2024') first_Friday_of _mentioned_date



