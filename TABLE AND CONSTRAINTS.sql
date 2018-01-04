/*
  Manage tables and constrains
*/

/*create a table with constrains*/
create table test_Mike(
Mike# VARCHAR(10) primary key not null,
Location CHAR(10) not null,
Attribution3 date
);

Insert into test_Mike values ('0000000001','first','10-Jun-1937');
Insert into test_Mike(Mike#,Location) values ('0000000002','second');

select Mike# as Michael#,location as location_change, ATTRIBUTION3 as Attr from TEST_MIKE;
select Mike#,location ||' Hello '||location as Attr from test_Mike;

Alter Table test_Mike Add (newColumn_Added varchar(10));
select * from test_Mike;

Alter Table test_Mike Modify (newColumn_Added varchar(30) default 'This is default');
select * from test_Mike; /*you cannot affect the rows which have being exist in the table*/

/* 
   you can drop the column by using DROP, this is a slow process for a big table
   It is good practice to use SET UNUSED and then use DROP UNUSED COLUMNS! You can manage the database in a particular time and drop these unused columns
   Also, these columns are still there. You can enable them at any time you want
*/

Alter Table test_Mike set UNUSED (newColumn_Added);
select * from test_Mike;
Alter Table test_Mike DROP UNUSED COLUMNS; /*this will drop all unused columns*/
select * from test_Mike;
Alter Table test_Mike ADD (newColumn_Added2 varchar(20) default 'This is default');
select * from test_Mike;
Alter Table test_Mike Drop COLUMN newColumn_Added2;
select * from test_Mike;

/*Rename Table and Column*/
Rename test_Mike to test_Mike2;
select * from test_Mike2;
ALter Table test_Mike2 Rename Column ATTRIBUTION3 TO ATTR3;
select * from test_Mike2;

/* drop a table*/
drop table test_mike2;



/*
*
*Start looking at constrains, focusing mainly on table - level constraints
*
*/
Create Table constraint_Table(
ISBN varchar(20),
TNAME varchar(4), 
Curr_Time Date,
pubID Number(2,0),
pubID2 Number(2,0),
/*set primary key*/
constraint pk_constraint_Name primary key(ISBN,TNAME),
/*
set foreign key.
ON DELETE NO ACTION (by default)
ON DELETE SET NULL: when the parent table is deleted, all references become null
ON DELETE CASCADE: when the parent table is deleted, all references are deleted
*/
constraint fk_constraint_Name foreign key(pubID) REFERENCES publisher(pubID) ON DELETE SET NULL,
constraint fk2_constraint_Name foreign key(pubID2) REFERENCES publisher(pubID) ON DELETE CASCADE,

/*we can add check constraints to check a specific condition*/
constraint ck_constraint_Name CHECK (Curr_Time >= '3-Jan-2017')
);

/* add constraints after the table created*/
Alter table constraint_Table ADD Constraint cks_constraint_Name CHECK (Curr_Time<='30-Jan-2017');
Alter table constraint_Table ADD Constraint unique_constraint_Name UNIQUE(Curr_Time);

/* delete constraints after the table created*/
Alter table constraint_Table DROP Constraint cks_constraint_Name;

/* What's more we can enable/disable each constraint*/
Alter table constraint_Table Disable CONSTRAINT pk_constraint_Name;
Alter table constraint_Table ENABLE CONSTRAINT pk_constraint_Name;
Drop table constraint_Table;

/* 
multi-column constrains
Notice: in this case, the constraint can not be removed directly since there is no constraint name 
*/
create table constraint_Table_multi (
pk Number(3) Primary key,
fk Number(3) References constraint_Table_multi(pk),
atr1 Number(7),
atr2 Number(7),
/* 
this is a multi-column constraint
we cannot drop the atr1 because it is in the constraint
*/
Constraint multi_column_Constrain CHECK(pk>0 and atr1 <10) 
); 

/*we can use drop casecade constraints to drop column*/
Alter table constraint_Table_multi drop (pk) Cascade Constraints; /*the relevant constraints are droped*/ 
select * from constraint_Table_multi;
/*since no constraint there, we can drop atr1 in sequence*/
Alter table constraint_Table_multi drop (atr1) Cascade Constraints;
DROP TABLE constraint_Table_multi;
/* if we drop all related colums in all constraints, there is no need to use casecade constraints*/
create table constraint_Table_multi (
pk Number(3) Primary key,
fk Number(3) References constraint_Table_multi(pk),
atr1 Number(7),
atr2 Number(7),
Constraint multi_column_Constrain CHECK(pk>0 and atr1 <10) 
); 
ALTER TABLE constraint_Table_multi DROP (pk,atr1,fk);
select * from constraint_Table_multi;
Drop TABLE constraint_Table_multi;