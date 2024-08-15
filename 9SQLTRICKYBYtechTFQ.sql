-- Question 6
create table files
(
id              int primary key,
date_modified   date,
file_name       varchar(50)
);
insert into files values (1	,   convert(datetime, '2021-06-03'), 'thresholds.svg');
insert into files values (2	,   convert(datetime, '2021-06-01'), 'redrag.py');
insert into files values (3	,   convert(datetime, '2021-06-03'), 'counter.pdf');
insert into files values (4	,   convert(datetime, '2021-06-06'), 'reinfusion.py');
insert into files values (5	,   convert(datetime, '2021-06-06'), 'tonoplast.docx');
insert into files values (6	,   convert(datetime, '2021-06-01'), 'uranian.pptx');
insert into files values (7	,   convert(datetime, '2021-06-03'), 'discuss.pdf');
insert into files values (8	,   convert(datetime, '2021-06-06'), 'nontheologically.pdf');
insert into files values (9	,   convert(datetime, '2021-06-01'), 'skiagrams.py');
insert into files values (10,   convert(datetime, '2021-06-04'), 'flavors.py');
insert into files values (11,   convert(datetime, '2021-06-05'), 'nonv.pptx');
insert into files values (12,   convert(datetime, '2021-06-01'), 'under.pptx');
insert into files values (13,   convert(datetime, '2021-06-02'), 'demit.csv');
insert into files values (14,   convert(datetime, '2021-06-02'), 'trailings.pptx');
insert into files values (15,   convert(datetime, '2021-06-04'), 'asst.py');
insert into files values (16,   convert(datetime, '2021-06-03'), 'pseudo.pdf');
insert into files values (17,   convert(datetime, '2021-06-03'), 'unguarded.jpeg');
insert into files values (18,   convert(datetime, '2021-06-06'), 'suzy.docx');
insert into files values (19,   convert(datetime, '2021-06-06'), 'anitsplentic.py');
insert into files values (20,   convert(datetime, '2021-06-03'), 'tallies.py');

WITH CTE AS (
select date_modified , substring(file_name , CHARINDEX('.',file_name)+1, 
len(file_name) -CHARINDEX('.', file_name )) as ext , count(*) as cnt
from files
group by date_modified , substring(file_name , CHARINDEX('.',file_name)+1, 
len(file_name) -CHARINDEX('.', file_name ))) ,
cte_2 as (
select date_modified, ext,cnt,RANK()Over(partition by date_modified order by cnt desc) rnk
from 
CTE ) 
select date_modified , STRING_AGG(ext,','),MAX(cnt)
from cte_2
where rnk=1
group by date_modified;

WITH CTE AS (
select date_modified , substring(file_name , CHARINDEX('.',file_name)+1, 
len(file_name) -CHARINDEX('.', file_name )) as ext , count(*) as cnt
from files
group by date_modified , substring(file_name , CHARINDEX('.',file_name)+1, 
len(file_name) -CHARINDEX('.', file_name ))) 
select date_modified, STRING_AGG(ext,',') within group(order by ext) , max(cnt)
from 
CTE C1
where cnt=(select Max(cnt) from cte c2 where c1.date_modified=c2.date_modified)
group by date_modified;

-- Question 9 
create table batch (batch_id varchar(10), quantity integer);
create table orders_t (order_number varchar(10), quantity integer);


insert into batch values ('B1', 5);
insert into batch values ('B2', 12);
insert into batch values ('B3', 8);

insert into orders_t values ('O1', 2);
insert into orders_t values ('O2', 8);
insert into orders_t values ('O3', 2);
insert into orders_t values ('O4', 5);
insert into orders_t values ('O5', 9);
insert into orders_t values ('O6', 5);

select * from batch;
select * from orders_t;
/* what we can do is we can expand both table by recursion and create a row number and then 
use left join keeping the orders table in left and then count it */

with cte_1 as (
select batch_id , quantity as unit
from batch 
union all 
select batch_id ,  unit-1  
from cte_1
where unit >1) , 
Batch_CTE AS (
	select batch_id,1 as unit_in_batch, ROW_NUMBER()over(order by batch_id) as RN_1
	from cte_1
	) , 
		cte_2 as (
		select order_number , quantity as unit
		from orders_t
		union all 
		select order_number,  unit-1  
		from cte_2
		where unit >1) , 
		     order_cte as (
			select order_number,1 as order_Unit, ROW_NUMBER()over(order by order_number) as RN_2
			from cte_2
			)

			select order_number  , batch_id , count(unit_in_batch)
			from order_cte 
			Left Join Batch_CTE
			on order_cte.RN_2=Batch_CTE.RN_1
			Group by order_number  , batch_id
			order by order_number asc , batch_id desc;

