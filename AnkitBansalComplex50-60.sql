-- Question 60 
create table sku 
(
sku_id int,
price_date date ,
price int
);
delete from sku;
insert into sku values 
(1,'2023-01-01',10)
,(1,'2023-02-15',15)
,(1,'2023-03-03',18)
,(1,'2023-03-27',15)
,(1,'2023-04-06',20);

select * from sku;

select sku_id,price_date,price  from sku where DATEPART(Dd,price_date)=1;

with CTE as (
select * , ROW_NUMBER()over(partition by sku_id , month(price_date) order by price_date desc ) as RN
from sku ) 

select sku_id,price_date,price  from sku where DATEPART(Dd,price_date)=1
union all 
select  sku_id ,
DateTrunc(month , DateAdd(month,1,price_date)) as Next_date , price
from CTE where RN=1  and DateTrunc(month , DateAdd(month,1,price_date))
not in (select price_date  from sku where DATEPART(Dd,price_date)=1);

-- Method  2 
with CTE AS (
select * , 
ISNULL(DATEADD(dd,-1 , lead(price_date,1)over(partition by sku_id order by price_date)) , Dateadd(month,1 , price_date)) as Valid_Till
from sku ) 
select c.sku_id , c1.cal_date ,c.price  from CTE as c 
join  cal_dim  c1
on c1.cal_date between c.price_date and c.Valid_Till
where c1.cal_month_day=1;

-- Question 59 
CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_loc VARCHAR(50),
    end_loc VARCHAR(50)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
    ('c1', 'New York', 'Lima'),
    ('c1', 'London', 'New York'),
    ('c1', 'Lima', 'Sao Paulo'),
    ('c1', 'Sao Paulo', 'New Delhi'),
    ('c2', 'Mumbai', 'Hyderabad'),
    ('c2', 'Surat', 'Pune'),
    ('c2', 'Hyderabad', 'Surat'),
    ('c3', 'Kochi', 'Kurnool'),
    ('c3', 'Lucknow', 'Agra'),
    ('c3', 'Agra', 'Jaipur'),
    ('c3', 'Jaipur', 'Kochi');

	select * from travel_data;

	with CTE as (
	select customer , start_loc as loc , 'Start-loc' as column_name  from travel_data
	union all 
	select customer , end_loc as loc , 'End-loc' as column_name  from travel_data) 
	,CTE_2 as (
	select * , count(1)over(partition by customer ,loc) CNT
	from CTE) 
	
	select * from CTE_2;
	select customer , MAX(case when column_name='Start-loc' then loc  end) as start , 
	MAX(case when column_name='End-loc' then loc  end )as start
	from CTE_2 where CNT=1
	Group by customer;

-- Method 2 
select A.cus , A.start_loc , B.End_loc
from
(select  t1.customer as cus , t1.start_loc as start_loc
from travel_data t1 
left join travel_data t2 on t1.customer=t2.customer and t1.start_loc=t2.end_loc
where t2.customer is null 
)A
Join(
select  t1.customer as cus , t1.end_loc as End_loc
from travel_data t1 
LEFT join travel_data t3 on t1.customer=t3.customer and t1.end_loc=t3.start_loc
where t3.customer is null ) B
on A.cus=B.cus 


--Question 58 
create table namaste_orders
(
order_id int,
city varchar(10),
sales int
)

create table namaste_returns
(
order_id int,
return_reason varchar(20),
)

insert into namaste_orders
values(1, 'Mysore' , 100),(2, 'Mysore' , 200),(3, 'Bangalore' , 250),(4, 'Bangalore' , 150)
,(5, 'Mumbai' , 300),(6, 'Mumbai' , 500),(7, 'Mumbai' , 800)
;
insert into namaste_returns values
(3,'wrong item'),(6,'bad quality'),(7,'wrong item');

select * from namaste_orders;
select * from namaste_returns;

select o.city 
from namaste_orders o 
LEFT join namaste_returns r on o.order_id=r.order_id
group by o.city
having count(r.order_id) =0

--Question 57 

