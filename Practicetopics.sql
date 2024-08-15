-- Recursive and self join ,family tree questions
-- Question  3 
Select emp_tbl.EmployeeID, emp_tbl.FirstName+' '+emp_tbl.LastName as Employeee,manger_tbl.FirstName+' '+ manger_tbl.LastName as manager ,manger_tbl.EmployeeID as Manager_ID from 
Employee3 as emp_tbl
join Employee3 as manger_tbl
on emp_tbl.ManagerID=manger_tbl.EmployeeID;

-- Question 45 How to find all levels of Employee Manager Hierarchy | Recursion
select * from Employees8;
with cte as (
select * from Employees8 e1 where manager_id is null 
union all 
select e1.* 
from Employees8 e1
join  CTE as c 
on e1.manager_id=c.id 
)
select * from CTE ;
-- Hierarchy of manager above david 
with EMP_CTE AS (
select e1.* 
from Employees8 e1
where e1.name='David'
UNION ALL 
Select e1.*
from Employees8 e1
join EMP_CTE as m1
on e1.id=m1.manager_id 
)
select * from EMP_CTE;
--- Important 
select  t2.Name ,
(select','+ t1.Name
from  AdventureWorks2022.Production.ProductSubcategory as t1
where t1.ProductCategoryID= t2.ProductCategoryID
for XML Path(''),TYPE).value('.','varchar(max)')as Product_subCategory
from AdventureWorks2022.Production.ProductCategory as t2;

-- string_agg 
select distinct t1.Name as category  , String_agg(t2.Name,',') as subcategory  
from AdventureWorks2022.Production.ProductCategory  as t1
join AdventureWorks2022.Production.ProductSubcategory  as t2
on t1.ProductCategoryID=t2.ProductCategoryID
group by t1.Name

--FOr XML 
select t1.name ,
stuff((select ','+ t2.name 
from 
AdventureWorks2022.Production.ProductSubcategory t2
where t1.ProductCategoryID= t2.ProductCategoryID
for xml path (''),type).value('.','varchar(max)'),1,1,'')as product_name
from AdventureWorks2022.Production.Productcategory t1