/* 
DATA manipulation and transaction
*/

create table data_table(
pk number(2,0) primary key,
fk number(2,0) references data_table(pk),
attr1 varchar(10),
attr2 varchar(10)
);

/* 
insert can be used to insert 1 row of data
*/
INSERT INTO data_table VALUES(1,1,null,null);/*this is in EXPLICT METHOD, we do not state columns specifically. we insert value in default order.*/
INSERT INTO data_table(pk,fk) VALUES(2,1); /* this is in IMPLICIT METHOD, we specify columns and then insert value*/
/*we can also use queries to insert data*/
INSERT INTO data_table VALUES(3,(select fk from data_table where rownum = 1),null,null);
select * from data_table;
drop table data_table;

/* we can create table by using result from the queries*/
CREATE TABLE books2 AS (select * from books);
select * from books2;

/*we create virtual column (this is another example using queries to create somthing)*/
Alter table books2 ADD (EARN AS (RETAIL - COST));

/*we will update table. with/without default value*/
Alter table books2 MODIFY (COST default 100);
/*
 Notice: update operation disallow virtual columns
 Update books2 set EARN = 10 WHERE EARN >=30; This is false queries.
 the same setting default value for virtual columns:
 Alter table books2 MODIFY (EARN NUMBER(5,2) default 100); This is not allowed.
 */
Update books2 set Retail =50 where cost > Retail * 0.5;
Update books2 set COST = default where rownum = 1; /*assign the first line cost default value*/

/*we try to delete some data*/
DELETE from books2 where RETAIL = 50 and cost <10;
Drop table books2;

/* 
now we are focusing on the Transaction Control
The TC will end when:
    1. DDL or DCL
    2. commit/rollback
    3. close db
The commit will be processed when:
    1. use commit command
    2. DDL or DCL
    3. close db
    4. auto commit is on
Rollback can recover to a specific savepoint (By default, the begining of this transaction)

COMMIT,ROLLBACK,SAVEPOINT examples
*/
create table simple_table(
pk number(5,0) primary key,
fk number(5,0) references simple_table(pk),
attr1 varchar(10)
);

Insert into simple_table values(1,1,'Hello');
Insert into simple_table values(2,1,'Hey');
SavePoint a;
select * from simple_table;
Insert into simple_table values(3,1,'Hey2');
select * from simple_table;
ROLLBACK to a; /*every change after a will be ignored*/
select * from simple_table;
ROLLBACK;/*this will roll back to the moment when the table is first created(DDL)*/
select * from simple_table;
Insert into simple_table values(3,1,'Hey2');
COMMIT;/*if we commit, all other rollback points are deleted and a new default one will be created now*/
drop table simple_table;/*this DDL will delete all savepoints because it is a DDL*/


