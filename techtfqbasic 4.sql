-- TECH TFQ 
-- Practice solving basic SQL Queries 
-- 10 ways to remove duplicate 
--Scenario 1: Data duplicated based on SOME of the columns <<<<>>>>
drop table cars;
create table  cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars;
--SOLUTION 1: Delete using Unique identifier
select model ,brand , count(id) 
from cars 
group  by model , brand;

Delete from cars 
where id in (
select max(id) 
from cars 
group  by model , brand
having count(1)>1);

--SOLUTION 2: Using SELF join
 delete from cars
where id in ( select c2.id
              from cars c1
              join cars c2 on c1.model = c2.model and c1.brand = c2.brand
              where c1.id < c2.id);

--SOLUTION 3: Using Window function
delete from cars
where id in ( select id
              from (select *
                   , row_number() over(partition by model, brand order by id) as rn
                   from cars) x
              where x.rn > 1);
-- Using MIN function. This delete even multiple duplicate records.
delete from cars
where id not in ( select min(id)
                  from cars
                  group by model, brand);

--Using backup table without dropping the original table.



SELECT * into cars_bkp
FROM cars
WHERE id IN (SELECT MIN(id)
              FROM cars
              GROUP BY model, brand);
TRUNCATE TABLE cars;
INSERT INTO cars
SELECT *
FROM cars_bkp;
DROP TABLE cars_bkp;


--Scenario 2: Data duplicated based on ALL of the columns <<<<>>>>
drop table  cars;
create table  cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);

select Distinct * from cars;

--Question 2 how to handle cummulative sum to actual value 
create table car_travels
(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

select * ,cumulative_distance-
LAG(cumulative_distance,1,0)over(partition by cars order by days ) as Actual_Distance
from 
car_travels;

-- Question 3 
drop table emp_input;
create table emp_input
(
id      int,
name    varchar(40)
);
insert into emp_input values (1, 'Emp1');
insert into emp_input values (2, 'Emp2');
insert into emp_input values (3, 'Emp3');
insert into emp_input values (4, 'Emp4');
insert into emp_input values (5, 'Emp5');
insert into emp_input values (6, 'Emp6');
insert into emp_input values (7, 'Emp7');
insert into emp_input values (8, 'Emp8');
with cte as (
select CONCAT(id ,' ' , name )as name  , NTILE(4)over(order by id ) buckets
from emp_input) 
select STRING_AGG(name ,',') as Results 
from CTE 
Group by buckets;

--Question 4 
-- Create the table
CREATE TABLE Tree(
    id INTEGER,
    p_id INTEGER
);

-- Insert the values into the table
INSERT INTO Tree (id, p_id) VALUES
(1, NULL),
(2, 1),
(3, 1),
(4, 2),
(5,2);
select id , 
case when p_id is null then 'Root'
	 when p_id is not null and id in (select distinct p_id from tree) then 'Inner'
	 else 'Leaf'
	 end as type 
from Tree;