create table job_positions1 (id  int,
                                             title varchar(100),
                                              groups varchar(10),
                                              levels varchar(10),     
                                               payscale int, 
                                               totalpost int );
 insert into job_positions1 values (1, 'General manager', 'A', 'l-15', 10000, 1); 
insert into job_positions1 values (2, 'Manager', 'B', 'l-14', 9000, 5); 
insert into job_positions1 values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);  

  create table job_employees1 ( id  int, 
                                                 name   varchar(100),     
                                                  position_id  int 
                                                );  
  insert into job_employees1 values (1, 'John Smith', 1); 
insert into job_employees1 values (2, 'Jane Doe', 2);
 insert into job_employees1 values (3, 'Michael Brown', 2);
 insert into job_employees1 values (4, 'Emily Johnson', 2); 
insert into job_employees1 values (5, 'William Lee', 3); 
insert into job_employees1 values (6, 'Jessica Clark', 3); 
insert into job_employees1 values (7, 'Christopher Harris', 3);
 insert into job_employees1 values (8, 'Olivia Wilson', 3);
 insert into job_employees1 values (9, 'Daniel Martinez', 3);
 insert into job_employees1 values (10, 'Sophia Miller', 3)

 select * from job_positions1;
 select * from job_employees1;


 with CTE as (
 select id , title , groups , levels , payscale , totalpost  as t 
 from job_positions1
 union all 
 select id , title , groups , levels , payscale , t-1
 from CTE 
 where t>=2
 )
 
 select c.title , c.payscale, ISNULL(t.name , 'vacant')
 from 
 (select id , title , groups , levels , payscale , t, ROW_NUMBER()over(partition by title order by t ) as RN1
 from CTE  ) C
 LEFT join (
 select *  , row_number()over(partition by position_id order by id )  as  RN2
 from job_employees1) t 
 on C.id=t.position_id and C.RN1=t.RN2

 -- Question 56
 Create table candidates1(
id int primary key,
positions varchar(10) not null,
salary int not null);
-- Test Case 1
INSERT INTO candidates1 VALUES (1, 'junior', 5000);
INSERT INTO candidates1 VALUES (2, 'junior', 7000);
INSERT INTO candidates1 VALUES (3, 'junior', 7000);
INSERT INTO candidates1 VALUES (4, 'senior', 10000);
INSERT INTO candidates1 VALUES (5, 'senior', 30000);
INSERT INTO candidates1 VALUES (6, 'senior', 20000);

select * from candidates1;

with running_sum as (
select * , sum(salary)over(partition by positions order by salary rows between unbounded preceding and current row ) as cumsum
from 
candidates1)
 ,junior_Cte as (
select * from running_sum where positions  ='junior' and cumsum<=50000
)
,senior_cte as (
select * from running_sum where positions  ='senior' and cumsum<=50000-(select sum(salary) from junior_Cte))

select positions , count(*) 
from senior_cte
Group by positions 
union all 
select positions , count(*) 
from junior_Cte
Group by positions 
;

delete candidates1;

-- Test Case 2
INSERT INTO candidates1 VALUES (20, 'junior', 10000);
INSERT INTO candidates1 VALUES (30, 'senior', 15000);
INSERT INTO candidates1 VALUES (40, 'senior', 30000);
with running_sum as (
select * , sum(salary)over(partition by positions order by salary rows between unbounded preceding and current row ) as cumsum
from 
candidates1)
 ,junior_Cte as (
select * from running_sum where positions  ='junior' and cumsum<=50000
)
,senior_cte as (
select * from running_sum where positions  ='senior' and cumsum<=50000-(select sum(salary) from junior_Cte))

select positions , count(*) 
from senior_cte
Group by positions 
union all 
select positions , count(*) 
from junior_Cte
Group by positions 
;

delete candidates1;

-- Test Case 3
INSERT INTO candidates1 VALUES (1, 'junior', 15000);
INSERT INTO candidates1 VALUES (2, 'junior', 15000);
INSERT INTO candidates1 VALUES (3, 'junior', 20000);
INSERT INTO candidates1 VALUES (4, 'senior', 60000);

