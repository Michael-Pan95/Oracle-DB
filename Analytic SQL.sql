/*
    Analytic SQL
    1. Ranking Funtion: row_Number,Rank,Dense_Rank,(percent_rank,cume_rank),NTILT,PERCENT_RANK
    2. Partitioning and Windowing
    3. Windowing Function: FIRST,LAST,LAG and LEAD (LAG/LEAD is almost the same as you use first/last + over + rows between, except lag and lead will generate null values)
    4. Moving average application
    
    partition: divide result set into subsets
    
    Not allow in where and having
*/
--Rank sales of books (i.e., product type 1) by different employees for January of 2003
select Emp_id,First_Name || ' ' || Last_Name "Name",amount,Rank() over (Order by amount DESC) AS RANK
from Employees2 join ALL_sales on Employees2.Employee_Id = All_Sales.Emp_Id
where All_Sales.Prd_Type_Id = 1
      and
      Month = 1
      and
      Year = 2003;

--Rank sales of books (i.e., product type 1) for Steve Green (ID = 21) for year 2003
select Row_Number() over (order by amount desc), amount,month
from ALL_sales join Employees2 on  Employees2.Employee_Id = All_Sales.Emp_Id
where Employees2.Employee_Id = 21 and All_Sales.Prd_Type_Id = 1;

--Rank sales of different product types for employee Steve Green (ID = 21) for August 2003
select Row_Number() over (order by Amount desc NULLS last),name,amount
from ALL_sales join Product_Types on All_Sales.Prd_Type_Id = Product_Types.Product_Type_Id
where month = 8 and year =2003 and All_Sales.Emp_Id  = 21;
--rank() ranks tie values same, and skip rank number 
select Rank() over (order by Amount desc NULLS last),name,amount
from ALL_sales join Product_Types on All_Sales.Prd_Type_Id = Product_Types.Product_Type_Id
where month = 8 and year =2003 and All_Sales.Emp_Id  = 21;
--Dense Rank ranks tie values same, but does not skip the rank number
select Dense_rank() over (order by Amount desc NULLS last),name,amount
from ALL_sales join Product_Types on All_Sales.Prd_Type_Id = Product_Types.Product_Type_Id
where month = 8 and year =2003 and All_Sales.Emp_Id  = 21;


--Find the top 5 monthly sales in 2003 by Steve Green. List the month as well as the product type.
select * from(
select Name product_name,amount,month,Rank() over (order by amount desc) AS rank
from all_sales join Product_Types on Product_Types.Product_Type_Id = All_Sales.Prd_Type_Id
where Year = 2003 and Emp_Id= 21 and amount is not null)
where rank<=5;

--NTILE is to split the whole part into N
select NTILE(2) over (order by Amount desc NULLS last),name,amount
from ALL_sales join Product_Types on All_Sales.Prd_Type_Id = Product_Types.Product_Type_Id
where month = 8 and year =2003 and All_Sales.Emp_Id  = 21;

/*
    The CIO plans to give a bonus of $10,000 to each
    employee in the top quarter of sales and bonus of
    $5,000 to each employee in the second quarter of
    sales. He wants to study the performance of
    employees based on their overall sales in 2003.
    He wants to know to which ¡°quarter¡± of sales
    amount each employee belongs to.
*/

select employee_id,First_Name || ' ' || Last_Name EMP_Name,SUM(amount),
        NTILE(4) over (order by SUM(amount) desc nulls last) "Quarter",
        CASE NTILE(4) over (order by SUM(amount) desc nulls last) when 1 then 10000 when 2 then 5000 else 0 END AS "Bonus"
from ALL_Sales join Employees2 on ALL_Sales.emp_id = employees2.employee_id
where year = 2003
Group by employee_id,First_Name || ' ' || Last_Name;


/*
    Display the salary of each employee in each division
    of the company.job title, total number of employees in 
    the division, and the ranks of employees within division
    based on their salary (highest salary should receive rank #1).
*/
Select  Divisions.Name,
        Jobs.Name,
        First_Name || ' ' || Last_Name EMP_NAME,Round(Salary,2), 
        Rank() over (Partition by Divisions.Division_Id Order by Salary desc NullS Last) RANKS,
        Count(*) over (Partition by Divisions.Division_Id) "Total"
from employees2 join jobs ON Jobs.Job_ID = Employees2.Job_Id
                join Divisions ON Employees2.Division_Id = Divisions.Division_Id;

--partition the sales rank by month                
select month, Name, sum(amount),Rank() over (partition by month order by sum(amount) NULLS LAST) RANK
from All_sales join product_types on Product_Types.Product_Type_Id = All_Sales.Prd_Type_Id
where amount is not null
Group by month,name;

/*
    Calculate accummulating value, we use Windowing function
*/
--Compute acumulative sales amount for 2003 starting with June and ending with December
select month,mon_sum, SUM(mon_sum) over 
        (order by month Rows between UNBOUNDED PRECEDING AND CURRENT ROW) ACCUMU_AMOUNT
from (select month, sum(amount) mon_sum
from all_sales
where year = 2003 and amount is not null
Group by month);

--display the previous and last month value
select month,mon_sum,
      First_Value(mon_sum) over (order by month Rows between 1 preceding and 1 following),
      Last_Value(mon_sum) over (order by month Rows between 1 preceding and 1 following)
From (select month, sum(amount) mon_sum
from all_sales
where year = 2003 and amount is not null
Group by month);

--For each sales employee find the difference between the highest sales and the sales of other product types in January 2003
--solution 1:
select Employees2.Employee_Id ID,Product_Types.Product_Type_Id TYPE, sum(amount) sum_amount, 
        Max(sum(amount)) over (partition by Employees2.Employee_Id order by Employees2.Employee_Id) - sum(amount) "Difference"
from product_Types join all_sales on All_Sales.Prd_Type_Id = Product_Types.Product_Type_Id
                   join Employees2 on Employees2.Employee_Id = All_Sales.Emp_Id
where amount is not null and  year =2003 and month =1
Group by Product_Types.Product_Type_Id, Employees2.Employee_Id;

--solution 2:
select first_name || ' ' || last_name "Employee", name,
        (first_value(amount) over (partition by emp_id order by amount DESC NULLS LAST) - amount) AS Difference
from all_sales JOIN employees2 ON employee_ID = emp_ID
               JOIN product_types ON prd_type_id = product_type_ID
where amount is not null and  year =2003 and month =1
Order by emp_id,difference;

--LAG and LEAD
select month,mon_sum,
        Lag(mon_sum,1) over (order by mon_sum DESC NULLS LAST),
        Lead(mon_SUM,1) over (order by mon_sum DESC NULLS LAST)
from (
    select month,SUM(Amount)mon_sum
    from ALL_Sales
    Group by month);

--Calculate the moving average on sales in 2003
select month,mon_sum,
        ROUND(AVG(mon_SUM) over (order by month Rows between 1 preceding and 1 following),2) "MOVING_AVG(3)",
        ROUND(AVG(mon_SUM) over (order by month Rows between 2 preceding and 2 following),2) "MOVING_AVG(5)"
from (
    select month,SUM(Amount)mon_sum
    from ALL_Sales
    where year =2003
    Group by month);