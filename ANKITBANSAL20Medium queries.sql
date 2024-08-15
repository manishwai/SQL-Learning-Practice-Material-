-- Question 1 write a query to find no of gold medal per swimmer for swimmer who won only gold medals
CREATE TABLE events1(
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);
INSERT INTO events1 VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events1 VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events1 VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events1 VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events1 VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events1 VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events1 VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events1 VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events1 VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events1 VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events1 VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events1 VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

select * from events1;

SELECT GOLD, COUNT(*) AS GoldCount
FROM events1
WHERE GOLD NOT IN (
    SELECT DISTINCT SILVER
    FROM events1
    UNION
    SELECT DISTINCT BRONZE
    FROM events1
)
GROUP BY GOLD;

-- Question 2 Business Days Excluding Weekends and Public Holidays
create table tickets2
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
insert into tickets2 values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
delete from tickets2;
create table holidays2
(
holiday_date date
,reason varchar(100)
);
delete from holidays2;
insert into holidays2 values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select ticket_id , create_date,resolved_date , count(holiday_date) from tickets2 t 
 left join holidays h 
 on h.holiday_date between t.create_date and t.resolved_date
 Group by  ticket_id , create_date,resolved_date ;

select * , DATEDIFF(day,create_date,resolved_date) as no_days , 
DATEPART(WEEK,create_date) Create_week , 
DATEPART(week, resolved_date) as Resolved_week , 
DATEDIFF(day,create_date,resolved_date) -(DATEDIFF(Week,create_date,resolved_date)*2)-no_holidays
as Actual_diff_excluding_weekends
from (
select ticket_id , create_date, resolved_date, count(holiday_date) as no_holidays 
from tickets2  t
left join holidays2 h 
on h.holiday_date between t.create_date and t.resolved_date
Group by ticket_id , create_date, resolved_date)  as temp ;

-- Question 3 
create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');
WIth CTE as (
select emp_id , 
Max(case when action ='in' then time else null end )as MAX_in_time , 
MAX(case when action='out' then time else null end )as MAX_out_time
from 
hospital
group by emp_id
having Max(case when action ='in' then time else null end ) >MAX(case when action='out' then time else null end )
or MAX(case when action='out' then time else null end ) is null
) 

select count(emp_id) 
from 
CTE 
;

select * from hospital;

-- Question 4 
/*Find the room types that are searched most no of times:
Output the room type alongside the number of searchesfor it
If the filter for room types has more than one room ttype
consider each unique room type as a separate row.
Sort the result based on the number of searches in desocending order
*/

create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')

select * from airbnb_searches;

select value as v, count(1) as cnt 
from (
select * from 
airbnb_searches
cross apply string_split(filter_room_types , ',')
) t 
group by value;


-- Question 5 write a SQL to return all employee whose salary iss same in same department

CREATE TABLE [emp_salary]
(
    [emp_id] INTEGER  NOT NULL,
    [name] NVARCHAR(20)  NOT NULL,
    [salary] NVARCHAR(30),
    [dept_id] INTEGER
);

INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

select * 
from 
emp_salary as e1 
join emp_salary as e2 
on e1.dept_id=e2.dept_id and e1.salary=e2.salary and e1.emp_id<>e2.emp_id;

with CTE as (
select dept_id,salary
from emp_salary
group by dept_id , salary
having count(1)=1
) 
select *
from emp_salary as e 
left join CTE as c 
on e.dept_id=c.dept_id and e.salary=c.salary
where c.dept_id is null

-- Question 6 & -- Question7 data lemur questions 
-- Question 8 
/*There are 2 tables,first table has 5 records and seecond table has 10 records.
you can assume any values in each of the tables. how maany maximum and minimum records possible in case of
inner join, left join, right join and full outer join */

Inner Join : MAX :50   ,MIN:0
left Join :MAX :50   ,MIN:5
Right Join :MAX :50   ,MIN:10
FULL_Outer Join :MAX :50   ,MIN:15


-- Question 9 
-- Question 10 
--Question 11 Print Highest and Lowest Salary Employees in Each Department
create table employee345
(
emp_name varchar(10),
dep_id int,
salary int
);
insert into employee345 values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

select * from employee345;
select * ,case when  Rank()over(partition by dep_id order by salary desc)=1 then 'Top' 
when Rank()over(partition by dep_id order by salary)=1 then 'Low' end as salary_category
from employee345
order by dep_id , salary desc;

