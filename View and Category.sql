/*
    View and Category
    
    view can immediately affect base data(except with read only), index cant
*/

--create a view 
create or replace view ChildrenBook
AS 
select * from books where Lower(category) = 'children';

select * from ChildrenBook;

--modifying data in ChildrenBook will change the base table data. Base table data change will immidiated reflect on the view
Update ChildrenBook 
set title = 'add' 
where ROWNUM <= 1;

select * from Books where title = 'add';
Rollback;
Drop view ChildrenBook;

--create a read-only view
create or replace view view1
AS
select * from books
with read only
constraint view1_read_only;

drop view view1;

--create index
create index customer_name
On customers(Firstname,Lastname);

drop index customer_name;

/*
    sequence can generate numbers
    CREATE SEQUENCE sequencename
    [INCREMENT BY value]
    [START WITH value]
    [{MAXVALUE value | NOMAXVALUE}]
    [{MINVALUE value | NOMINVALUE}]
    [{CYCLE | NOCYCLE}]
    [{ORDER | NOORDER}]
    [{CACHE value | NOCACHE}];
    
    nextval,currval to get value
*/
Create sequence mikefirstsq
increment by 10
start with 1
Maxvalue 100
Minvalue 0
cycle
noorder
nocache;

select mikefirstsq.nextval,mikefirstsq.currval from dual;
select mikefirstsq.nextval from dual;
select mikefirstsq.currval from dual;

--Modify sequence
/*
    You cannot modify the start value
    You cannot modify the minvalue to a smaller value than currentvalue
    you cannot modify order or not
    
*/
ALter sequence mikefirstsq
 increment by 17
 Maxvalue 131
 Minvalue 0;

drop sequence mikefirstsq;

--creat synonyms
create  public synonym bk for books;
create  synonym cs for customers; -- default is private
select * from bk;
select * from cs;
drop public synonym bk;
drop synonym cs;