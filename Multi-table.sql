/*
Multiple table queries:
cartesian join
equality join
Non-equality join
Left,Right,Full Join
self-join
*/
create table book2 AS (select * from books);
create table bookauthor2 AS (select * from bookauthor);
create table publisher2 AS (select * from publisher);
create table customers2 AS (select * from customers);
create table orders2 AS (select * from orders);
create table orderitems2 AS (select * from orderitems);

/*cartesian join: seldomly use because of inefficiency*/
select * from book2,Bookauthor2;
select * from book2 cross join Bookauthor2 Order By Pubdate;

/*
for joining n table, we need at least n-1 condition to state the condition between each two tables.
IF NOT! IT will become cartesian join for rest of them.
select * from books,Bookauthor,publisher where books.isbn = bookauthor.isbn; This is an inefficient query. Probably, it is a flaw query. 
*/
select * from book2,Bookauthor2,publisher2 where book2.isbn = bookauthor2.isbn;

/* equality join */
select * from book2,Bookauthor where book2.isbn = bookauthor2.isbn; /*the common column books.ISBN and Bookauthor.ISBN are still there*/
select * from book2 natural join bookauthor2; /* common column will appear only once */

/*
The reason we prefer join ... ON/USING because it makes queries easy to understand. 
Join condition will only appear in join statement, while other condition will 
appear in where. Group condition will appear in Having, etc.,
*/
select * from book2 Join Bookauthor2 USING (ISBN); /* if two table has same column, we can use join using (common column name)*/
select * from book2 Join Publisher2 ON publisher2.pubid = book2.isbn; /* if join columns have different name, we can use Join..ON..*/
/*now lets join multiple tables*/
select * from customers2 Join orders2 using (Customer#)
                         Join Orderitems2 Using (Order#)
                         Join book2 On book2.ISBN = orderitems2.isbn
Order by Lastname,FirstName NULLS First;

/*lets look at outer join*/
select C.customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 C, Orders2 O
Where C.CUSTOMER# = O.CUSTOMER#(+) /* left outer join , (+) means this table may have missing rows, or in other words, more rows*/
Order by C.customer#;

select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left outer join Orders2 Using (CUSTOMER#)
order by customer#;

select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left join Orders2 Using (CUSTOMER#) /*left join works as same as left outer join*/
order by customer#;

/* 
set operations:
UNION union without dulplication
UNION ALL union with dulplication
MINUS 
INTERSET
*/
(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left outer join Orders2 Using (CUSTOMER#))
minus
(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left join Orders2 Using (CUSTOMER#)) /*left join works as same as left outer join*/
order by customer#; /*order should be placed at last*/

(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left outer join Orders2 Using (CUSTOMER#))
union
(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left join Orders2 Using (CUSTOMER#)) /*left join works as same as left outer join*/
order by customer#; /*order should be placed at last*/

(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left outer join Orders2 Using (CUSTOMER#))
union all
(select customer#,lastname || ' ' || firstname AS Name, order# 
From Customers2 Left join Orders2 Using (CUSTOMER#)) /*left join works as same as left outer join*/
order by customer#; /*order should be placed at last*/

drop table book2;
drop table bookauthor2;
drop table publisher2;
drop table customers2;
drop table orders2;
drop table orderitems2;