-- QUestion12 
/*write a query to get start time and end timeof each call from below 2 tables.Also create a column of call
duration in minutes. Please do take into account that theere will be multiple calls from one phone number
and each entry in start table has a correspondingg entry in end table.*/

create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00');

select * from call_start_logs;
select * from call_end_logs;

select s.phone_number ,s.start_time,e.end_time,DATEDIFF(MINUTE,s.start_time,e.end_time) as Durartion_seconds
from(
select *  , ROW_NUMBER()over(partition by phone_number order by start_time)as RN
from call_start_logs) s
join (
select * , ROW_NUMBER()over(partition by phone_number order by end_time )as RN
from call_end_logs ) e 
on s.RN=e.RN and s.phone_number=e.phone_number;

-- Question 13 
create table input (
id int,
formula varchar(10),
value int
)
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);
with CTE AS (
select id ,formula , left(formula,1)  as d1 , RIGHT(formula,1) as d2  , SUBSTRING(formula,2,1) as d3  , value
from input) 

select c.id,c.formula , c.value , i.value as d1 ,i2.value as d2, 
case when c.d3='+' then i.value+i2.value else i.value-i2. value end as new_value
from CTE as c 
join input as i 
on c.d1=i.id 
join input i2 
on c.d2=i2.id;


-- Question 14

create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);
insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');

select * from Ameriprise_LLC;

with Qualified_team as(
select teamID  
from 
Ameriprise_LLC
where Criteria1='Y' and Criteria2='Y'
group by teamID
having count(1)>=2) 

select * ,case when a.Criteria1 ='Y' and a.Criteria2='Y' and  q.teamID is not null then 'Y' else 'N' end as Output 
from Ameriprise_LLC as  a
Left join Qualified_team as  q 
on a.teamID=q.teamID ;

-- Question 15
create table family 
(
person varchar(5),
type varchar(10),
age int
);

insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),
('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);

select * from family;

with CTE_adult as (
select 
* , ROW_NUMBER()over(order by age  desc ) as RN
from family
where type='Adult') , 
CTE_child as (
select 
* , ROW_NUMBER()over(order by age ) as RN
from family
where type='child')

select * 
from CTE_adult A 
left join CTE_child C 
on A.RN=C.RN;

-- Question 16 
create table company_revenue 
(
company varchar(100),
year int,
revenue int
);
insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

SELECT * from company_revenue;

select company 
from(
select 
* ,
case when coalesce(Lag(revenue,1)over(partition by company order by year )-revenue , 0)<=0 then 1 else 0 end as flag 
from company_revenue)  t 
Group by company 
having sum(flag)=count(distinct year);

-- Question 17 

-- Question 18 
create table icc_world_cup2
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup2 VALUES (1, 'ENG', 'NZ', 'NZ');
INSERT INTO icc_world_cup2 VALUES (2, 'PAK', 'NED', 'PAK');
INSERT INTO icc_world_cup2 VALUES (3, 'AFG', 'BAN', 'BAN');
INSERT INTO icc_world_cup2 VALUES (4, 'SA', 'SL', 'SA');
INSERT INTO icc_world_cup2 VALUES (5, 'AUS', 'IND', 'IND');
INSERT INTO icc_world_cup2 VALUES (6, 'NZ', 'NED', 'NZ');
INSERT INTO icc_world_cup2 VALUES (7, 'ENG', 'BAN', 'ENG');
INSERT INTO icc_world_cup2 VALUES (8, 'SL', 'PAK', 'PAK');
INSERT INTO icc_world_cup2 VALUES (9, 'AFG', 'IND', 'IND');
INSERT INTO icc_world_cup2 VALUES (10, 'SA', 'AUS', 'SA');
INSERT INTO icc_world_cup2 VALUES (11, 'BAN', 'NZ', 'NZ');
INSERT INTO icc_world_cup2 VALUES (12, 'PAK', 'IND', 'IND');
INSERT INTO icc_world_cup2 VALUES (13, 'SA', 'IND', 'DRAW');

select *  from icc_world_cup2;


with all_matches_played as (
select team1 ,sum(CNT) as total_matches 
from (
select  team_1 as team1 ,  count(1) as CNT
from 
icc_world_cup2
group by team_1
union all 
select Distinct  team_2 as team1 , count(1) as CNT
from 
icc_world_cup2
group by team_2
)as t
group by team1) 
 , winner_cte  as (
select winner , count(1) as Win_count
from icc_world_cup2
group by winner)

select team1, total_matches, coalesce(Win_count,0) ,total_matches-coalesce(Win_count,0) as  loss_count
from all_matches_played as A 
left Join winner_cte as W 
on A.team1=W.winner

-- Question 18 
CREATE TABLE flights 
(
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    Destination VARCHAR(512)
);

INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f1', 'Del', 'Hyd');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f2', 'Hyd', 'Blr');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f3', 'Mum', 'Agra');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f4', 'Agra', 'Kol');

