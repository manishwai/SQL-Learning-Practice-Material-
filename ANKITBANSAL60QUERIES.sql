-- Ankit Bansal 
-- Question 1 Derive Points table for ICC tournament
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;
select * from icc_world_cup2;

select Team , count(Win_flag) as No_Of_matches , sum(Win_flag) as No_win_Matches  , 
 count(Win_flag)- sum(Win_flag) as Loss_count
from(
select Team_1 as Team, case when Team_1=Winner then 1  else 0 end as 'Win_flag'
from icc_world_cup
union  all 
select Team_2 as Team, case when Team_2=Winner then 1  else 0 end as 'Win_flag'
from icc_world_cup) as t
Group by Team;

-- Question 2 find new and repeat customers | 
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
insert into customer_orders values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100),
(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700),
(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000);

select * from customer_orders;

select order_date , customertype , count(*) from 
(
select * , 
Case when order_date=MIN(order_date)over(Partition by customer_id order by order_date) then 'NewCustomer' Else 
'RepeatedCustomer' end as customertype 
from customer_orders)as t
group by order_date , customertype;

-- Question 3 From the entries table dervied output stating person total visit , most visited fllor and resources used(string_agg
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')

select * from entries;

with 
most_visited as (
select name , floor , count(*) as cnt , 
Rank()Over(partition by name order by count(*)desc) as rnk
from entries
group by name , floor) ,
total_visits as 
(select name , count(*) as Total_vis from entries group by name), 
distinct_resources as(select  distinct name , resources from entries ),
agg_resources as (select name , string_agg(resources,',') as res_used from distinct_resources group by name )
select m.name , m.floor  , t.Total_vis , a.res_used
from most_visited m
join total_visits t on m.name=t.name
join agg_resources a on m.name=a.name 
where m.rnk =1

-- Question 4 Write a sql query to provide a date for nth occurence of sunday in future for a given date 
declare @dt date =getdate();
declare @n int  = 3 ;

select Datepart(WEEKDAY,@dt) ,Dateadd(dd, 8-Datepart(WEEKDAY,@dt),@dt) as next_week_sunday_date , 
Dateadd(dd, (7*(@n-1)),Dateadd(dd, 8-Datepart(WEEKDAY,@dt),@dt)) as desired_nth_week_sunday_date,
Dateadd(dd, -(datepart(weekday,@dt)-1),@dt) as current_week_sunday_date

-- Question 6 
/*write a query to find PersonID, Name, number of friends, sum of marks of  
person who have friends with total score greater than 100.
*/

CREATE TABLE friend_details (
    PersonID INT,
    FriendID INT
);

INSERT INTO friend_details (PersonID, FriendID)
VALUES 
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 3),
    (3, 5),
    (4, 2),
    (4, 3),
    (4, 5);
CREATE TABLE person (
    PersonID INT,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Score INT
);

INSERT INTO person (PersonID, Name, Email, Score)
VALUES 
    (1, 'Alice', 'alice2018@hotmail.com', 88),
    (2, 'Bob', 'bob2018@hotmail.com', 11),
    (3, 'Davis', 'davis2018@hotmail.com', 27),
    (4, 'Tara', 'tara2018@hotmail.com', 45),
    (5, 'John', 'john2018@hotmail.com', 63);

	select * from person;
	select * from friend_details;

with CTE AS (
select f.PersonID as person_id , sum(p.Score) as Friend_score ,count(f.FriendID) as no_of_frnds
from friend_details f
join person p 
on f.FriendID=p.PersonID
group by f.PersonID
having SUM(p.score)>100)
select p.name as person_name , c.*
from CTE c
join person p
on c.person_id=p.PersonID;

-- Question 7 Write a SQL query to find the cancellation rate of requests with unbanned users
/*(both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03".
Round Cancellation Rate to two decimal points.
The cancellation rate is computed by dividing the number of canceled (by client or driver)
requests with unbanned users by the total number of requests with unbanned users on that daay.
*/
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

select * from trips;
select * from Users;



WITH Completed_CTE AS (
select t.request_at as Trip_date  , count(t.status) as Trip_count
from trips t 
join users u 
on t.client_id=u.users_id 
where u.banned <> 'Yes'
and  driver_id not in ( select  distinct users_id from users 
										join trips  on users.users_id=trips.driver_id
										where Users.banned ='Yes')
Group by  t.request_at ) ,  
cancelled_cte as (
 select t.request_at as Trip_date  , count(t.status) as Trip_count
from trips t 
join users u 
on t.client_id=u.users_id 
where u.banned <> 'Yes'
and  driver_id not in ( select  distinct users_id from users 
										join trips  on users.users_id=trips.driver_id
										where Users.banned ='Yes')
and t.status like '%cancelled%'
Group by  t.request_at)

select c1.Trip_date ,   c1.Trip_count ,  c2.Trip_count
from Completed_CTE as c1
left join cancelled_cte as c2
on c1.Trip_date=c2.Trip_date;


--Question 8  Write an SQL query to find the winner in eachgroup
-- The winner in each group is the player who scored the maximum total points within the group. In thecase of a tie,
-- the lowest player_id wins.

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);		

select * from players;
select * from matches;

with CTE_1 AS (
select  first_player as player_id  , first_score as score  from matches
union 
select  second_player as player_id  , second_score as score  from matches) 
, CTE_2 as (
select  p.group_id as P_Group , c.player_id PlayerID , sum(c.score)as total 
from CTE_1 c
join players p 
on c.player_id=p.player_id
group by p.group_id , c.player_id) 
select * , 
Rank()Over(Partition by P_Group Order by total desc ,PlayerID )
from CTE_2;

-- Question 9
/* MARKET ANALYSIS : Write an SQL query to find for eadch seller, whether the brand of the second item (by date)they sold is their favor
If a seller sold less than two items, report the answer for that seller as no. o/p
seller id 2nd_item_fav_brand
2)yes/no
2)yes/no
*/

