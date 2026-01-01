DROP TABLE IF EXISTS Zepto;
CREATE TABLE ZEPTO(
	sku_id SERIAL PRIMARY KEY,
	Category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),	
	discountPercent NUMERIC(5,2),
	availableQuantity INT,
	discountedSellingPrice NUMERIC(8,2),	
	weightInGms INT,
	outOfStock BOOLEAN,
	quantity INT
);

--Exploratory Functions

SELECT COUNT(*) FROM Zepto;
SELECT * FROM Zepto;

--Types of cateogries--

SELECT DISTINCT category 
FROM ZEPTO
ORDER BY category;

--products in stock vs out of stock

SELECT outofstock, COUNT(*)
FROM Zepto
GROUP BY outofstock;

--product names present multiple times 

SELECT 
	name, 
	COUNT(*) AS no_of_Sku
FROM Zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY no_of_Sku DESC;

--Data Cleaning

--Products with Price = 0

SELECT 
	* 
FROM Zepto
WHERE
	mrp = 0
	OR
	discountedsellingprice = 0;

DELETE FROM Zepto
WHERE mrp=0;

--Converting into standardized units i.e From Paise to Rupees

UPDATE Zepto
	SET 
		mrp = mrp/100.0,
		discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM Zepto;
 
--Business Based Analysis

--Q1. Find the top 10 best-value products based on the discount percentage.

SELECT * FROM Zepto;

SELECT 
	name, 
	discountpercent
FROM Zepto
ORDER BY 2 DESC
LIMIT 10;

--Q2. What are products with high MRP but out of stock.

SELECT DISTINCT
	name, 
	mrp
FROM Zepto
WHERE 
	outofstock = TRUE 
	AND mrp > 300
ORDER BY 2 DESC;

--Q3. Calculate estimated potential revenue for each product category

SELECT
	category,
	SUM(discountedsellingprice * availablequantity) AS Total_Revenue
FROM Zepto
GROUP BY 1
ORDER BY Total_Revenue DESC;

--Q4. Filtered expensive products (MRP > ₹500) with minimal discount

SELECT * FROM Zepto;

SELECT 
	name,
	mrp,
	discountpercent
FROM Zepto
WHERE 
	mrp > 500
	AND 
	discountpercent < 10
ORDER BY 2 DESC, 3 DESC;

--Identify top 5 categories offering highest average discount percentage.

SELECT 
	category,
	ROUND(AVG(discountpercent), 2) AS avg_disc_percent
FROM Zepto
GROUP BY category
LIMIT 5;


--Calculated price per gram for products above 100gm and sort by best value.

SELECT DISTINCT 
	name, 
	weightingms,
	discountedsellingprice,
	ROUND(discountedsellingprice/weightingms, 2) AS price_per_gm
FROM Zepto
WHERE weightingms > 100
ORDER BY 4 DESC;

--Group the products into categories like low, medium, bulk

SELECT DISTINCT 
	name,
	weightingms,
	CASE WHEN weightingms < 1000 THEN 'Low'
		 WHEN weightingms < 5000 THEN 'Medium'
		 ELSE 'Bulk'
	END AS Weight_Category
FROM Zepto;

--What is total inventory weight per product category 

SELECT * FROM Zepto;

SELECT 
	category,
	SUM(weightingms * availablequantity) AS Total_Weight
FROM Zepto
GROUP BY 1
ORDER BY Total_Weight DESC;