with running_sum as (
select * , sum(salary)over(partition by positions order by salary rows between unbounded preceding and current row ) as cumsum
from 
candidates1)
 ,junior_Cte as (
select count(*) as junior , sum(salary) as s from running_sum where positions  ='junior' and cumsum<=50000
)
,senior_cte as (
select count(*) as seniors from running_sum where positions  ='senior' and cumsum<=50000-(select sum(s) from junior_Cte))

select seniors , junior 
from senior_cte,junior_Cte
;

delete from candidates1;
-- Test Case 4
INSERT INTO candidates1 VALUES (10, 'junior', 10000);
INSERT INTO candidates1 VALUES (40, 'junior', 10000);
INSERT INTO candidates1 VALUES (20, 'senior', 15000);
INSERT INTO candidates1 VALUES (30, 'senior', 300);

with running_sum as (
select *  , 
sum(salary)over(partition by positions order by salary ) as cum_sum from candidates1)  , 
junior_cte as (
select count(*) as Junior_Cnt   , sum(salary) as s from running_sum where positions='junior' and cum_sum<=50000) , 
senior_cte as (
select count(*) as senior_Cnt  from running_sum where positions='senior' and cum_sum<=50000-(select sum(s) from junior_cte )
)
select Junior_Cnt , Senior_Cnt
from junior_cte , senior_cte;




--55 
-- Create employee_checkin_details table
CREATE TABLE employee_checkin_details (
    employeeid INT,
    entry_details VARCHAR(50),
    timestamp_details DATETIME
);

-- Insert data into employee_checkin_details
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details)
VALUES
    (1000, 'login', '2023-06-16 01:00:15.34'),
    (1000, 'login', '2023-06-16 02:00:15.34'),
    (1000, 'login', '2023-06-16 03:00:15.34'),
    (1000, 'logout', '2023-06-16 12:00:15.34'),
    (1001, 'login', '2023-06-16 01:00:15.34'),
    (1001, 'login', '2023-06-16 02:00:15.34'),
    (1001, 'login', '2023-06-16 03:00:15.34'),
    (1001, 'logout', '2023-06-16 12:00:15.34');

-- Create employee_details table
CREATE TABLE employee_details (
    employeeid INT,
    phone_number VARCHAR(50),
    isdefault BIT
);

-- Insert data into employee_details
INSERT INTO employee_details (employeeid, phone_number, isdefault)
VALUES
    (1001, '9999', 0),
    (1001, '1111', 0),
    (1001, '2222', 1),
    (1003, '3333', 0);

	select * from employee_checkin_details;
	select * from employee_details;

	-- Method 1 
	with login_details as (
	select employeeid, count(*) as total_login , max(timestamp_details) as latest_login
	from employee_checkin_details
	where entry_details='login'
	group by employeeid) 
	,logout_details as (
	select employeeid, count(*) as total_logout , max(timestamp_details) as latest_logout
	from employee_checkin_details
	where entry_details='logout'
	group by employeeid) 

	select A.employeeid,A.latest_login,B.latest_logout,A.total_login,B.total_logout ,
	A.total_login+B.total_logout as total , C.isdefault
	from login_details A
	join logout_details B on A.employeeid=B.employeeid  
	Left Join employee_details C on A.employeeid=C.employeeid 
		and (C.isdefault='True' or C.isdefault is null);

--Method 2 

	select A.employeeid ,count(*)  as Total ,
	count(case when entry_details='login' then timestamp_details else null end )as Total_login,
	count(case when entry_details='logout' then timestamp_details else null end )as Total_logout,
	max(case when entry_details='login' then timestamp_details else null end )as Latest_login,
	max(case when entry_details='logout' then timestamp_details else null end )as Latest_logout ,
	B.phone_number
	from 
	employee_checkin_details A 
	Left Join employee_details B on A.employeeid=B.employeeid 
	and (B.isdefault='True' or B.isdefault  IS NULL)
	Group by A.employeeid , B.phone_number;