create table users_2 (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50))
  create table orders_2 (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );
  create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );
  insert into users_2 values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders_2 values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

 select * from users_2;
 select * from orders_2;
 select * from items;

 with CTE as (
 Select  *
 ,Rank()over (partition by seller_id order by order_date) RN
from orders_2)
select u.user_id ,c.order_id , c.order_date , c.item_id , c.buyer_id , c.seller_id ,  i.item_brand  , u.favorite_brand,
case when  i.item_brand = u.favorite_brand then 'Yes' else 'No' end as Fav_brand 
from users_2 u 
LEFT JOIN CTE c on c.seller_id=u.user_id and rn=2
LEFT join items i on c.item_id =i.item_id
--where RN=2 

--QUestion 10 
create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

select * from tasks;

with CTE as (
select date_value , state ,DAteadd(dd, -ROW_NUMBER()over(partition by state order by date_value) , date_value)  as RN
from tasks)
select state ,min(date_value), MAx(date_value) 
from CTE
Group by RN , State;


-- Question 11 
/* User purchase platform.
-- The table logs the spendings history of users thatmake purchases from an online shopping website which has a desktop
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only,desktop only
and both mobile and desktop together for each datte
*/I

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);
insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

select * from spending;



with CTE  as(
select spend_date  , max(platform)as platform  , USER_ID , sum(amount) as amount 
from spending
group by spend_date ,user_id
having count(distinct platform )=1
union all 
select spend_date , 'Both' as platform  ,USER_ID , sum(amount) as amount
from spending
group by spend_date ,user_id
having count(distinct platform )>1
union all 
select distinct  spend_date  ,'Both' as platform  , null as USER_ID , 0  as amount
from spending
)

select  spend_date , platform , sum(amount) , count(distinct user_id)
from CTE 
Group  by  spend_date , platform;


with cte as(
 select case when STRING_AGG(platform,',')='mobile,desktop' then 'both' else STRING_AGG(platform,',') end
 as pf,spend_date,user_id,sum(amount) Total,count(distinct user_id ) cnt
 from spending group by spend_date,user_id 
 ),
 cte2 as (
 select * from cte 
 union all
 select distinct 'both' as pf,spend_date,null as user_id, 0 as total,0 as cnt
 from spending )

 select pf,spend_date, sum(total)totalamount,count(distinct user_id)totalusers from cte2 
 group by spend_date,pf 
 order by 1 desc

 -- Question 12 we have table with period start date and period end date and avg daily sales in that period 
 -- we have to first expand that table from period start date to period end date and then show the total sales year wise 
 
create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);
select * from sales;

WITH CTE AS (
select MIN(period_start)as Dt  , Max(period_end)  as max_date
from sales
union all 
select Dateadd(dd , 1 , Dt)  , max_date
from CTE 
where Dt<max_date)



select product_id ,year(Dt) , sum(average_daily_sales) 
from CTE
join sales on  dt between period_start and period_end
Group by product_id , YEAR(Dt)
order by product_id
option(maxrecursion 1000)
;

-- Question 13 
-- Recommendation system based on product pair most commonly purchased together 
create table orders_3
(
order_id int,
customer_id int,
product_id int,
);
insert into orders_3 VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products_1 (
id int,
name varchar(10)
);
insert into products_1 VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');
select * from orders_3;
select * from products_1;

select  p1.name , p2.name, count(1)as Total_cnt
from orders_3 o1
join orders_3 o2 on o1.order_id =o2.order_id
inner join products_1 p1 on p1.id=o1.product_id
inner join products_1 p2 on p2.id=o2.product_id
where o1.product_id<o2.product_id
Group by p1.name , p2.name

select * from orders_3

with cte1 as(
select *,row_number() over(order by order_id,customer_id,product_id) as rn from orders_3
join products_1 on product_id=id
),
cte2 as (
select name,lead(name) over(order by rn) as leaded from cte1
)
select CONCAT(name , leaded) , count(*)
from cte2 
group by concat(name , leaded)

-- Question 14 
/*Prime subscription rate by product action
Given the following two tables, return the fractionof users, rounded to two decimal places,
who accessed Amzon music and upgrajed to prime mebership within the first days of signing up.*/

create table users_4
(
user_id integer,
name varchar(20),
join_date date
);
insert into users_4
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);
insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

select * from users_4;
select * from events;



select  
1.0*(count( distinct case when DATEDIFF(dd,u.join_date,e.access_date)<30 then u.user_id  end) )/ count(distinct u.user_id) *100 
from users_4  u 
Left join events e on u.user_id=e.user_id and e.type='p'
where u.user_id in (
									select events.user_id from events
									where type='Music');

-- Question 15 
/*Customer retention refers to a company'ss ability to turn customers into repeat buyers
and prevent them from switching to a competitor.
It indicates whether your product and the quality cof your service please your existing customers
reward programs (cc companies)
wallet cash back (paytm/gpay)
zomato pro/swiggysuper
retention period
*/

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;
select * from transactions;

with CTE as (
select * , 
lag(order_date , 1, order_date)over(partition by cust_id order by order_date) as last_Record
from transactions) 
select * from CTE

select MONTH(order_date)  ,
sum(case when MONTH(order_date)-MONTH(last_Record) =1 then 1 else 0 end) as flag
from CTE
group by MONTH(order_date);

-- Question 16 

with CTE as (
select * , 
lead(order_date , 1, order_date)over(partition by cust_id order by order_date) as last_Record
from transactions) 
select MONTH(order_date)  ,
sum(case when MONTH(last_Record)-MONTH(order_date) =1  then 1 else 0 end) as flag
from CTE
group by MONTH(order_date);

