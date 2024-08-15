--TECHTFQ Intermediate SQL Queries 19 videos 

--Question 1  Three Tricky SQL Interview Queries
--1.A Print MeaningFull Comments 
create table comments_and_translations
(
	id				int,
	comment			varchar(100),
	translation		varchar(100)
);

insert into comments_and_translations values
(1, 'very good', null),
(2, 'good', null),
(3, 'bad', null),
(4, 'ordinary', null),
(5, 'cdcdcdcd', 'very bad'),
(6, 'excellent', null),
(7, 'ababab', 'not satisfied'),
(8, 'satisfied', null),
(9, 'aabbaabb', 'extraordinary'),
(10, 'ccddccbb', 'medium');

select * , case when translation is null then comment else translation end as Final_comment
from comments_and_translations;

select * , coalesce(translation , comment) as Final_comment 
from comments_and_translations;

--1B Derive desired output
CREATE TABLE source
    (
        id      int,
        name    varchar(1)
    );

CREATE TABLE target
    (
        id      int,
        name    varchar(1)
    );

INSERT INTO source VALUES (1, 'A');
INSERT INTO source VALUES (2, 'B');
INSERT INTO source VALUES (3, 'C');
INSERT INTO source VALUES (4, 'D');

INSERT INTO target VALUES (1, 'A');
INSERT INTO target VALUES (2, 'B');
INSERT INTO target VALUES (4, 'X');
INSERT INTO target VALUES (5, 'F');

select * from source;
select * from target;

select s.id ,'Mismatch' as comment
from source s
join target t
on s.id=t.id and s.name<>t.name
union 
select s.id , 'New in source'
from source s
LEFT join target t
on s.id=t.id
where  t.name is null
union
select t.id , 'New in Target'
from source s
Right join target t
on s.id=t.id
where  s.name is null;

--1.C  IPL Matches 
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');
WITH MATCHES AS (
Select * , ROW_NUMBER()over(order by team_name ) as R_N from teams)
select T1.team_name as Team_name  , t2.team_name as Opponent_Team from 
MATCHES as T1
join MATCHES as t2
on t1.R_N<t2.R_N
order by T1.team_name;

-- Question 2 9 complex SQL Queries to practise and there dataset as well 
--2.1 Write a SQL Query to fetch all the duplicate records in a table
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');
with CTE AS (
select * , 
ROW_NUMBER()OVER(partition by user_name order by user_id ) as R_N from users) 
select *  from CTE where R_N>1;

--2.B Write a SQL query to fetch the second last record from employee table.
drop table employee2_B;
create table employee2_B
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

INSERT INTO employee2_B(emp_ID,emp_NAME, DEPT_NAME, SALARY)
VALUES
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Komal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'Chandni', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);

with CTE AS (
select * , ROW_NUMBER()over(order by emp_ID desc)as R_N from employee2_B)
select * from CTE where R_N=2;

--2.C Write a SQL query to display only the details of employees who either earn the highest salary
--or the lowest salary in each department from the employee table.
create table employee2_C
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

INSERT INTO employee2_C
VALUES
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Komal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'Chandni', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);

Select * ,
MAX(SALARY)over(Partition by DEPT_NAME order by SALARY DESC ) as MAX_SAL, 
MIN(SALARY)over(Partition by DEPT_NAME order by SALARY DESC ) as MAX_SAL
from employee2_C;

Select e.* from employee2_C as e
join (
Select DEPT_NAME, MAX(SALARY) as MAX_SAL , MIN(SALARY) as MIN_SAL
from employee2_C
Group by DEPT_NAME) as temp
on e.DEPT_NAME=temp.DEPT_NAME
where e.SALARY=temp.MAX_SAL or e.SALARY=MIN_SAL;

--2.D From the doctors table, fetch the details of doctors who work in the same hospital
--but in different specialty.
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);
insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select d1.* 
from doctors d1
join doctors d2
on d1.id<>d2.id and d1.hospital=d2.hospital and d1.speciality<>d2.speciality;

--2.E . From the login_details table, fetch the users who logged in consecutively 3 or more times
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

--2.F From the students table, write a SQL query to interchange the adjacent student names.
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

