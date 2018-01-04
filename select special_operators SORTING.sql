/*
select 
special operators:
    ||
    ALL|ANY
    IN
    BETWEEN
    LIKE
    IS NULL
Sorting
*/

create table book2 AS (select * from books);
create table customer2 AS (select * from customers);

/* string in SQL is comparable*/
select title from book2 where title > 'HA';

/*in last file, we use ALter..ADD (Virtual COLUMN), we can also select virtual column out*/
select (retail - cost) AS Profit from book2;

/*concatenation*/
select 'profit' || (retail - cost) AS profit from book2;

/*ALL operator*/
select * from customer2 where state <> ALL('CA','FA');

/*ANY operator*/
select * from customer2 where state =  ANY('CA','FA');

/* IN operator */
select * from customer2 where state NOT IN ('CA','FA');

/* Between operator (inclusive)*/
select * from customer2 where state between 'CA' and'FA';

/* Like operator */
select * from customer2 where LASTNAME LIKE 'P%';
select * from customer2 where FIRSTNAME LIKE '%^%' ESCAPE '^'; /*use ESCAPE to escape a character that is put in the front of a wild card charcter.

/* 
SORTING 
we can define several key as sorting key, the  maximum number of sorting key is 255
*/
select * from customer2 order by LastNAME DESC;
select * from customer2 order by 2 DESC, 3 ASC; /*2 represent second column, 3 represent third column*/

/* DISTINCT*/
select DISTINCT(lastname) from customer2;

/* pseudo-columns*/
select ROWNUM,gift from promotion;
/*when we use these pseudo-column, we do not care what table we use.*/
select Sysdate + 30 AS "NEXT MONTH" From Dual;

/* if we have null value in sorting key, we can use NULLs FIRST or NULLs LAST to place these value in the place it supposes to be.
   By default, the value is NULL LAST*/
select ISBN, DISCOUNT from book2 order by DISCOUNT desc NULLs FIRST;

drop table book2;
drop table customer2;