-- Question 17 Second Most Recent Activity 
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');
with CTE As (
select * , 
ROW_NUMBER()over(partition by  username order by startDate) RN, 
count(*)over(partition by username order by startDate range between unbounded preceding and unbounded following ) as CNT
from UserActivity) 
select *  
from CTE 
where RN = (case when CNT=1 then 1 else CNT-1 end );

--Question 18 
create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);

insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4)

select * from HoursWorked;
select * from billings;

with b as 
(select * , 
LEAD(Dateadd(dd,-1,bill_date),1,'9999-12-31' )over(partition by emp_name order by  bill_date)  as Lead_date
from billings ) 
select h.emp_name, sum(bill_hrs*bill_rate)
from b 
LEFT join HoursWorked h
on b.emp_name=h.emp_name and 
h.work_date between bill_date and b.Lead_date
group by h.emp_name

-- Question 19 2 sql queries related to spotify 
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

--19.1 
/*Question 1: find total active users each day
event_date total_active_users
2022-01-01   3
2022-01-02   1
2022-01-03   3
2022-01-04   1
*/

select * from activity;
select event_date , count(distinct user_id)
from activity
group by event_date;

--19.2
/*Question 2: find total active users eagh week
week_number total_active_users*/
select Datepart(week ,event_date) , count(distinct user_id)
from activity
group by Datepart(week ,event_date);

--19.3 date wise total number of users who made the purchare same day they installed the app

select * from activity;
WITH CTE As (
select event_date ,
 case when event_date= LEAD(event_date)over(partition by user_id order  by event_date) then 1 else 0   end  as flag 
from activity) 
select  event_date , sum(flag) 
from CTE 
group by event_date;

select event_date , count( distinct event_name ) 
from activity 
group by event_date
having count(distinct event_name )>1;

--19.4  percentage of paid users in India, USAA and any other country should be tagged as others
--country percentage_users
select * from activity ;

with CTE  as (
select  
case when country  not in ('India' ,'USA') then 'Other' else country end as country_1 , count( distinct user_id)  as cnt
from activity 
where event_name='app-purchase'
group by case when country  not in ('India' ,'USA') then 'Other' else country end ) ,
total_users as (select sum(cnt) as total_user  from CTE) 
select country_1 , (cnt*1.0 /total_user)*100 
from CTE ,total_users

--19.5  Among all the users who installed the app on a given day,how many did in app purchared on the very next day--day wise resul
--event_date cnt_users

select event_date  , sum(flag)  from (
select * , CASE WHEN lag(event_date)over(partition by user_id order by event_date) = DATEADD(dd  ,
 -1,event_date) then 1 else 0 end as flag 
from  activity) as t 
group by event_date		

-- QUestion 20 3 or more consecutive empty seats 
create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

-- Method 1
select * from bms;

select seat_no from (
select * , 
lag(is_empty,1)over(order by seat_no) as prev_1 , 
lag(is_empty,2)over(order by seat_no) as prev_2 ,
lead(is_empty,1)over(order by seat_no) as Next_1 , 
lead(is_empty,2)over(order by seat_no) as Next_2 
from bms) a 
where is_empty='Y'  and prev_1='Y' and Next_1='Y'
or 
(is_empty='Y'  and prev_1='Y' and Prev_2='Y')
or 
(is_empty='Y'  and Next_2='Y' and Next_1='Y');

-- Method 2 
select seat_no from (
select *, 
sum(case when is_empty='Y' then 1 else 0 end )over(order by seat_no  rows between 2 preceding and current row ) as prev_1 , 
sum(case when is_empty='Y' then 1 else 0 end )over(order by seat_no  rows between 1 preceding and 1 following  ) as prev_2 , 
sum(case when is_empty='Y' then 1 else 0 end )over(order by seat_no  rows between current row and 2 following) as prev_3 
from bms) a 
where prev_1=3 or prev_2=3 or prev_3=3

--Method 3 
WITH CTE AS (
select seat_no , is_empty ,  seat_no-rn as GRP  from (
select *  , ROW_NUMBER()Over( order by seat_no) as rn
from bms 
where is_empty='Y') a)  
select GRP , count(*)
from CTE 
group by GRP 
having count(*)>3

-- Question 21 
CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

select * from STORES;
-- Method 1 
select store ,'Q'+cast(10- sum(cast(RIGHT(Quarter, 1)as int ))as char)
from STORES
Group by Store;
--Method 2 Recursive CTE 
with CTE as (
select  distinct store , 1 as Q_No  
from STORES
union all 
select store , Q_No + 1
from CTE 
where Q_No<4)
,Q as (
select store , 'Q'+CAST(Q_No as char) as Quarter_no
from CTE)

select Q.Store , Q.Quarter_no
from Q
left join stores
on Q.Store=STORES.Store and Q.Quarter_no=STORES.Quarter
where STORES.Store is null ;

-- Method 3 
with CTE as (
select Distinct s1.Store , S2.Quarter As Quat
from STORES as S1 , STORES as S2)
,Q as (
select store ,CAST(Quat as char) as Quarter_no
from CTE)

select Q.Store , Q.Quarter_no
from Q
left join stores
on Q.Store=STORES.Store and Q.Quarter_no=STORES.Quarter
where STORES.Store is null 

-- Question 22
create table exams (student_id int, subject varchar(20), marks int);
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

select * from exams e1
join exams e2 
on e1.student_id=e2.student_id and e1.subject<>e2.subject and e1.marks=e2.marks;

select student_id 
from exams 
where subject in ('Physics','Chemistry')
Group by student_id
having count(distinct subject)=2 and count(distinct marks)=1;

-- Question 23 
create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);

select * from covid
-- Method 1
WITH CTE AS (
select * ,
Rank()over(partition by city order by days ) as RN ,
Rank()over(partition by city order by cases ) as RN1  , 
Rank()over(partition by city order by days )-Rank()over(partition by city order by cases )  as DIFF
from 
covid)
select city
from CTE 
Group by city
having Count(Distinct DIFF)=1 and max(diff)=0;