select id,student_name,
case when id%2 <> 0 then lead(student_name,1,student_name) over(order by id)
when id%2 = 0 then lag(student_name) over(order by id) end as new_student_name
from students;

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

-- 2.H   From the following 3 tables (event_category, physician_speciality, patient_treatment),
--write a SQL query to get the histogram of specialties of the unique physicians 
--who have done the procedures but never did prescribe anything.
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);
insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');

insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');

insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);

select p.* , e.category , p1.speciality
from patient_treatment p
FULL join  event_category e
on p.event_name=e.event_name
FULL join physician_speciality p1
on p.physician_id=p1.physician_id
where e.category='Procedure'
;



--2.I   Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

INSERT INTO patient_logs (account_id, date,patient_id)
VALUES
(1, '2020-01-02', 100),
(1, '2020-01-27', 200),
(2, '2020-01-01', 300),
(2, '2020-01-21', 400),
(2, '2020-01-21', 300),
(2, '2020-01-01', 500),
(3, '2020-01-20', 400),
(1, '2020-03-04', 500),
(3, '2020-01-20', 450);
WITH CTE AS (
select *, 
DATENAME(MM, date) as Month
from patient_logs)  , 
 CTE_2 as (
select  Month ,account_id ,count( Distinct patient_id) as CNT
from CTE 
Group by  Month , account_id) 
select  *  , 
ROW_NUMBER() over(Partition by Month  order by CNT desc) Rnk 
from CTE_2

;
select * from patient_logs;


-- Question  3 olympic dataset done 
-- Question 4 & 5 

-- Question 6 
-- Question 7 Ungroup given input data | FAANG Interview Query

create table travel_items
(
id              int,
item_name       varchar(50),
total_count     int
);
insert into travel_items values
(1, 'Water Bottle', 2),
(2, 'Tent', 1),
(3, 'Apple', 4);
select * from travel_items;

with CTE as
(
select id,item_name,total_count
from travel_items
union all 
select id,item_name,total_count-1
from cte
where total_count>1
)
select id,item_name from cte
order by 1

-- Question 8 
create table brands
(
    Year    int,
    Brand   varchar(20),
    Amount  int
);
insert into brands values (2018, 'Apple', 45000);
insert into brands values (2019, 'Apple', 35000);
insert into brands values (2020, 'Apple', 75000);
insert into brands values (2018, 'Samsung',	15000);
insert into brands values (2019, 'Samsung',	20000);
insert into brands values (2020, 'Samsung',	25000);
insert into brands values (2018, 'Nokia', 21000);
insert into brands values (2019, 'Nokia', 17000);
insert into brands values (2020, 'Nokia', 14000);
WITH CTE AS (
select * , 
case when Amount < lead(amount,1,amount+1)over(partition by brand order by year  )
then 1 else 0 end as flag from brands) 
select * from CTE where brand not in (select brand from cte where flag=0);

-- Question 10 
create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

with CTE as (
select * , 
ROW_NUMBER()OVER(order by distance) AS RN 
from src_dest_distance) 
select t1.*
from cte as t1
join cte t2 
on t1.RN<t2.RN
and t1.source=t2.destination;

-- Question 11 

drop table src_dest_distance_2;
create table src_dest_distance_2
(
    src         varchar(20),
    dest        varchar(20),
    distance    float
);
insert into src_dest_distance_2 values ('A', 'B', 21);
insert into src_dest_distance_2 values ('B', 'A', 28);
insert into src_dest_distance_2 values ('A', 'B', 19);
insert into src_dest_distance_2 values ('C', 'D', 15);
insert into src_dest_distance_2 values ('C', 'D', 17);
insert into src_dest_distance_2 values ('D', 'C', 16.5);
insert into src_dest_distance_2 values ('D', 'C', 18);
WITH CTE AS (
 select src,dest,count(1) as no_of_routes ,sum(distance) as tot_dist
    , row_number() over(order by src) as id
    from src_dest_distance_2
    group by src,dest
) 
select t1.src , t1.dest,(t1.tot_dist+t2.tot_dist)/(t1.no_of_routes+t2.no_of_routes)
from CTE t1
join CTE t2 
on t1.src=t2.dest and t1.id<t2.id;