select * from flights;
select f1.cid,f1.fid,f1.origin,f2.Destination
from flights f1 
join flights f2 
on f1.Destination=f2.origin

--19.2
-- Create the table sales_3456
CREATE TABLE sales_3456 (
    order_date date,
    customer VARCHAR(512),
    qty INT
);

-- Insert data into sales_3456
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-01-01', 'C1', 20);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-01-01', 'C2', 30);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-02-01', 'C1', 10);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-02-01', 'C3', 15);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-03-01', 'C5', 19);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-03-01', 'C4', 10);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-04-01', 'C3', 13);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-04-01', 'C5', 15);
INSERT INTO sales_3456 (order_date, customer, qty) VALUES ('2021-04-01', 'C6', 10);

select * from sales_3456;

select MONTH(order_date) , count(distinct Customer) 
from (
select * , 
ROW_NUMBER()over(partition by customer order by order_date) as RN
from sales_3456) t
where RN=1  
group by month(order_date);

-- Question 20 
create table source1(id int, name varchar(5))
create table target1(id int, name varchar(5))
insert into source1 values(1,'A'),(2,'B'),(3,'C'),(4,'D')
insert into target1 values(1,'A'),(2,'B'),(4,'X'),(5,'F');

select * from source1;
select * from target1;

select source1.id ,'New in source' as comment 
from source1
left join target1 on source1.id=target1.id
where target1.name is null
union all 
select target1.id ,'New in target' as comment 
from target1
left join source1 on source1.id=target1.id
where source1.name is null
union all 
select source1.id ,'Mismatch' as comment 
from source1
join target1 on source1.id=target1.id and source1.name<>target1.name ; 

-- Question 21 
create table namaste_python (
file_name varchar(25),
content varchar(200)
);