WITH CTE AS (
select city , cases , lag(cases, 1,0)over(partition by city order by days )as Prev_day
from 
covid) 
select city 
from CTE 
group by city
having sum(case when cases>Prev_day then 0 else 1 end )=0

-- Question 24 
create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

select * from company_users;

WITH CTE As (
select company_id, user_id , count(language) as cnt 
from company_users
where language in ('English','German')
group by company_id, user_id
having count(language)=2) 

select company_id
from CTE
group by company_id
having count(user_id)=2;

-- Questuion 25 
create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);

select * from products;
select * from customer_budget;

with running_cost as (
select *, 
sum(cost)over(order by cost asc) as Running_cost1
from products 
)
select customer_id , budget ,STRING_AGG(product_id , ',')
from customer_budget as c
Left Join running_cost as r
on r.Running_cost1<c.budget
group by customer_id,budget;

-- Question 26 find total no of messages exchanged between each person per day

CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

select * from subscriber;

select sms_date , p0 , p1 , sum(sms_no)
from (
select * , 
case when sender>receiver then sender else receiver end as p0, 
case when sender<receiver then sender else receiver end as p1
from subscriber) as t 
group by sms_date , p0 , p1;


-- Question 27 
CREATE TABLE [students1](
 [studentid] [int] NULL,
 [studentname] [nvarchar](255) NULL,
 [subject] [nvarchar](255) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
)

insert into students1 values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students1 values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students1 values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students1 values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students1 values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students1 values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students1 values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students1 values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students1 values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students1 values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students1 values (5,'John Mike','Subject3',98,2,'2022-11-02');

select * from students1;
--Write an SQL query to get the list of students who scored above the average 
--marks in each subject.
select studentname from(
select * ,
AVG(marks)over(partition by subject order by testdate ) as AVG_SUBJECT_MARKS
from students1) as t 
where marks>AVG_SUBJECT_MARKS

--Write an SQL query to get the percentage of studentss who score more than 90
--in any subject amongst the total students
select 
count(distinct case when marks>90 then studentid else null  end )*1.0 /count(distinct studentid)*100 
from students1;

--Write an SQL query to get the second highest and second-lowest marks for each subject.

select subject , 
sum(case when RNK=2 then marks end) as 'Second-Highest-Salary' , 
sum(case when RNK_1=2 then marks end )as 'Second-Lowest-salary'
from (
select subject, marks , Rank()over(partition by subject order by marks desc) as RNK , 
Rank()over(partition by subject order by marks ) as RNK_1
from students1) as t
group by subject;
----For each student and test, identify if their marks increased or decreasethe previous testtuden
select * from students1;

WITH CTE AS (
select * , 
lag(marks , 1)over(partition by studentname ,testid order by testdate) as Prev_test
from students1) 

select *  , 
case when marks>Prev_test then'Increased' else'Decreased' end as status 
from CTE 
where prev_test is not null;


-- Question 28 
CREATE TABLE [dbo].[int_orders](
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) ON [PRIMARY];
INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (30, CAST('1995-07-14' AS Date), 9, 1, 460);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST('1996-08-02' AS Date), 4, 2, 540);
INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (40, CAST('1998-01-29' AS Date), 7, 2, 2400);
INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (50, CAST('1998-02-03' AS Date), 6, 7, 600);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (60, CAST('1998-03-02' AS Date), 6, 7, 720);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (70, CAST('1998-05-06' AS Date), 9, 7, 150);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST('1999-01-30' AS Date), 4, 8, 1800);

select * 
from[dbo].[int_orders]
--Find the the largest order result value each salesperson and display order without using window functions
select a.order_number , a.order_date , a.cust_id, a.salesperson_id,a.amount
from [dbo].[int_orders] a 
left join [dbo].[int_orders] b 
 on a.salesperson_id=b.salesperson_id
 group by a.order_number , a.order_date , a.cust_id, a.salesperson_id,a.amount
 having a.amount>=max(b.amount)

--Question 29
create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');

select * from event_status;

WITH CTE AS (
select * , 
sum(case when status='On' and prev_status='Off' then 1 else 0 end )
over(order by event_time) as GRP
from(
select * ,
lag(status,1,status)over(order by event_time) as prev_status
from event_status) as t) 

select Min(event_time ), max(event_time) , count(1)-1 as Event_count
from CTE 
group by GRP;

--Question 30 
create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

select * from players_location;

select RN , 
MAX(case when city ='Bangalore' then name else null end )as Banglore , 
MAX(case when city ='Mumbai' then name else null end )as Mumbai,
MAX(case when city ='Delhi' then name else null end )as Delhi 
from(
select ROW_NUMBER()Over(partition by city order by name asc) as RN ,
* 
from players_location) as t
group by RN;

--Question 31 median salary 

create table employee123 
(
emp_id int,
company varchar(10),
salary int
);

insert into employee123 values (1,'A',2341)
insert into employee123 values (2,'A',341)
insert into employee123 values (3,'A',15)
insert into employee123 values (4,'A',15314)
insert into employee123 values (5,'A',451)
insert into employee123 values (6,'A',513)
insert into employee123 values (7,'B',15)
insert into employee123 values (8,'B',13)
insert into employee123 values (9,'B',1154)
insert into employee123 values (10,'B',1345)
insert into employee123 values (11,'B',1221)
insert into employee123 values (12,'B',234)
insert into employee123 values (13,'C',2345)
insert into employee123 values (14,'C',2645)
insert into employee123 values (15,'C',2645)
insert into employee123 values (16,'C',2652)
insert into employee123 values (17,'C',65);


select * from employee123;

select company , avg(salary)as median_salary
FROM (
select * , ROW_NUMBER()over(partition by company order by salary ) rn  , 
count(1) over(partition by company ) as cnt 
from employee123) as t 
where rn between cnt/2 and cnt/2+1
group by company;