-- Question 11 
CREATE TABLE activity_log (
  username VARCHAR(50),
  activity VARCHAR(50),
  startdate DATE,
  enddate DATE
);
INSERT INTO activity_log (username, activity, startdate, enddate) VALUES
('Amy', 'Travel', '2020-02-12', '2020-02-21'),
('Amy', 'Dancing', '2020-02-21', '2020-02-23'),
('Amy', 'Travel', '2020-02-24', '2020-02-28'),
('Joe', 'Travel', '2020-02-11', '2020-02-18'),
('Adam', 'Travel', '2020-02-12', '2020-03-20'),
('Adam', 'Dancing', '2020-02-21', '2020-02-23'),
('Adam', 'Singing', '2020-02-24', '2020-02-28'),
('Adam', 'Travel', '2020-03-01', '2020-03-28');
WITH CTE as  (
select ROW_NUMBER()Over(partition by username order by startdate) as rn  , * , 
count(1)over(partition by username order by startdate 
range between unbounded preceding and unbounded following ) as cnt
from activity_log) 
select username , activity  
from CTE 
where rn= case when cnt=1 then 1 else cnt-1 end ;

--Question 12
select * from dbo.correct_answer;
select * from dbo.question_paper_code;
select * from dbo.student_response;
select * from dbo.student_list;

WITH CTE AS (
select stu.* , res.question_paper_code  as paper_code , res.question_number as QNO , res.option_marked  as option_marked , Ques_pap.subject  as Subject , corr.correct_option as correct_Option 
From dbo.student_list as stu 
join dbo.student_response  as res
on stu.roll_number=res.roll_number 
join dbo.question_paper_code  as Ques_pap
on res.question_paper_code=Ques_pap.paper_code
join correct_answer as corr
on res.question_paper_code =corr.question_paper_code and res.question_number=corr.question_number) , 
CTE_2 as (
select roll_number , Student_name , Class , section , School_name , 
sum(Case when subject ='Math' and option_marked<>'e' and option_marked=correct_Option  then 1 else 0 end ) as Math_Correct , 
sum(Case when subject ='Math' and option_marked<>'e' and option_marked<>correct_Option  then 1 else 0 end ) as Math_wrong , 
sum(Case when subject ='Math' and option_marked<>'e'  then 1 else 0 end ) as Math_yet_to_Learn , 
sum(Case when subject ='Math'   then 1 else 0 end ) as Total_Math_Question ,
sum(Case when subject ='Science' and option_marked<>'e' and option_marked=correct_Option  then 1 else 0 end ) as science_Correct , 
sum(Case when subject ='Science' and option_marked<>'e' and option_marked<>correct_Option  then 1 else 0 end ) as Science_wrong , 
sum(Case when subject ='Science' and option_marked<>'e'  then 1 else 0 end ) Science_yet_to_Learn , 
sum(Case when subject ='Science'   then 1 else 0 end ) as Total_Science_Question 
from 
CTE
Group by roll_number , Student_name , Class , section , School_name ) 
select * , 
(Math_Correct/Total_Math_Question)*100 as Math_score , (science_Correct/Total_Science_Question)*100 as Sciecne_score 
from CTE_2;

-- Question 13 
create table account_balance
(
    account_no          varchar(20),
    transaction_date    date,
    debit_credit        varchar(10),
    transaction_amount  decimal
);