-- Question 54 
DROP TABLE emp;
create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 10000,4,37);
insert into emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',300,7000,6,50);

select * from emp;
c1.department_id,c1.AVG_SAL ,sum(c2.S_sal)/sum(c2.CNT)


with CTE as (
select department_id, avg(salary) as AVG_SAL , Count(*) CNT , Sum(salary) as S_sal
from emp group by department_id ) 

Select c1.department_id,c1.AVG_SAL ,sum(c2.S_sal)/sum(c2.CNT)
from CTE as c1 
join CTE c2 
on c1.department_id<>c2.department_id
Group by c1.department_id,c1.AVG_SAL ;

-- Question  53 merge overlapping event in the same  hall 

create table hall_events
(
hall_id integer,
start_date date,
end_date date
);

insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');

select * from hall_events;

with cte as(
select *,
lag(end_date,1,start_date) over(partition by hall_id order by start_date) as prev_end_date,
case when lag(end_date,1,start_date) over(partition by hall_id order by start_date) >= start_date
 then 0 else 1 end  as flag
from hall_events
 )
 select hall_id,min(start_date),max(end_date)
 from cte 
 group by hall_id,flag

 --Question 52
 CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');

select * from booking_table;
select * from user_table;
--52.1 write a sql query that give total user count  of each segment and user who booked flight in april 2022

With Total_users as (
select Segment , count(USER_ID)as Total_users from user_table Group by Segment)
,flight_book_users as (
select u.Segment as segment , count(distinct u.User_id) as users_Booked_flight_april2022
from booking_table b 
join user_table u  on b.User_id=u.User_id
where  DateNAME(MONTH,b.Booking_date)='April' and b.Line_of_business='Flight'
Group by u.Segment)

select *
from Total_users t 
join flight_book_users f 
on t.Segment=f.segment;


--52.2 write a query to identify users whose first booking was hotel 
select * from (
select * , rank()over(partition by User_id order by Booking_date  ) rn
from booking_table) t
where rn=1 and Line_of_business='Hotel';

select distinct User_id from (
select * , FIRST_VALUE(Line_of_business)over(partition by User_id order by Booking_date rows between unbounded preceding and unbounded following ) as 
First_booking
from booking_table) t 
where First_booking='Hotel'
;

-- 52.3 write a query to calculate the days between first and last booking of each user 

select * ,DATEDIFF(DD,First_Booking_date,last_booking_date) AS no_DAYS
FROM(
select User_id,min(Booking_date) as First_Booking_date,
Max(Booking_date) as last_booking_date from booking_table  Group by User_id) T 
;

--52.4 write a query to count the number of flight and hotel bookings in each segments for the year 2022

select Segment, 
sum(case when Line_of_business='Flight' then 1 else 0 end )as Flight_Booking_total
,sum(case when Line_of_business='Hotel' then 1 else 0 end )as Hotel_Booking_total
from user_table  u
Join booking_table b  on u.User_id=b.User_id and YEAR(Booking_date)='2022'
Group by Segment;









 -- Question 51 
/* problem statement : we have a table which stores data of multiple sections. every section has 3 nurbers
we have to find top 4 numbers from any 2 sections(2 numbers each) whose addition should be maximum
so in this case we will choose section b where we haave 19(10+9) then we need to choose either C or D
becaue both has sum of 18 but in D we have 10 which is big from 9 so we will give priority to D*/

 create table section_data
(
section varchar(5),
number integer
)
insert into section_data
values ('A',5),('A',7),('A',10) ,('B',7),('B',9),('B',10) ,('C',9),('C',7),
('C',9) ,('D',10),('D',3),('D',8);

select * from section_data;

with CTE as (
select * , ROW_NUMBER()over(partition by section order by number desc ) as rn
from section_data) 
, cte2 as (
select * , 
sum(number)over(partition by section) as total, 
max(number)over(partition by section) as Max
from CTE 
where rn<=2
) 


select * from (
select * , 
dense_rank() over( order by total desc , Max desc) rnk
from cte2) t 
where t.rnk<=2;