-- 33
/*-write an sql to find details of employees with 3rd highesst salary in each department.
in case there are less then 3 employees in a department thhen return employee details with lowest salary in that dep 
*/

CREATE TABLE [emp](
 [emp_id] [int] NULL,
 [emp_name] [varchar](50) NULL,
 [salary] [int] NULL,
 [manager_id] [int] NULL,
 [emp_age] [int] NULL,
 [dep_id] [int] NULL,
 [dep_name] [varchar](20) NULL,
 [gender] [varchar](10) NULL
) ;
insert into emp values(1,'Ankit',14300,4,39,100,'Analytics','Female')
insert into emp values(2,'Mohit',14000,5,48,200,'IT','Male')
insert into emp values(3,'Vikas',12100,4,37,100,'Analytics','Female')
insert into emp values(4,'Rohit',7260,2,16,100,'Analytics','Female')
insert into emp values(5,'Mudit',15000,6,55,200,'IT','Male')
insert into emp values(6,'Agam',15600,2,14,200,'IT','Male')
insert into emp values(7,'Sanjay',12000,2,13,200,'IT','Male')
insert into emp values(8,'Ashish',7200,2,12,200,'IT','Male')
insert into emp values(9,'Mukesh',7000,6,51,300,'HR','Male')
insert into emp values(10,'Rakesh',8000,6,50,300,'HR','Male')
insert into emp values(11,'Akhil',4000,1,31,500,'Ops','Male')


select * from emp;

select * from (
select * ,
rank()over(partition by dep_name order by salary ) RNK, 
count(emp_id)over(partition by dep_name   ) CNT
from emp) t 
where RNK=3 or(cnt<3 and RNK=CNT);

-- Question 34 
--write a query to displaythe records which havve 3 or more consecutive rows
--with the amount of people more than 100(inclusive)each day
create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);

select * from stadium;

WITH GRP as(
select * , ROW_NUMBER()over(order by visit_date) as rn, 
id-ROW_NUMBER()over(order by visit_date)  as diff
from stadium
where no_of_people>100) 

select * from GRP where diff in (
select diff
from GRP
Group by  diff
having count(diff)>3)

-- Question 35 
--business_city table has data from the day udaan has staarted operation
--write a SQL to identify yearwise count of newcities where udaan started their operations
create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);

select * from business_city
order by city_id;

WITH CTE as (
select  year(business_date) as bus_year , city_id 
from 
business_city )
select b1.bus_year , count(distinct case when b2.city_id is null then b1.city_id end ) as New_city_operation
from CTE as b1
left join  CTE as b2
on b1.bus_year>b2.bus_year and b1.city_id=b2.city_id
group by b1.bus_year;

-- Question 36 
create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);


select * from movie;

with CTE AS (
select seat  , occupancy  , LEFT(seat , 1) as Row_ID , cast (substring(seat ,2,2)  as int)as seat_no
from movie)  , 
CTE_2 as (
select *  , 
max(occupancy)over(partition by Row_id order by seat_no rows between current row and 3 following) as is_4_empty ,
count(occupancy)over(partition by Row_id order by seat_no rows between current row and 3 following) as CNT
from CTE )  , 
CTE_3 as (
select * 
from CTE_2
where is_4_empty=0 and CNT=4) 
select CTE_2.seat from 
CTE_2
inner join CTE_3 
on CTE_2.Row_ID=CTE_3.Row_ID and CTE_2.seat_no  between CTE_3.seat_no and CTE_3.seat_no +3 ;

--Question 37
/*writeasqltodeterminephone phone numbers that satisfy below conditions:
1- the numbers have both incoming and outgoing callS
2- the sum of dureation of outgoing calls should be greater than sum of duration of incoming calls */


create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);

select * from call_details;

WITH CTE as (
select call_number , count(distinct call_type) as CNT  , SUM(case when call_type='OUT' then call_duration else 0 end) as outgoingcalldurarion ,
SUM(case when call_type='INC' then call_duration else 0 end) as Incomingcalldurarion
from call_details
Group by call_number) 
select call_number from CTE 
where CNT>1 and outgoingcalldurarion>Incomingcalldurarion;

-- Question 38 

-- Question 39 
create table brands1
(
category varchar(20),
brand_name varchar(20)
);
insert into brands1 values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');


select * from brands1 ;

WITH CTE_1 as (
select *  , ROW_NUMBER()over(order by (select null)) as rn
from brands1) , 
CTE_2 as (
select * , lead(rn , 1 ,9999) over(order by rn) next_rn
from CTE_1
where category is not null) 
select CTE_2.category , CTE_1.brand_name
from CTE_1
join CTE_2 
on CTE_1.rn>CTE_2.rn and CTE_1.rn<=CTE_2.next_rn-1


--method 2 
with CTE As (
select * , ROW_NUMBER()over(order by (select null)) as RN, 
case when category is null then 0 else 1 end as  flag 
from brands1)  , 
CTE_2 as (
select * , 
sum(flag)over(order by RN) as rolling_sum
from CTE) 
select max(category)over(partition by rolling_sum order by rn) , brand_name 
from CTE_2
;

-- Question 40 
create table students12
(
student_id int,
student_name varchar(20)
);
insert into students12 values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams1
(
exam_id int,
student_id int,
score int);

insert into exams1 values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

select * from students12;
select * from exams1;


WITH all_scores as (
select exam_id , max(score) as max_score , min(score) as min_score
from exams1
group by exam_id)
select e.student_id 
from exams1  e
join all_scores a
on e.exam_id=a.exam_id
group  by e.student_id
having MAX(case when score=max_score or score=min_score then 1 else 0 end) = 0

-- Question 41 
/*thereisaphonelogtablethathat has information about callers'call history.
write a SQL to find out callers whose first and lastt call was to the same person on a given day.
*/

create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

	   select * from phonelog;