-- Insert data into account_balance table
INSERT INTO account_balance VALUES ('acc_1', CONVERT(DATE, '2022-01-20'), 'credit', 100);
INSERT INTO account_balance VALUES ('acc_1', CONVERT(DATE, '2022-01-21'), 'credit', 500);
INSERT INTO account_balance VALUES ('acc_1', CONVERT(DATE, '2022-01-22'), 'credit', 300);
INSERT INTO account_balance VALUES ('acc_1', CONVERT(DATE, '2022-01-23'), 'credit', 200);
INSERT INTO account_balance VALUES ('acc_2', CONVERT(DATE, '2022-01-20'), 'credit', 500);
INSERT INTO account_balance VALUES ('acc_2', CONVERT(DATE, '2022-01-21'), 'credit', 1100);
INSERT INTO account_balance VALUES ('acc_2', CONVERT(DATE, '2022-01-22'), 'debit', 1000);
INSERT INTO account_balance VALUES ('acc_3', CONVERT(DATE, '2022-01-20'), 'credit', 1000);
INSERT INTO account_balance VALUES ('acc_4', CONVERT(DATE, '2022-01-20'), 'credit', 1500);
INSERT INTO account_balance VALUES ('acc_4', CONVERT(DATE, '2022-01-21'), 'debit', 500);
INSERT INTO account_balance VALUES ('acc_5', CONVERT(DATE, '2022-01-20'), 'credit', 900);
WITH CTE AS (
select *, 
case when  debit_credit='debit' then transaction_amount*(-1) else transaction_amount end as amount 
from account_balance) , 
final_cte as(
select account_no, transaction_date ,
sum(amount)over(partition by account_no order by transaction_date ) as Cumm_Balance , 
sum(amount)over(partition by account_no order by transaction_date
range between unbounded preceding and unbounded following) as final_balance , 
case when sum(amount)over(partition by account_no order by transaction_date )>=1000 then 1 else 0 end as flag
from CTE 
) 
select account_no, min(transaction_date) as transaction_date

from 
final_cte
where final_balance>=1000 and flag =1
group by account_no

-- Question 14 
-- Create table billing
CREATE TABLE billing (
    customer_id int,
    customer_name varchar(1),
    billing_id varchar(5),
    billing_creation_date date,
    billed_amount int
);

-- Insert data into billing table
INSERT INTO billing VALUES (1, 'A', 'id1', '2020-10-10', 100);
INSERT INTO billing VALUES (1, 'A', 'id2', '2020-11-11', 150);
INSERT INTO billing VALUES (1, 'A', 'id3', '2021-11-12', 100);
INSERT INTO billing VALUES (2, 'B', 'id4', '2019-11-10', 150);
INSERT INTO billing VALUES (2, 'B', 'id5', '2020-11-11', 200);
INSERT INTO billing VALUES (2, 'B', 'id6', '2021-11-12', 250);
INSERT INTO billing VALUES (3, 'C', 'id7', '2018-01-01', 100);
INSERT INTO billing VALUES (3, 'C', 'id8', '2019-01-05', 250);
INSERT INTO billing VALUES (3, 'C', 'id9', '2021-01-06', 300);

With CTE as (
select customer_id, customer_name,
sum(case when YEAR(billing_creation_date)='2019' then  billed_amount else 0 end )as bill_2019_sum , 
sum(case when YEAR(billing_creation_date)='2020' then  billed_amount else 0 end )as bill_2020_sum , 
sum(case when YEAR(billing_creation_date)='2021' then  billed_amount else 0 end )as bill_2021_sum  ,
sum(case when YEAR(billing_creation_date)='2019' then 1 else 0 end )as bill_2019_cnt, 
sum(case when YEAR(billing_creation_date)='2020' then 1 else 0 end )as bill_2020_cnt, 
sum(case when YEAR(billing_creation_date)='2021' then 1 else 0 end )as bill_2021_cnt
from 
billing
group by customer_id, customer_name)


select customer_id, customer_name , (bill_2019_cnt+bill_2020_sum+bill_2021_sum)/(bill_2019_cnt+
bill_2020_cnt+bill_2021_cnt) as AVG_BILL
from CTE 

-- Question 15

