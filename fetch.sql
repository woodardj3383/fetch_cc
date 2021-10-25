-- THIS QUERY USES ANSI SQL FROM SNOWFLAKE
-- I HAVE CREATED TWO SEPERATE QUERIES ALIASED AS TOP_FIVE_TWO AND TOP_FIVE_ONE
-- EACH QERRY IS IDENTICAL EXCEPT TOP_FIVE_TWO IS THE MONTH BEFORE LAST AND TOP_FIVE_ONE IS FROM -- THE MOST RECENT MONTH
-- THE DEFFAULT '2' AND '1' FOR RANK_MONTH HELP TO GROUP BY LABELING IN THE THIRD AND LAST QUERY
-- TO RETURN THE CORRECT NUMBERS THE QUERY COUNTS DISTINCT RECEIPT_NO GROUP BY BRANDS_ID GIVEN
-- A RANGE OF DATES

WITH TOP_FIVE_TWO AS(
SELECT
'2'AS RANK_MONTH
, B.BRANDS_ID AS BRANDS_ID
, COUNT(DISTINCT A.RECEIPTS_ID) AS HIGHEST_COUNT
FROM SCHEMA.RECEIPTS A
LEFT JOIN SCHEMA.BRANDS B 

WHERE A.CREATE_DATED 
BETWEEN DATE_TRUNC('MONTH',CURRENT_DAY())-INTERVAL'2 MONTHS' AND
        LAST_DAY(DATE_TRUNC('MONTH',CURRENT_DAY())-INTERVAL'2 MONTHS')
GROUP BY RANK_MONTH,BRANDS_ID
ORDER BY HIGHEST_COUNT DESC
LIMIT 5),

TOP_FIVE_ONE AS
(SELECT
'1'AS RANK_MONTH
, B.BRANDS_ID AS BRANDS_ID
, COUNT(DISTINCT A.RECEIPTS_ID) AS HIGHEST_COUNT
FROM SCHEMA.RECEIPTS A
LEFT JOIN SCHEMA.BRANDS B 

WHERE A.CREATE_DATE 
BETWEEN DATE_TRUNC('MONTH',CURRENT_DAY())-INTERVAL'1 MONTH'AND
        DATE_TRUNC('MONTH',CURRENT_DAY())-INTERVAL'1 DAY'

GROUP BY RANK_MONTH,BRANDS_ID
ORDER BY HIGHEST_COUNT DESC
LIMIT 5)

SELECT * FROM TOP_FIVE_ONE

UNION ALL

SELECT * FROM TOP_FIVE_TWO
;