with CTE AS (
	select Callerid , cast(datecalled as date )as date , max(datecalled) as last_call , min(datecalled) as first_call 
	from phonelog
	group by Callerid,cast(datecalled as date ) ) 
	
	select p.* ,c1.Recipientid as first_reciepent  , C2.Recipientid as last_reciepent_id
	from CTE as p 
	join phonelog as C1  on p.Callerid=C1.Callerid and C1.Datecalled=p.first_call 
	join phonelog  as C2 on p.Callerid=C2.Callerid and C2.Datecalled=p.last_call
	where c1.Recipientid=c2.Recipientid

	

-- Question 42 
create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);

select * from candidates;

with Cum_sum as (
select * , sum(salary) over(partition by experience  order by emp_id rows between  unbounded preceding and current row) as Rolling_sum
from candidates) 
,seniors as (
select * from Cum_sum 
where experience='Senior' and Rolling_sum<=70000)

select * from Cum_sum 
where experience='Junior' and Rolling_sum<=(70000-(select sum(salary)  from seniors))
union all 
select * from seniors;

-- Question  43 
--write a SQL to list emp name along with thier manager and and senior manager name
--senior manager is manager's manager

create table emp121(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

INSERT INTO emp121 VALUES (1, 'Ankit', 100, 10000, 4, 39);
INSERT INTO emp121 VALUES (2, 'Mohit', 100, 15000, 5, 48);
INSERT INTO emp121 VALUES (3, 'Vikas', 100, 12000, 4, 37);
INSERT INTO emp121 VALUES (4, 'Rohit', 100, 14000, 2, 16);
INSERT INTO emp121 VALUES (5, 'Mudit', 200, 20000, 6, 55);
INSERT INTO emp121 VALUES (6, 'Agam', 200, 12000, 2, 14);
INSERT INTO emp121 VALUES (7, 'Sanjay', 200, 9000, 2, 13);
INSERT INTO emp121 VALUES (8, 'Ashish', 200, 5000, 2, 12);
INSERT INTO emp121 VALUES (9, 'Mukesh', 300, 6000, 6, 51);
INSERT INTO emp121 VALUES (10, 'Rakesh', 500, 7000, 6, 50);
select * from emp121;

WITH MANAGER_CTE AS (
select e1.emp_id as EMPID , e1.emp_name as EMPNAME , e1.department_id as DeptID , 
e1.salary as EMPSALARY , e1.manager_id as MGRID , e2.emp_name as  MGRNAME , e2.manager_id as SENIORMGRID 
from emp121 as  e1
Left join emp121 as  e2
on e1.manager_id =e2.emp_id) 

select M1.* , M2.EMPNAME as SENIORMGRNAME
from MANAGER_CTE as M1
LEFT JOIN MANAGER_CTE as M2
on M1.SENIORMGRID=M2.EMPID;

-- Question 44 
CREATE TABLE transactions44 (
    transaction_id INT PRIMARY KEY,
    type VARCHAR(20),
    amount NUMERIC(10, 2),
    transaction_date DATETIME
);

INSERT INTO transactions44 VALUES 
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 13:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00'),
(41515, 'withdrawal', 16.31, '2022-06-01 10:00:00'),
(624804, 'deposit', 165.00, '2022-06-17 10:00:00'),
(757995, 'deposit', 7.50, '2022-06-30 10:00:00'),
(112465, 'withdrawal', 295.95, '2022-06-28 10:00:00'),
(996414, 'withdrawal', 67.00, '2022-06-05 10:00:00');

select * from transactions44;

WITH CTE_1 as (
select *,cast(transaction_date as date) Date, Month(transaction_date) as Month,
case when type='withdrawal' then ((-1)*amount) else amount end as FINAL_AMOUNT
from 
transactions44) 

select transaction_id,type ,Date,Month ,FINAL_AMOUNT, sum(FINAL_AMOUNT)Over(order by date)
from CTE_1;

--Queestion 45 
CREATE TABLE rental_amenities (
    rental_id INT,
    amenity VARCHAR(50)
);

INSERT INTO rental_amenities VALUES 
(123, 'pool'),
(123, 'kitchen'),
(234, 'hot tub'),
(234, 'fireplace'),
(345, 'kitchen'),
(345, 'pool'),
(456, 'pool');
INSERT INTO rental_amenities VALUES 
(985, 'fireplace'),
(985, 'kitchen');


select * from rental_amenities;

WITH CTE AS (
    SELECT Amenity_list, COUNT(*) AS CNT
    FROM (
        SELECT rental_id, STRING_AGG(amenity, ',') WITHIN GROUP (ORDER BY amenity) AS Amenity_list
        FROM rental_amenities
        GROUP BY rental_id
    ) a
    GROUP BY Amenity_list
    HAVING COUNT(*) > 1
)

SELECT Amenity_list, 
       CAST(factorial(CNT) / (factorial(CNT - 2) * factorial(2)) AS DECIMAL(10, 2)) AS Result
FROM CTE;
-- formula of combination 
--n!/(n-r)!*r!

with CTE as (
SELECT rental_id, STRING_AGG(amenity, ',') WITHIN GROUP (ORDER BY amenity) AS Amenity_list
        FROM rental_amenities
        GROUP BY rental_id)  , 
		CTE_2 as (
select * , ROW_NUMBER()Over(partition by Amenity_list order by rental_id) RN 
from CTE) 

select c.rental_id , c1.rental_id ,c.Amenity_list,c1.Amenity_list 
from CTE_2 as c 
Join CTE_2 as c1
on c.RN<c1.RN and c.Amenity_list=c1.Amenity_list


-- Question 46

create table tbl_orders (
order_id integer,
order_date date
);
insert into tbl_orders
values (1,'2022-10-21'),(2,'2022-10-22'),
(3,'2022-10-25'),(4,'2022-10-25');

select * 
from tbl_orders;

select * into tbl_orders_copy from  tbl_orders;



insert into tbl_orders
values (7,'2022-10-27'),(8,'2022-10-28');

delete from tbl_orders where order_id=2;

select coalesce(o1.order_id,o2.order_id) ,  
case when o1.order_id is null then 'I' 
when o2.order_id is null then 'D'
end as status 
from tbl_orders_copy o1
FULL join tbl_orders  o2
on o1.order_date=o2.order_date
where o1.order_id is null or o2.order_id is null ;

-- Question 47 
--write a query to print total rides and profit rides for eadch driver
--profit ride is when the end location of current ride is same as start location on next ride

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers;

select id ,count(*) , 
sum(case when end_loc=Lead_loc  then 1 else 0 end )as flag 
from (
select * , lead(start_loc,1)over(partition by id order by start_time)as Lead_loc
from drivers 
) as b
Group by id;

-- Question 48 
--Write a sql query to find users who purchased different products on different dates
--ie : products purchased on any given day are not repDeated on any other day

create table purchase_history
(userid int
,productid int
,purchasedate date
);
SET DATEFORMAT dmy;
insert into purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012')
;

select * from purchase_history;

select userid ,count( distinct purchasedate) as CNT , count(distinct productid) , count(productid)
from purchase_history
group by userid
having count( distinct purchasedate)>1  and count(distinct productid) = count(productid);

-- Question 49
/*Find the number of users that made additional in-app purchases due to the success of the marketingcampaign.
The marketing campaign doesn't start until one day after the initial in-app purchase so users that only
made one or multiple purchases on the first day do not counht, nor do we count users that over time purchase
only the products they purchased on the first day.*/


*/
CREATE TABLE [marketing_campaign](
 [user_id] [int] NULL,
 [created_at] [date] NULL,
 [product_id] [int] NULL,
 [quantity] [int] NULL,
 [price] [int] NULL
);
insert into marketing_campaign values (10,'2019-01-01',101,3,55),
(10,'2019-01-02',119,5,29),
(10,'2019-03-31',111,2,149),
(11,'2019-01-02',105,3,234),
(11,'2019-03-31',120,3,99),
(12,'2019-01-02',112,2,200),
(12,'2019-03-31',110,2,299),
(13,'2019-01-05',113,1,67),
(13,'2019-03-31',118,3,35),
(14,'2019-01-06',109,5,199),
(14,'2019-01-06',107,2,27),
(14,'2019-03-31',112,3,200),
(15,'2019-01-08',105,4,234),
(15,'2019-01-09',110,4,299),
(15,'2019-03-31',116,2,499),
(16,'2019-01-10',113,2,67),
(16,'2019-03-31',107,4,27),
(17,'2019-01-11',116,2,499),
(17,'2019-03-31',104,1,154),
(18,'2019-01-12',114,2,248),
(18,'2019-01-12',113,4,67),
(19,'2019-01-12',114,3,248),
(20,'2019-01-15',117,2,999),
(21,'2019-01-16',105,3,234),
(21,'2019-01-17',114,4,248),
(22,'2019-01-18',113,3,67),
(22,'2019-01-19',118,4,35),
(23,'2019-01-20',119,3,29),
(24,'2019-01-21',114,2,248),
(25,'2019-01-22',114,2,248),
(25,'2019-01-22',115,2,72),
(25,'2019-01-24',114,5,248),
(25,'2019-01-27',115,1,72),
(26,'2019-01-25',115,1,72),
(27,'2019-01-26',104,3,154),
(28,'2019-01-27',101,4,55),
(29,'2019-01-27',111,3,149),
(30,'2019-01-29',111,1,149),
(31,'2019-01-30',104,3,154),
(32,'2019-01-31',117,1,999),
(33,'2019-01-31',117,2,999),
(34,'2019-01-31',110,3,299),
(35,'2019-02-03',117,2,999),
(36,'2019-02-04',102,4,82),
(37,'2019-02-05',102,2,82),
(38,'2019-02-06',113,2,67),
(39,'2019-02-07',120,5,99),
(40,'2019-02-08',115,2,72),
(41,'2019-02-08',114,1,248),
(42,'2019-02-10',105,5,234),
(43,'2019-02-11',102,1,82),
(43,'2019-03-05',104,3,154),
(44,'2019-02-12',105,3,234),
(44,'2019-03-05',102,4,82),
(45,'2019-02-13',119,5,29),
(45,'2019-03-05',105,3,234),
(46,'2019-02-14',102,4,82),
(46,'2019-02-14',102,5,29),
(46,'2019-03-09',102,2,35),
(46,'2019-03-10',103,1,199),
(46,'2019-03-11',103,1,199),
(47,'2019-02-14',110,2,299),
(47,'2019-03-11',105,5,234),
(48,'2019-02-14',115,4,72),
(48,'2019-03-12',105,3,234),
(49,'2019-02-18',106,2,123),
(49,'2019-02-18',114,1,248),
(49,'2019-02-18',112,4,200),
(49,'2019-02-18',116,1,499),
(50,'2019-02-20',118,4,35),
(50,'2019-02-21',118,4,29),
(50,'2019-03-13',118,5,299),
(50,'2019-03-14',118,2,199),
(51,'2019-02-21',120,2,99),
(51,'2019-03-13',108,4,120),
(52,'2019-02-23',117,2,999),
(52,'2019-03-18',112,5,200),
(53,'2019-02-24',120,4,99),
(53,'2019-03-19',105,5,234),
(54,'2019-02-25',119,4,29),
(54,'2019-03-20',110,1,299),
(55,'2019-02-26',117,2,999),
(55,'2019-03-20',117,5,999),
(56,'2019-02-27',115,2,72),
(56,'2019-03-20',116,2,499),
(57,'2019-02-28',105,4,234),
(57,'2019-02-28',106,1,123),
(57,'2019-03-20',108,1,120),
(57,'2019-03-20',103,1,79),
(58,'2019-02-28',104,1,154),
(58,'2019-03-01',101,3,55),
(58,'2019-03-02',119,2,29),
(58,'2019-03-25',102,2,82),
(59,'2019-03-04',117,4,999),
(60,'2019-03-05',114,3,248),
(61,'2019-03-26',120,2,99),
(62,'2019-03-27',106,1,123),
(63,'2019-03-27',120,5,99),
(64,'2019-03-27',105,3,234),
(65,'2019-03-27',103,4,79),
(66,'2019-03-31',107,2,27),
(67,'2019-03-31',102,5,82);
with RNK_user as (
select *  , 
rank()over(partition by user_id order by created_at) RNK
from marketing_campaign) , 
first_rnk_user as (
select * from RNK_user 
where RNK=1), 
Except_First_RNK as
(select * from RNK_user where RNK>1
)

select  distinct a.user_id
from Except_First_RNK a
left join first_rnk_user b
on a.user_id=b.user_id and a.product_id=b.product_id and b.user_id is null


-- 50 




-- Question 61 
-- First Making a calendar Table 

select cast('2000-01-01' as date) as cal_date
,datepart(year,'2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name;


with CTE as (
select cast('2000-01-01' as date) as cal_date
,datepart(year,'2000-01-01') as cal_year
,datepart(dayofyear, '2000-01-01') as cal_year_day
,datepart(quarter, '2000-01-01') as cal_quarter
,datepart(month, '2000-01-01') as cal_month
,datename(month, '2000-01-01') as cal_month_name
,datepart(day, '2000-01-01') as cal_month_day
,datepart(week, '2000-01-01') as cal_week
,datepart(weekday, '2000-01-01') as cal_week_day
,datename(weekday, '2000-01-01') as cal_day_name
union all 
select DATEADD(d,1,cal_date) as cal_date ,
DATEPART(year , DATEADD(d,1,cal_date)) as cal_year ,
DATEPART(DAYOFYEAR, DATEADD(d,1,cal_date)) as cal_year_day ,
DATEPART(QUARTER , DATEADD(d,1,cal_date)) as cal_Quarter ,
DATEPART(Month , DATEADD(d,1,cal_date)) as cal_Month ,
DATENAME(MONTH , DATEADD(d,1,cal_date)) as cal_Month_name,
DATEPART(DAY , DATEADD(d,1,cal_date)) as cal_month_day ,
DATEPART(week , DATEADD(d,1,cal_date)) as cal_week,
DATEPART(WEEKDAY , DATEADD(d,1,cal_date)) as cal_week_day ,
DATENAME(WEEKDAY , DATEADD(d,1,cal_date)) as cal_week_name 
from CTE 
where cal_date<'2050-10-01') 


select * 
into cal_dim
from CTE option(maxrecursion 32767)

DROP TABLE cal_dim;





















-- Question  62 
create table customers  (customer_name varchar(30))
insert into customers values ('Ankit Bansal')
,('Vishal Pratap Singh')
,('Michael'); 

select * from customers;

with CTE as (
select * ,
len(customer_name) - len(REPLACE(customer_name , ' ' , '')) as space_no  , 
 charindex(' ' , customer_name) as first_space , 
CHARINDEX(' ',customer_name,charindex(' ' , customer_name)+1) as second_space
from 
customers) 

select * , 
case when space_no =0  then customer_name 
else SUBSTRING	(customer_name , 1,first_space-1)  end as first_name ,
case when space_no<=1 then null 
else substring(customer_name ,first_space+1,second_space-first_space-1 )  end as middle_name  ,
case when space_no=0  then null 
when space_no=1 then SUBSTRING(customer_name,first_space,len(customer_name)) 
else SUBSTRING(customer_name,second_space,len(customer_name)) end as last_name
from CTE
;

with CTE as (
select * ,
len(customer_name) - len(REPLACE(customer_name , ' ' , '')) as space_no  , 
 charindex(' ' , customer_name) as first_space , 
CHARINDEX(' ',customer_name,charindex(' ' , customer_name)+1) as second_space
from 
customers) 

select * , 
case when space_no =0  then customer_name 
else SUBSTRING	(customer_name , 1,first_space-1)  end as first_name ,
case when space_no>1 then  
 substring(customer_name ,first_space+1,second_space-first_space-1 ) else null  end as middle_name  ,
case when space_no=0  then null 
when space_no=1 then SUBSTRING(customer_name,first_space,len(customer_name)) 
else SUBSTRING(customer_name,second_space,len(customer_name)) end as last_name
from CTE
;




-- Question 63 
/* In the last 7 days, get a distribution of games (%fof total gaames) based on the
social interaction that is happening during the games. Please cconsider the following
as the categories for getting the distribution:
No Social Interaction ( No messages, emojis or gifts sentduring the game)
One sided interaction (Messages, emojis or gifts sent during the game by only
one player)
Both sided Interaction without custom_typed messages
Both sided interaction with custom_typed_messages from at least one player

*/
CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);
INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');

select * from user_interactions;

with CTE AS (
select game_id , 
case when count( interaction_type) =0  then 'No Social Interaction ' 
when count(distinct case when  interaction_type  is not null then user_id end )=1 then 'One sided Interaction' 
when count(distinct case when  interaction_type is not null then user_id end )=2 and 
count(distinct  case when interaction_type ='custom_typed' then user_id  end)=0  then
'Both side interaction without custom_typed_message' 
when count(distinct case when  interaction_type is not null then user_id end )=2 and 
count(distinct  case when interaction_type ='custom_typed' then user_id  end)>=1  then
'Both side interaction with atleast 1  custom_typed_message' 
end as 'Game Type'
from user_interactions
Group by game_id) 
select game_id  , count(1)
from CTE  
Group by game_id


-- Question 64 Top 5 Advanced SQL Interview Questions and Answers | Frequently Asked SQL interview questions
-- 64.1 Top 3 products by sales within cat/dept
select * from sales_data

