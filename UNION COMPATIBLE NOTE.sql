/*
test for union with same domain but different logical meaning'
CONCLUSION: the only constraint in the uion is data type, the meaning of data is not counted
*/

create table only4test(
ID number(6) primary key,
Name VARCHAR(20)
);

create table only4test2(
ID number(6),
Code VARCHAR(20)
);

INSERT  Into only4test values(123,'name1');
Insert into only4test2 values(321,'name2');

select * from ONLY4TEST2
union
select * from ONLY4TEST;

drop table only4test;
drop table only4test2;