/*
Grouping Date:
    1. aggregating data
    2. using MIN and MAX with non-numeric data
    3. GROUP BY
    4. Restricting rows and groups
    5. grand total

Group Functions: 
    SUM,AVG,STDDEV,VARIANCE - Numeric data
    MIN,MAX,MEDIAN,COUNT - ANY data type
    ALL Group Functions ignore NULL except 'count(*)'
    
SELECT                 FROM
FROM                   WHERE
WHERE         ---->    GROUP BY
GROUP BY               HAVING
HAVING                 SELECT
ORDER BY               ORDER BY
*/

select SUM(Retail - Cost) AS profit,
       Round(AVG(Retail - Cost)) As "Average Profit",
       COUNT(*)"Order Number",
       COUNT(DISTINCT category) "Category number",
       COUNT(category)"Category record",
       MAX(retail) "Highest Price",
       TO_CHAR(MIN(pubdate),'DD-MM-YYYY') "Eariest publish date"
From books natural join publisher
           natural join customers
           left join Orders Using (Customer#);
           
select gift, COUNT(ISBN) "COUNT"
From books, promotion
Where retail between minretail and maxretail
Group by gift;

/* Null Value in Group Function*/
select * from promotion;
Update promotion set MAXRETAIL = 57
where minretail = 56.01;
Insert into promotion values(NULL,57.01,999.99);

select 'Result from count(*)',count(*) -- count(*) will take null values
from promotion

UNION ALL

select 'Result from count(GIFT)',count(GIFT) -- others won't
from promotion

UNION ALL

Select DISTINCT NULL,NULL
from promotion

union all

select gift, COUNT(ISBN) "COUNT" -- the GIFT will have null value
From books, promotion
Where retail between minretail and maxretail
Group by gift;

/* 
    group by + having
    having: condition posted on the Group Functions' result
*/
select category, AVG(retail - cost) "Average Expected Profit"
From BOOKS
Group by category
Having AVG(retail - cost) > 15
Order by "Average Expected Profit";