insert into namaste_python values ('python bootcamp1.txt','python for 
data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. 
You can register from namaste sql website. Link in pinned comment')

select * from namaste_python;

select value , count(1) 
from (
select * from namaste_python
cross apply string_split(content,' ')) t 
group by value
having count(1)>1;


-- Question 22
CREATE TABLE movies (
    id INT PRIMARY KEY,
    genre VARCHAR(50),
    title VARCHAR(100)
);

-- Create reviews table
CREATE TABLE reviews (
    movie_id INT,
    rating DECIMAL(3,1),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Insert sample data into movies table
INSERT INTO movies (id, genre, title) VALUES
(1, 'Action', 'The Dark Knight'),
(2, 'Action', 'Avengers: Infinity War'),
(3, 'Action', 'Gladiator'),
(4, 'Action', 'Die Hard'),
(5, 'Action', 'Mad Max: Fury Road'),
(6, 'Drama', 'The Shawshank Redemption'),
(7, 'Drama', 'Forrest Gump'),
(8, 'Drama', 'The Godfather'),
(9, 'Drama', 'Schindler''s List'),
(10, 'Drama', 'Fight Club'),
(11, 'Comedy', 'The Hangover'),
(12, 'Comedy', 'Superbad'),
(13, 'Comedy', 'Dumb and Dumber'),
(14, 'Comedy', 'Bridesmaids'),
(15, 'Comedy', 'Anchorman: The Legend of Ron Burgundy');

-- Insert sample data into reviews table
INSERT INTO reviews (movie_id, rating) VALUES
(1, 4.5),
(1, 4.0),
(1, 5.0),
(2, 4.2),
(2, 4.8),
(2, 3.9),
(3, 4.6),
(3, 3.8),
(3, 4.3),
(4, 4.1),
(4, 3.7),
(4, 4.4),
(5, 3.9),
(5, 4.5),
(5, 4.2),
(6, 4.8),
(6, 4.7),
(6, 4.9),
(7, 4.6),
(7, 4.9),
(7, 4.3),
(8, 4.9),
(8, 5.0),
(8, 4.8),
(9, 4.7),
(9, 4.9),
(9, 4.5),
(10, 4.6),
(10, 4.3),
(10, 4.7),
(11, 3.9),
(11, 4.0),
(11, 3.5),
(12, 3.7),
(12, 3.8),
(12, 4.2),
(13, 3.2),
(13, 3.5),
(13, 3.8),
(14, 3.8),
(14, 4.0),
(14, 4.2),
(15, 3.9),
(15, 4.0),
(15, 4.1);

select * from movies; 
select * from reviews;

select genre , title , REPLICATE('*',round(AVG_RATING,0) )as RATING
from(
select id , genre , title ,avg(rating) as AVG_RATING , 
ROW_NUMBER()over(partition by genre order by avg(rating) DESC) as RNK 
from movies m 
join reviews r on m.id=r.movie_id
group by  id , genre , title) t 
where RNK=1

-- Question 23
/*A travel and tour company has 2 tables that relate to customers: FAMILIES and COUNTRIES. Each
tour offers a discount if a minimumber of people bodok at the same time.
Write a query to print the maximum number of discounted tours any 1 family in the FAMILIES
table can choose from.
*/
CREATE TABLE FAMILIES (
    ID VARCHAR(50),
    NAME VARCHAR(50),
    FAMILY_SIZE INT
);

-- Insert data into FAMILIES table
INSERT INTO FAMILIES (ID, NAME, FAMILY_SIZE)
VALUES 
    ('c00dac11bde74750b4d207b9c182a85f', 'Alex Thomas', 9),
    ('eb6f2d3426694667ae3e79d6274114a4', 'Chris Gray', 2),
  ('3f7b5b8e835d4e1c8b3e12e964a741f3', 'Emily Johnson', 4),
    ('9a345b079d9f4d3cafb2d4c11d20f8ce', 'Michael Brown', 6),
    ('e0a5f57516024de2a231d09de2cbe9d1', 'Jessica Wilson', 3);

-- Create COUNTRIES table
CREATE TABLE COUNTRIES2(
    ID VARCHAR(50),
    NAME VARCHAR(50),
    MIN_SIZE INT,
 MAX_SIZE INT
);

INSERT INTO COUNTRIES2(ID, NAME, MIN_SIZE,MAX_SIZE)
VALUES 
    ('023fd23615bd4ff4b2ae0a13ed7efec9', 'Bolivia', 2 , 4),
    ('be247f73de0f4b2d810367cb26941fb9', 'Cook Islands', 4,8),
    ('3e85ab80a6f84ef3b9068b21dbcc54b3', 'Brazil', 4,7),
    ('e571e164152c4f7c8413e2734f67b146', 'Australia', 5,9),
    ('f35a7bb7d44342f7a8a42a53115294a8', 'Canada', 3,5),
    ('a1b5a4b5fc5f46f891d9040566a78f27', 'Japan', 10,12);
 
 select * from FAMILIES;
 Select * from COUNTRIES2;

 WITH CTE AS (
 select F.NAME as F_NAME , F.FAMILY_SIZE as FAMILYSIZE , C.NAME as COUNTRY_NAME , C.MIN_SIZE as MINSIZE 
 FROM 
 FAMILIES F
 Cross JOIN COUNTRIES2 C 
 where F.FAMILY_SIZE>=C.MIN_SIZE) 
 select F_NAME , COUNT(1)
 from CTE 
 Group BY F_NAME;

 select count(*) from COUNTRIES2 where MIN_SIZE<= (select max(FAMILY_SIZE) from FAMILIES);

 
 WITH CTE AS (
 select F.NAME as F_NAME , F.FAMILY_SIZE as FAMILYSIZE , C.NAME as COUNTRY_NAME , C.MIN_SIZE as MINSIZE 
 FROM 
 FAMILIES F
 Cross JOIN COUNTRIES2 C 
 where F.FAMILY_SIZE between c.MIN_SIZE and c.MAX_SIZE ) 
 select TOP 1  F_NAME , COUNT(1)
 from CTE 
 Group BY F_NAME
 order by count(1) desc;



 