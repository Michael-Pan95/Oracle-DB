/*
single row function:
    1.character function
        1.1. UPPER,LOWER,INICAP
        1.2. SUBSTR,INSTR,LENGTH,LPAD,LTRIM,REPLACE
    2.date function
        2.1. ADD_MONTH, NEXT_DAY
    3.Numerical function
        3.1. ROUND, TRUNC
    4.Conversion function
        4.1. TO_DATE, TO_CHAR, TO_NUMBER
    5.Function involving NULL value
        5.1. NLV, NLV2
*/

select UPPER('mICHaEl') from dual; -- UPPER return all chars with uppercase
select LOWER('MIChael') from dual; -- LOWER return all chars with lowercase
select Initcap('MIchael PAn') from dual; -- INITCAP not only captilize the first letter, it will also lowercase the rest letters/
select MAX(LENGTH(address)) from customers; -- LENGTH returns the number of characters
select DISTINCT SUBSTR(FIRSTNAME,2,4), FIRSTNAME from customers; --SUBSTR(column_name, start position(start from 1),output_length)
/*
INSTR(column_name,target_string/number,start position(exclusive),appearance times(e.g. 2 for second appearance))
it returns the target character position from the starting point.
return 0 if not found
*/
select INSTR(address,'A', 2, 2) "Instring",address from customers; 
/*
 LPAD/RPAD(String,total_length,padding symbol)
 It is to create a string with certain length.
 If the total length is less than original string
 The output is a substring of original string
*/
select Lpad(Firstname,12,' ') || Lpad(Lastname,12,'*') "Lpad Name", firstname, lastname from customers; 

/*
RTRIM(original_string, target_string) it will trim the target string from the right
if second parameter is omitted, it will trim all trailing spaces
*/
select DISTINCT RTRIM('Michael         ') || 'result' "result "from customers;
select DISTINCT RTRIM('2.182818281828','1828') "result",'2.182818281828' "Origin Data" from customers;
select DISTINCT RTRIM('2.182818281828','828') AS "result",'2.182818281828' "Origin Data" from customers;
select LTRIM(address,'P.O. BOX%'),address from customers where address LIKE 'P.O. BOX %';
select RTRIM(UPPER(firstname || ' ' || lastname),'ON') result,firstname || ' ' || lastname "Name" from customers; 

select DISTINCT REPLACE('Michael, cool~','c','CCC') from customers; -- replace(ori_str,target_str,replace_str)

/*
date function
*/
select DISTINCT Months_Between('3-Jan-2017','2-Jan-2017') from customers; -- return the month ratio between two date.
select DISTINCT NEXT_DAY(SYSDATE,'Monday') from customers; -- return next Monday
select DISTINCT LAST_DAY(SYSDATE) from customers; --return the day of the last day of the months that contains date
select DISTINCT EXTRACT(YEAR from SYSDATE) "YEAR", EXTRACT(Month from SYSDATE) "Month",EXTRACT(Day from SYSDATE) "Day",SYSDATE from customers; -- extract day,month or year from a date
select DISTINCT SYSDATE + 2 from customers;--add 2 days
select DISTINCT SYSDATE - TO_DATE('01-DEC-1999') from customers; -- return the number of days between two dates


/*
numerical function
*/
select DISTINCT ROUND(3.1415926,5) from customers; -- round the number
select DISTINCT ROUND(SYSDATE,'MONTH') from customers; -- round the date to the closest 'Month'/'Year'
select DISTINCT ROUND(TO_DATE('01-OCT-2034'),'Year') from customers;-- round the date to the closest 'Month'/'Year'
select DISTINCT TRUNC(113.1415926,-1) from customers; --trunc(num,position of digit(can be negative))
select DISTINCT TRUNC(13.1415926,4) from customers; --trunc(num,position of digit(can be negative))

/*
convertion
*/
/*
format includes:
    YEAR	Year, spelled out
    YYYY	4-digit year
    YYY
    YY
    Y	Last 3, 2, or 1 digit(s) of year.
    IYY
    IY
    I	Last 3, 2, or 1 digit(s) of ISO year.
    IYYY	4-digit year based on the ISO standard
    RRRR	Accepts a 2-digit year and returns a 4-digit year.
    A value between 0-49 will return a 20xx year.
    A value between 50-99 will return a 19xx year.
    Q	Quarter of year (1, 2, 3, 4; JAN-MAR = 1).
    MM	Month (01-12; JAN = 01).
    MON	Abbreviated name of month.
    MONTH	Name of month, padded with blanks to length of 9 characters.
    RM	Roman numeral month (I-XII; JAN = I).
    WW	Week of year (1-53) where week 1 starts on the first day of the year and continues to the seventh day of the year.
    W	Week of month (1-5) where week 1 starts on the first day of the month and ends on the seventh.
    IW	Week of year (1-52 or 1-53) based on the ISO standard.
    D	Day of week (1-7).
    DAY	Name of day.
    DD	Day of month (1-31).
    DDD	Day of year (1-366).
    DY	Abbreviated name of day.
    J	Julian day; the number of days since January 1, 4712 BC.
    HH	Hour of day (1-12).
    HH12	Hour of day (1-12).
    HH24	Hour of day (0-23).
    MI	Minute (0-59).
    SS	Second (0-59).
    SSSSS	Seconds past midnight (0-86399).
    AM, A.M., PM, or P.M.	Meridian indicator
    AD or A.D	AD indicator
    BC or B.C.	BC indicator
    TZD	Daylight savings information. For example, 'PST'
    TZH	Time zone hour.
    TZM	Time zone minute.
    TZR	Time zone region.
*/
select DISTINCT TO_DATE('March 09 2017','MONTH DD YYYY') from customers;--TO_DATE(date string,format_string)

select DISTINCT TO_CHAR(123),TO_CHAR(SYSDATE,'MM DD YY') from customers; -- TO_CHAR(number) return string, TO_CHAR(DATE,FORMAT) return a string of date following format

select DISTINCT TO_NUMBER(TO_CHAR(SYSDATE,'yy')) from customers;-- TO_CHAR(varchar) return number

/*
NULL value:
result of NUNLL value comparision is 'UNKNOWN'
WHERE STATEMENT TREAT it as 'false'
EXPRESSION with NULL is NULL. This is why '=null' is not a error but always return nothing.
*/

select customer#,firstname||' '||Lastname AS "NAME",NVL(Orders.Shipstreet,'This custoemr skimpted on shopping'),Shipstreet 
from customers Left Join Orders Using (CUSTOMER#)
Order by SHIPSTREET NULLS FIRST; --we can use NVL(ori_Obj,null_replace_obj) to deal with null value, something like a default

select customer#,firstname||' '||Lastname AS "NAME",NVL2(Orders.Shipstreet,'This customer is so generous!','This custoemr skimpted on shopping'),Shipstreet 
from customers Left Join Orders Using (CUSTOMER#)
Order by SHIPSTREET NULLS FIRST; --we can use NVL2(ori_Obj,notnull_repalce_obj,null_replace_obj) to deal with null and not null value.