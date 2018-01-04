/*
    Regular expression:
    
    Regexp_Like(X,pattern[,match_option]), 
        match_option - 'i' - case insensitive, 'c' - case sensitive (default)
    
    Regexp_Instr(X, pattern [,start[,occurrence [,return_option,[,match_option]]]]) 
        start 每 position to begin the search;
        occurrence 每 which occurrence of the pattern to consider
        return_option 每 what position to return
            0 每 position of the beginning of the pattern
            1 每 position after the end of the pattern
        match_option 每 same as before
        
    Regexp_Substr(X, pattern [,start[,occurrence [,match_option]]]]) 
        start 每 position to begin the search
        occurrence 每 which occurrence of the pattern to return
        match_option 每 same as before
        
    Regexp_Replace(X, pattern[,replace_string [,start[,occurrence [,match_option]]]])
        replace_string 每 string that replaces the string matching the pattern
        start 每 position to begin the search
        occurrence 每 which occurrence of the pattern to replace
        match_option 每 same as before
        
    Regexp_Count(X, pattern [,start[,match_option]])
        start 每 position to begin the search
        match_option 每 same as before
        
    . any character
    [char] Match single char
    [^char] Not in char list
    \n nth sub-expression
    () define sub-expression
    ^ begining
    $ tailing
    \ escape symbol
    ? 0/1 times
    * 0+ times
    {n} exactly n times
    {n,m} n<=t<=m
    {n,} n<=t
    [:alpha:] 
    [:lower:]
    [:upper:]
    [:digit:]
    [:alnum:]
    {:punct:}
*/

--reason why we need seperate funtion to use regex is to simplify the clause
--one without specific function
select * from Books
where category LIKE 'C%' or category LIKE 'B%';
--one with specific regular function
select * from Books
where regexp_Like(category,'^C|^B');

--add checking constrains using regular expression
Alter Table publisher 
ADD Constraint publisher_phone_ck
Check (REGEXP_LIKE(phone,'^([[:digit:]]{3}-[[:digit:]]{3}-[[:digit:]]{4}|[[:digit:]]{10})$'));

--We need to contact used books＊ dealers. Find out the phone number that is contained in the description column in the suppliers table.
select * from suppliers 
where REGEXP_Like(Description,'[0-9]{3}[-.][0-9]{4}');

--List the dealer name and the position of the phonenumber in the description
select sup_name, REGEXP_INSTR(description,'[0-9]{3}[-.][0-9]{4}') "Position of phone number"
from Suppliers;

--List the names of used books＊ dealers and their phone numbers
select * from Suppliers;
select sup_name, REGEXP_SUBSTR(description,'[0-9]{3}[-.][0-9]{3}[.-][0-9]{4}|[0-9]{3}[-.][0-9]{4}') "Phone-number",description
from suppliers;

--List the names of used books＊ dealers and their phone numbers for wholesale book dealers
--solution 1:
select sup_name, REGEXP_SUBSTR(description,'[0-9]{3}[-.][0-9]{3}[.-][0-9]{4}|[0-9]{3}[-.][0-9]{4}') "Phone-number",description
from suppliers
where REGEXP_LIKE(Description,'whol.{0,3}sale');

--Replace ＆.＊ (the period) used in the phone number in the description column with a ＆-＊
--To keep orginal table available, We use new table to do the replacement
drop table suppliers2;
create table suppliers2 AS (select * from Suppliers);
select REGEXP_Replace(description,'[.]','[-]',REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1)),REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1),REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1,1)
from suppliers2
where REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1) > 0;
--but the query above will replace all the dot with slash after the phone number. Take the following queries as example.
Update suppliers2 set Description = 'Used book chain, located in Canada, large volume of sales, 888.555.5204. I love you.' where Sup_Name = 'Book Recyclers';
select REGEXP_Replace(description,'[.]','[-]',REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1)),REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1),REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1,1)
from suppliers2
where REGEXP_INSTR(description,'[-.][0-9]{3,4}',1,1) > 0;

--How many times two consecutive identical letters (e.g., ＆oo＊,＆tt＊ etc.) are represented in the description of the supplier(s) from Seattle.List the first and last Match letters
select description,Regexp_Count(description, '([a-z])\1',1,'i')"count" 
,substr(description,REGEXP_INSTR(description,'([a-z])\1',1,1,0,'i'),REGEXP_INSTR(description,'([a-z])\1',1,1,1,'i')-REGEXP_INSTR(description,'([a-z])\1',1,1,0,'i'))"First Match"
,substr(description,REGEXP_INSTR(description,'([a-z])\1',1,Regexp_Count(description, '([a-z])\1',1,'i'),0,'i'),REGEXP_INSTR(description,'([a-z])\1',1,Regexp_Count(description, '([a-z])\1',1,'i'),1,'i')-REGEXP_INSTR(description,'([a-z])\1',1,Regexp_Count(description, '([a-z])\1',1,'i'),0,'i'))"Last Match"
,REGEXP_INSTR(description,'([a-z])\1',1,1,0,'i') "first start position"
,REGEXP_INSTR(description,'([a-z])\1',1,1,1,'i') "first end position"
,REGEXP_INSTR(description,'([a-z])\1',1,Regexp_Count(description, '([a-z])\1',1,'i'),0,'i') "last start position"
,REGEXP_INSTR(description,'([a-z])\1',1,Regexp_Count(description, '([a-z])\1',1,'i'),1,'i') "last start position"
from suppliers2
where REGEXP_INSTR(description,'.{2}',1,1,0)>0;

--List the contact information by providing the first name of the contact and then the last name of the contact
select regexp_replace(name,'(.*),(.*),(.*)','\2 \1 Phone NO.,\3') "Result" from Contacts;

