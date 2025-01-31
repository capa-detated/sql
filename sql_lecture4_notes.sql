-- INSERT UPDATE DELETE - manually modifying data in a TABLE

--1) add  product to the TABLE
--2) change the product_size for that product
--3) delete our product

DROP TABLE IF EXISTS temp.product_expanded;

CREATE TEMP TABLE product_expanded AS
	SELECT * FROM product;
	
--SELECT * FROM product_expanded

--INSERT
INSERT INTO product_expanded
VALUES(26, 'Almonds', '1 lb', 1, 'lbs');

--UPDATE--change the product_size for almonds from 1lb to 1/2kg

UPDATE product_expanded
SET product_size = '1/2 kg', product_qty_type = 'kg' -- SET replaces existing values with newly specified ones
WHERE product_id = 26;
--SELECT * FROM product_expanded

--DELETE 
--delete the newly added almonds
DELETE FROM product_expanded
--SELECT * FROM product_expanded -- this is included to make sure you select the correct thing before running delete command! comment out when ready to run delete
WHERE product_id = 26;

SELECT *
FROM product_expanded;


--VIEWS - save current instance of sql output 


--VIEW
DROP VIEW IF EXISTS vendor_daily_sales;
CREATE VIEW IF NOT EXISTS vendor_daily_sales AS

	SELECT
	md.market_date,
	market_day,
	market_week,
	market_year,
	vendor_name,
	SUM(quantity*cost_to_customer_per_qty) as sales
	
	FROM market_date_info md
	INNER JOIN customer_purchases cp
		on md.market_date = cp.market_date
	INNER JOIN vendor v
		on cp.vendor_id = v.vendor_id
		
		
	GROUP BY cp.market_date, v.vendor_id
	
	
--using a view in a different QUERY
--functionally similar to subquery -- calling on the script that generates 'vendor_daily_sales' within this select query

SELECT market_year,
market_week,
vendor_name,
sum(sales)

FROM vendor_daily_sales

GROUP BY market_year, market_week, vendor_name




---IMPORT & EXPORT - how to get data in and out of sql
--'File' -> 'Import' / 'Export'

  --DYNAMIC VIEW

DROP VIEW IF EXISTS todays_vendor_daily_sales;
CREATE VIEW IF NOT EXISTS todays_vendor_daily_sales AS 

	SELECT
	md.market_date
	,market_day
	,market_week
	,market_year
	,vendor_name
	,SUM(quantity*cost_to_customer_per_qty) as sales
	
	FROM market_date_info md
	INNER JOIN (
		SELECT * FROM customer_purchases 
		UNION
		SELECT * FROM new_customer_purchases
	) cp
		on md.market_date = cp.market_date
	INNER JOIN vendor v
		on cp.vendor_id = v.vendor_id
	
	WHERE md.market_date = DATE('now','localtime')
  
  GROUP BY cp.market_date, v.vendor_id
  
  
UPDATE new_customer_purchases
SET market_date =DATE('now','localtime');

INSERT INTO market_date_info
VALUES('2025-01-30','Thursday','5','2025','8:00 AM','2:00 PM','nothing interesting','Winter','0','4',1,0);


SELECT * FROM todays_vendor_daily_sales;



--JSON -more powerful than plain csv's thanks to better handling of nested data structures

--JSON to TABLE

--create temp TABLE
--insert json as blob (ie. long string)
--write json EACH statement (inside FROM statement)
--use json_each statement in subquery to extract column values with json_extract

DROP TABLE IF EXISTS temp.new_json;
CREATE TEMP TABLE IF NOT EXISTS temp.new_json
(
		the_json BLOB -- the column and column typeof
);

INSERT INTO temp.new_json
VALUES(
'[
    {
        "country": "Afghanistan",
        "city": "Kabul"
    },
    {
        "country": "Albania",
        "city": "Tirana"
    }]'
);

SELECT KEY
,JSON_EXTRACT(value,'$.country') as country
,JSON_EXTRACT(value,'$.city') as city

FROM (
		SELECT *
		FROM new_json,JSON_EACH(new_json.the_json,'$')
)x


---CROSS JOIN & SELF JOINS (advanced JOIN functions)

--CROSS JOIN
DROP TABLE IF EXISTS temp.sizes;
CREATE TEMP TABLE IF NOT EXISTS temp.sizes(size TEXT);

INSERT INTO temp.sizes
VALUES('small'),
('medium'),
('large');

SELECT * FROM temp.sizes;

SELECT product_name, size
FROM product
CROSS JOIN temp.sizes -- notice no need to specify 'join on'
--generates 69 rows- 23 products * 3 sizes = 69 combinations

--SELF JOINS - not very common, but helpful with hierarchical relationships 

DROP TABLE IF EXISTS temp.supervisors;
CREATE TEMP TABLE IF NOT EXISTS temp.supervisors
(
stu_id int,
stu_name text,
sup_id int
);

INSERT INTO temp.supervisors
VALUES(1,'THOMAS', 3),
(2,'KELLI',3),
(3,'ROHAN',NULL),
(4,'BOB',1);

SELECT *
FROM temp.supervisors

--self-JOIN
SELECT
a.stu_name,
b.stu_name as super_name

FROM supervisors a
LEFT JOIN supervisors b
	on a.sup_id = b.stu_id
