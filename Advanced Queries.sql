/*
advanced queries
    1. grouping set
    2. rollup
    3. cube
    4. decode + case
    5. pivoting a table
    6. Hierachical Queries
*/

/*
    Grouping SET
--List publisher name,book category, number of books published and average book price
    --For each category
    --For each publisher
    --For each publisher with each category
--Solution 1: (we write a lot of duplicate queries. only difference is the group by function.)
--Purpose here is to inspect data in different category
*/
select Name,category,count(ISBN) "number of books",Round(AVG(retail),2) "Average book price"
From Books natural join Publisher
Group by name,category

UNION ALL 

select Name,NULL,count(ISBN) "number of books",Round(AVG(retail),2) "Average book price"
From Books natural join Publisher
Group by name

UNION ALL

select NULL,Category,count(ISBN) "number of books",Round(AVG(retail),2) "Average book price"
From Books natural join Publisher
Group by category;

--solution 2: precise query but it works as slow as the above one! ?_?
-- Group by Grouping SET() is used when we inspect data in different categories
select Name,Category,count(ISBN) "number of books",Round(AVG(retail),2) "Average book price"
From Books join publisher using (pubid)
Group by Grouping SETS((name,category),name,category,()); -- () means we do not need any group, do it in total

/* 
    roll-up(a,b) = Grouping set((a,b),a,())
    
    For each region and state, provide number of orders and the total profit generated
    from sales. Provide the aggregated values for each region. ALso provide the total 
    number of orders and overall profit.
*/
select * from orders;
--solution 1:
select Region "Region",NULL "state",count(order#) "Number of Orders", TO_CHAR(SUM((paideach-cost)*quantity),'$999.99') "Total Profit"
from orders join Orderitems using (Order#)
            join Books using (ISBN)
            join Customers using (CUSTOMER#)
Group by Region

UNION ALL

select region,state,count(order#) "Number of Orders", TO_CHAR(SUM((paideach-cost)*quantity),'$999.99') "Total Profit"
from orders join Orderitems using (Order#)
            join Books using (ISBN)
            join Customers using (CUSTOMER#)
Group by region,state
order by 1,2;

--solution 2:
select region,state,count(order#) "Number of Orders", TO_CHAR(SUM((paideach-cost)*quantity),'$999.99') "Total Profit"
from orders join Orderitems using (Order#)
            join Books using (ISBN)
            join customers using (customer#)
Group by Rollup(region,state)
Order by 1,2;

/*
    CUBE(a,b,c) = Grouping SET((a,b,c),(a,b),(a,c),(b,c),a,b,c,())
    
    For each order,publisher and category, list publisher's name,category,month of the order(Month and Year together)
    number of books and the average price for each of the groups identified by the order, publisher and category
    
    provide aggregate values for combination of all 3 'columns', for any two 'columns', any single 'column' and grand total
*/
--solution:
select name,category,TO_CHAR(orderdate,'mm - yy') "Month of the order",TO_CHAR(AVG(retail),'$99.99') "Average Price", count(ISBN) "# of books"
from publisher join books using (pubID)
               join Orderitems using (ISBN)
               join Orders using (Order#)
Group By CUBE(name,category,TO_CHAR(orderdate,'mm - yy'))
Order by 1,2,3;



/*
    DECODE(Obj,condition1,value1,condition2,value2,.....) like a switch in jave
    
    we will levy tax in Florida and California Only. Create a table with the tax rate
*/
select Customer#,state, Decode(state,'FL',0.38,'CA',0.55) AS "TAX Rate" from customers;


/*
    CASE : like IF..ELse
    
    we will levy tax in Florida and California Only. Create a table with the tax rate
*/
select Customer#, state,
    case state
        when 'CA' Then 0.55
        When 'FL' Then 0.38
    End AS "TAX Rate"
From customers;


/*
    Hirarchical Queries
    
    for a company, which has a employee table containing employee_no and manager_no
    how to display this relationship properly?
*/

select employee_ID,Manager_Id,First_Name,Last_Name,Department_Id
from HR.Employees
Start with employee_ID = 100
Connect By Prior Employee_Id = Manager_Id;

--we want to select all the employees whose are the subordinates of 101 and 102
select employee_ID,Manager_Id,First_Name,Last_Name,Department_Id
from HR.Employees
Start with employee_ID = 101 or employee_ID = 102
Connect By Prior Employee_Id = Manager_Id;

--we want to select all employees from the bottom to the top (we know from the bottom, there are only 206,107,113)
select employee_ID,Manager_Id,First_Name,Last_Name,Department_Id
from HR.Employees
Start with employee_ID in (206,107,113)
Connect By Prior Manager_Id = Employee_Id;

--we want to select all employees whose level is higher or equal to 101 and 102
select employee_ID,Manager_Id,First_Name,Last_Name,Department_Id
from HR.Employees
Start with employee_ID = 100
Connect By Prior Employee_Id = Manager_Id
                 AND
                 Employee_Id <> 101
                 AND
                 Employee_ID <> 102;

--we want to select employees whose department is 60
select employee_ID,Manager_Id,First_Name,Last_Name,Department_Id
from HR.Employees
where Department_Id = 60
Start with employee_ID = 100 --even we start the hirarchy with 100, because of the Where Clause, these data has been filtered
Connect By Prior Employee_Id = Manager_Id;