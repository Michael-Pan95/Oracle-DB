/*
    Subqueries
    
    
*/

--select all computer books which price is higher than Database Implementation.
select ISBN,title,cost from
books
where LOWER(category) = 'computer'
      AND
      cost >(select cost from books where Title = UPPER('Database Implementation'));

--compare price of each book against average price of all books and need to find different between the price and average
select ISBN,Title,TO_CHAR(retail - (select avg(retail) from books),'$99.99') "price difference"
from books;

--which book has retail price above median retail price?
select ISBN,TITLE,retail
from books,(select Median(retail) X from books)
where retail > X;

--List title,retail price, and category of books with the retail price matching the maximum retail price of books in each category

--solution 1:
select title,retail,Category
from books join (select category ,MAX(retail) "MAXPRICE" from books Group by category) using (Category)
where retail = MAXPRICE;

--solution 2: this solution is risky if two category happen to have same maximum price, which is highly possible when the data volume is huge
select title,retail,Books.Category
from books
where retail in (select Max(retail) from books Group by category);

--find the title of book having a retail price greater than the retail price of all books in the cooking category
--Skip the same solution that uses natural join to append a new column and then do the selction clause.
--solution 2:
select title,retail 
from books
where retail > ALL(select retail from books where lower(category) = 'cooking'); -- retail > (select Max(retail)from books where lower(category) = 'cooking') ALso works

--Which order has a total less than the total of all individual orders placed by customers from Florida
--solution 2:
select order#,TO_CHAR(sum(quantity*paideach),'$999.99')
from Orderitems
Group by order#
Having sum(quantity*paideach) > ALL (select sum(quantity*paideach) from Orders join Orderitems Using(Order#) Join Customers Using(Customer#) where State = 'FL' Group by order#);

/* 
    multi-column
    (col_a,col_b) in (select ...)
*/
--List most expensive books in each category
--solution:
select title,retail,category
from books
where (category,retail) in (select category,Max(retail) from books Group by category);

--List all books with higher than average price of each category
--solution:
select category,title,retail,"Average Price"
from books join (select category,Avg(retail) "Average Price" from books group by category) using (category)
where retail > "Average Price"
Order by category;

/*
    Correlated subquery
    
    Exist
*/
--List order number and customer number for orders placed on March 31 2009 that included a book with ISBN = 8843172113
--solution 1:
select distinct order#,customer#
from orders join customers using (customer#)
           join Orderitems using (Order#)
           join books using (ISBN)
where ISBN = 8843172113
      AND
      orderdate = TO_DATE('March 31 2009','Month dd YYYY');

--solution 2:
select order#,customer#
from orders O
where orderdate = TO_DATE('March 31 2009','Month dd YYYY')
      AND
      Exists (select * 
              from orderitems 
              where isbn = 8843172113
              and 
              orderitems.order# = O.order# -- use identify O to represent the filtered result after where and then join two tables.
             );

/*
    Connect by
*/
--List consecutive Sundays starting with 08-Mar 2015
--solution 1:(only shows next sunday)
select distinct Next_Day(SYSDATE,'Sunday') from customers;
--solution 2:(show as many sunday as you want)
select Next_Day(SYSDATE,'Sunday') + ((level-1)*7) "Sunday"
From SYS.Dual
connect by level <=5;

--List name of months that are between 2 given dates
--before doing this, we do some review
select Add_Months(SYSDATE,1) from dual; -- ADD_Month(original date, interval) result: orgin + interval
select Months_Between(SYSDATE,1) from dual; --Months_Between(date1,date2) return the interval between two date in unit of month

select To_CHAR(ADD_Months(date '2015-03-23',level-1),'Month') AS "Month"
From dual
Connect by level <= Months_Between(Trunc(Date '2015-08-31','MM'),Trunc(Date '2017-03-31','MM')+1);

