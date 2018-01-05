/*
    View Sequence and Category
    
    view can immediately affect base data(except with read only, with check option), index cant
    
    Mutually exclusive constraints:
    with read only : no dml can be used on the view
    with check option: only date retrieved by the definition query can be modified
    
    when we create index:
        1. large range of value in a column
        2. lots of null values 
        3. frequently used in where statement
        4. few rows are retrieved
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

create or replace view view2
AS
select * from books
where category = 'COMPUTER'
with check option
Constraint view2_check_option;

drop view view1;
drop view view2;
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

/*
    Category:
        user category
        all category
        dbm category
*/
-- return the definition of the table
describe books;

--A predefine view named DICTIONARY containing all views in the system category
describe dictionary;
select Table_name from dictionary where table_name like '%USER%';

--user_tables contain the user's own relational tables
select * from User_tables;

--user_tab_columns store column name, data type etc (all definable parts in create table clause)
select * from user_tab_columns where table_name = 'BOOKS';

--user view: store view name and definition (queries)
select View_name,TEXT from user_views;

/*
    --user_constrains: constrain definition
    --user_cons_columns: column that are specified in constraints
    C – Check or NN; P – Primary Key; R – Foreign Key; U – Unique;
    V – With Check option; O – Read Only option
*/
select * from user_constraints order by table_name;
select * from user_cons_columns order by table_name;

/*
    Comment on table table_name IS 'description'
    we can see the comment in user_Tab_comment, user_col_comments
    No way to drop comment. Only thing we can do is to use blank string to replace comment
*/
Comment on table books IS 'This is my new comment';
select * from user_tab_comments where Table_Name = 'BOOKS';
Comment on table books IS '';