drop table if exists job_positions;
create table job_positions
(
	id			int,
	title 		varchar(100),
	groups 		varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

select * from job_positions;
select * from job_employees;


with CTE AS (
select id , title , groups ,levels ,payscale , totalpost
from job_positions
union all 
select id , title , groups ,levels ,payscale , totalpost-1 
from CTE 
where totalpost>1), 
CTE_2 as 
(select id , title , groups ,levels ,payscale 
, ROW_NUMBER()Over(order by id ) as RN
from CTE 
)
select c.id , c.title , c.groups ,c.levels ,c.payscale , t.name
from CTE_2 as c
LEFT JOIN (
select * 
,ROW_NUMBER()Over(order by id) as RN1 
from job_employees) as T
on c.RN=t.RN1 and c.id= t.position_id;

-- Question 16 
--16.1 
create table candidates
(
    id      int,
    gender  varchar(1),
    age     int,
    party   varchar(20)
);
insert into candidates values(1,'M',55,'Democratic');
insert into candidates values(2,'M',51,'Democratic');
insert into candidates values(3,'F',62,'Democratic');
insert into candidates values(4,'M',60,'Republic');
insert into candidates values(5,'F',61,'Republic');
insert into candidates values(6,'F',58,'Republic');

create table results
(
    constituency_id     int,
    candidate_id        int,
    votes               int
);
insert into results values(1,1,847529);
insert into results values(1,4,283409);
insert into results values(2,2,293841);
insert into results values(2,5,394385);
insert into results values(3,3,429084);
insert into results values(3,6,303890);

select * from candidates;
select * from results;
WITH CTE AS (
select c.party ,r.* , RANK()over(partition by r.constituency_id order by r.votes desc) RNK
from candidates c
join results r
on c.id=r.candidate_id
)
select party , COUNT(constituency_id) Number_seats
from CTE 
where RNK=1
Group by Party 

-- 16.2 Advertising System Deviations report 
create table customers_m
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into customers_m values(1, 'Carolyn', 'O''Lunny');
insert into customers_m values(2, 'Matteo', 'Husthwaite');
insert into customers_m values(3, 'Melessa', 'Rowesby');

create table campaigns
(
    id          int,
    customer_id int,
    name        varchar(50)
);
insert into campaigns values(2, 1, 'Overcoming Challenges');
insert into campaigns values(4, 1, 'Business Rules');
insert into campaigns values(3, 2, 'YUI');
insert into campaigns values(1, 3, 'Quantitative Finance');
insert into campaigns values(5, 3, 'MMC');

create table events
(
    campaign_id int,
    status      varchar(50)
);

insert into events values(1, 'success');
insert into events values(1, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(2, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(3, 'success');
insert into events values(4, 'success');
insert into events values(4, 'success');
insert into events values(4, 'failure');
insert into events values(4, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');
insert into events values(5, 'failure');

insert into events values(4, 'success');
insert into events values(5, 'success');
insert into events values(5, 'success');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(1, 'failure');
insert into events values(2, 'failure');
insert into events values(3, 'failure');

With CTE as (
select (cust.first_name+' '+cust.last_name) as full_name  ,string_agg(camp.name,',') AS c_names,  e.status as event_status , count(1) as cnt
from customers_m as  cust
join campaigns as camp  on cust.id=camp.customer_id
join events as e on camp.id=e.campaign_id
Group by (cust.first_name+' '+cust.last_name), e.status 
) 
select full_name , c_names , event_status , cnt 
from CTE
order by cnt desc ;

WITH CTE AS (
    SELECT 
        (cust.first_name + ' ' + cust.last_name) AS full_name,
        camp.name AS camp_name,
        e.status AS event_status,
        COUNT(*) AS cnt
    FROM 
        customers_m AS cust
    JOIN 
        campaigns AS camp ON cust.id = camp.customer_id
    JOIN 
        events AS e ON camp.id = e.campaign_id
    GROUP BY 
        (cust.first_name + ' ' + cust.last_name), camp.name, e.status 
) 
SELECT 
    full_name, 
    STRING_AGG(camp_name, ',') AS camp_names, 
    event_status, 
    SUM(cnt) AS total_count
FROM 
    CTE
GROUP BY 
    full_name, event_status;

--16.3 Election Exit Poll by state report 
create table candidates_tab
(
    id          int,
    first_name  varchar(50),
    last_name   varchar(50)
);
insert into candidates_tab values(1, 'Davide', 'Kentish');
insert into candidates_tab values(2, 'Thorstein', 'Bridge');

create table results_tab
(
    candidate_id    int,
    state           varchar(50)
);
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'Alabama');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(1, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'New York');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');
insert into results_tab values(2, 'Texas');
insert into results_tab values(1, 'New York');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(1, 'Texas');
insert into results_tab values(2, 'California');
insert into results_tab values(2, 'Alabama');

WITH CTE AS (
select c.first_name+' '+c.last_name as full_name , r.state as State_name, count(*) as total_votes , 
DENSE_RANK()Over(partition by c.first_name+' '+c.last_name  order by  count(*) desc )as RNK 
from candidates_tab c 
join results_tab r 
on c.id=r.candidate_id 
group by c.first_name+' '+c.last_name  , r.state
) 
select  Full_name , 
string_Agg(case when RNK=1 Then concat(State_name , total_votes) end , ',' )as First_place , 
string_AGG(case when RNK=2 Then concat(State_name , total_votes)  end , ',' )as Second_place,
String_AGG(case when RNK=3 Then concat(State_name , total_votes)  end  , ',')as Third_place
From CTE 
group by full_name


-- Question 17 
create table persons
(
	person			varchar(10),
	parent			varchar(10),
	person_status	varchar(10)	
);
insert into persons values ('A','X','Alive');
insert into persons values ('B','Y','Dead');
insert into persons values ('X','X1','Alive');
insert into persons values ('Y','Y1','Alive');
insert into persons values ('X1','X2','Alive');
insert into persons values ('Y1','Y2','Dead');

select  c.person as child , c.parent as p_arent ,p.parent as Grandparent ,gp.person_status
from persons c
left join persons  p 
on c.parent=p.person 
LEFT join persons as gp 
on p.parent=gp.person;

-- Question 18 
-- Create a temporary table to hold the generated series and random scores
CREATE TABLE match_score (
    generate_series INT,
    runs INT
);

-- Insert random scores into the temporary table
DECLARE @i INT = 1;
WHILE @i <= 120
BEGIN
    INSERT INTO match_score (generate_series, runs)
    VALUES (@i, ROUND(RAND() * (6 - 1) + 1, 0));
    SET @i = @i + 1;
END;

-- Check the distribution of runs
SELECT runs, COUNT(*) AS count
FROM match_score
GROUP BY runs;

-- Update scores where runs = 5 to a random value between 1 and 2
UPDATE match_score
SET runs = ROUND(RAND() * (2 - 1) + 1,0)
WHERE runs = 5;

-- Check the updated distribution of runs
SELECT runs, COUNT(*) AS count
FROM match_score
GROUP BY runs;

with CTE  as(
select * , 
ntile(20)over(order by generate_series) as Over_no
from match_score) 
select Over_no , sum(runs) as total_run
from CTE 
Group by Over_no;

SELECT TOP 120 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS balls FROM sys.objects
-- Question 19
create table parent_child_status
(
	parent_id	int,
	child_id	int,
	status		varchar(20)
);
insert into parent_child_status values (1, 3, 'Active');
insert into parent_child_status values (1, 4, 'InActive');
insert into parent_child_status values (1, 5, 'Active');
insert into parent_child_status values (1, 6, 'InActive');
insert into parent_child_status values (2, 7, 'Active');
insert into parent_child_status values (2, 8, 'InActive');
insert into parent_child_status values (3, 9, 'Inactive');
insert into parent_child_status values (4, 10, 'Inactive');
insert into parent_child_status values (4, 11, 'Active');
insert into parent_child_status values (5, 12, 'InActive');
insert into parent_child_status values (5, 13, 'InActive');

with CTE AS (
select * , 
case when status ='Active' then 1 else 0 end as score 
from parent_child_status) , 
CTE_2 as (
select  DISTINCT parent_id , 
sum(score)over(partition by parent_id order by child_id 
range between unbounded preceding and unbounded following) as p
from CTE ) 
select parent_id  , 
CASe when p>0 then 'Active' else 'Inactive' end as status 
from CTE_2


select a.parent_id
, case when b.status is null 
			then 'InActive' 
       else b.status end as status
from (select distinct parent_id from parent_child_status) a
left join ( select distinct parent_id, status 
			from parent_child_status
			where status = 'Active') b 
			on b.parent_id = a.parent_id
order by a.parent_id;


with active as 
		(select parent_id, status 
		from parent_child_status
		where status = 'Active'
		group by parent_id, status),
	inactive as
		(select parent_id, status 
		from parent_child_status a
		where a.parent_id not in (select parent_id 
								  from active))
select * from inactive
union 
select * from active
order by parent_id;


