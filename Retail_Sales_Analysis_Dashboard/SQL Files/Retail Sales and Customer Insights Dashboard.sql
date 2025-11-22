create database retail;
use retail;

-- 1. Row counts
SELECT 'Sales' AS tbl, COUNT(*) AS rows FROM Sales
UNION ALL SELECT 'Product', COUNT(*) FROM Product
UNION ALL SELECT 'Date', COUNT(*) FROM `Date`
UNION ALL SELECT 'Region', COUNT(*) FROM Region
UNION ALL SELECT 'Customer', COUNT(*) FROM Customer;

-- 2. Nulls in key columns
SELECT 
  SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS null_productid,
  SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS null_customerid,
  SUM(CASE WHEN Date_ID IS NULL THEN 1 ELSE 0 END) AS null_dateid,
  SUM(CASE WHEN Region_ID IS NULL THEN 1 ELSE 0 END) AS null_regionid
FROM Sales;

-- 3. Duplicate PK candidates (example OrderID or SalesID)
SELECT 
    Transaction_ID, 
    COUNT(*) AS duplicate_count
FROM Sales
GROUP BY Transaction_ID
HAVING COUNT(*) > 1
LIMIT 20;

ALTER TABLE Sales 
ADD PRIMARY KEY (Transaction_ID);

ALTER TABLE Sales
MODIFY COLUMN Transaction_ID VARCHAR(36) NOT NULL;

ALTER TABLE Sales
ADD PRIMARY KEY (Transaction_ID);

-- 4. Date table minimal check
SELECT MIN(`Full_Date`) min_date, MAX(`Full_Date`) max_date, COUNT(DISTINCT `Full_Date`) cnt FROM `date`;

ALTER TABLE Sales
  ADD CONSTRAINT fk_sales_customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
  ADD CONSTRAINT fk_sales_product FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
  ADD CONSTRAINT fk_sales_region FOREIGN KEY (Region_ID) REFERENCES Region(Region_ID),
  ADD CONSTRAINT fk_sales_date FOREIGN KEY (Date_ID) REFERENCES Date(Date_ID);
  
  -- Show column types
SHOW COLUMNS FROM Sales LIKE 'Customer_ID';
SHOW COLUMNS FROM Sales LIKE 'Product_ID';
SHOW COLUMNS FROM Sales LIKE 'Region_ID';
SHOW COLUMNS FROM Sales LIKE 'Date_ID';

-- Show column definitions (for sales and dimension tables)
SHOW COLUMNS FROM Sales LIKE 'Customer_ID';
SHOW COLUMNS FROM Sales LIKE 'Product_ID';
SHOW COLUMNS FROM Sales LIKE 'Region_ID';
SHOW COLUMNS FROM Sales LIKE 'Date_ID';

SHOW COLUMNS FROM Customer LIKE 'Customer_ID';
SHOW COLUMNS FROM Product LIKE 'Product_ID';
SHOW COLUMNS FROM Region LIKE 'Region_ID';
SHOW COLUMNS FROM `Date` LIKE 'Date_ID';

-- Check max char lengths (helps pick varchar length)
SELECT 'sales_customer_maxlen' AS which, MAX(CHAR_LENGTH(Customer_ID)) maxlen FROM Sales;
SELECT 'cust_maxlen' AS which, MAX(CHAR_LENGTH(Customer_ID)) maxlen FROM Customer;
SELECT 'sales_product_maxlen' AS which, MAX(CHAR_LENGTH(Product_ID)) maxlen FROM Sales;
SELECT 'prod_maxlen' AS which, MAX(CHAR_LENGTH(Product_ID)) maxlen FROM Product;
SELECT 'sales_region_maxlen' AS which, MAX(CHAR_LENGTH(Region_ID)) maxlen FROM Sales;
SELECT 'reg_maxlen' AS which, MAX(CHAR_LENGTH(Region_ID)) maxlen FROM Region;
SELECT 'sales_date_maxlen' AS which, MAX(CHAR_LENGTH(Date_ID)) maxlen FROM Sales;
SELECT 'date_maxlen' AS which, MAX(CHAR_LENGTH(Date_ID)) maxlen FROM `Date`;

-- here we setled foreign keys
ALTER TABLE Sales
  ADD CONSTRAINT fk_sales_customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
  ADD CONSTRAINT fk_sales_product  FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID),
  ADD CONSTRAINT fk_sales_region   FOREIGN KEY (Region_ID)   REFERENCES Region(Region_ID),
  ADD CONSTRAINT fk_sales_date     FOREIGN KEY (Date_ID)     REFERENCES `Date`(Date_ID);
  
  -- Broken links check (should be 0)
SELECT COUNT(*) AS broken_fk_rows
FROM Sales s
LEFT JOIN Customer c ON s.Customer_ID = c.Customer_ID
LEFT JOIN Product  p ON s.Product_ID  = p.Product_ID
LEFT JOIN Region   r ON s.Region_ID   = r.Region_ID
LEFT JOIN `Date`   d ON s.Date_ID     = d.Date_ID
WHERE (s.Customer_ID IS NOT NULL AND c.Customer_ID IS NULL)
   OR (s.Product_ID  IS NOT NULL AND p.Product_ID  IS NULL)
   OR (s.Region_ID   IS NOT NULL AND r.Region_ID   IS NULL)
   OR (s.Date_ID     IS NOT NULL AND d.Date_ID     IS NULL);
  
-- count of rows
SELECT 'Sales' tbl, COUNT(*) rows FROM Sales
UNION ALL SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL SELECT 'Product',  COUNT(*) FROM Product
UNION ALL SELECT 'Region',   COUNT(*) FROM Region
UNION ALL SELECT 'Date',     COUNT(*) FROM `Date`;

-- Create a clean reporting view (for Power BI next)
CREATE OR REPLACE VIEW vw_sales_fact AS
SELECT
  s.Transaction_ID,
  s.Customer_ID,  c.Customer_Name, c.Customer_Segment, c.Age_Group, c.Gender, c.Annual_Income,
  s.Product_ID,   p.Product_Name,   p.Category,
  s.Region_ID,    r.Region_Name,   r.Country, r.Continent,
  s.Date_ID,      d.Full_date, d.Year, d.Month, d.Quarter,

  -- Sales / Marketing metrics
  s.Units_Sold, s.Discount_Applied, s.Revenue, s.Profit,
  s.Clicks, s.Impressions, s.Conversion_Rate, s.Ad_CTR, s.Ad_CPC, s.Ad_Spend
FROM Sales s
LEFT JOIN Customer c ON s.Customer_ID = c.Customer_ID
LEFT JOIN Product  p ON s.Product_ID  = p.Product_ID
LEFT JOIN Region   r ON s.Region_ID   = r.Region_ID
LEFT JOIN `Date`   d ON s.Date_ID     = d.Date_ID;

-- On Sales (FKs used in joins/filters)
CREATE INDEX ix_sales_customer  ON Sales(Customer_ID);
CREATE INDEX ix_sales_product   ON Sales(Product_ID);
CREATE INDEX ix_sales_region    ON Sales(Region_ID);
CREATE INDEX ix_sales_date      ON Sales(Date_ID);

-- On Date (common slicers)
CREATE INDEX ix_date_year       ON `Date`(Year);
CREATE INDEX ix_date_month      ON `Date`(Year, Month);

-- On Product / Customer for common filters
CREATE INDEX ix_product_category ON Product(Category);
CREATE INDEX ix_customer_segment ON Customer(Customer_Segment);
CREATE INDEX ix_region_name      ON Region(Region_Name);

SHOW INDEX FROM Sales;
SHOW INDEX FROM Region;

SELECT 
  SUM(Revenue) AS Total_Revenue,
  SUM(Profit) AS Total_Profit,
  SUM(Units_Sold) AS Total_Units,
  AVG(Profit) AS Avg_Profit_Per_Sale
FROM vw_sales_fact;

SELECT 
  COUNT(*) AS total_rows,
  COUNT(DISTINCT Customer_ID) AS unique_customers,
  COUNT(DISTINCT Product_ID) AS unique_products,
  COUNT(DISTINCT Region_ID) AS unique_regions,
  COUNT(DISTINCT Date_ID) AS unique_dates
FROM vw_sales_fact;

SELECT 
  AVG(Revenue) AS avg_revenue,
  AVG(Profit) AS avg_profit,
  AVG(Units_Sold) AS avg_units_sold,
  AVG(Conversion_Rate) AS avg_conversion_rate
FROM vw_sales_fact;

SELECT 
  Category,
  SUM(Revenue) AS Revenue_By_Category
FROM vw_sales_fact
GROUP BY Category
ORDER BY Revenue_By_Category DESC;

SELECT
  SUM(Units_Sold < 0)                  AS bad_units,
  SUM(Revenue < 0)                     AS bad_revenue,
  SUM(Profit IS NULL)                  AS null_profit,
  SUM(Ad_Spend < 0)                    AS bad_ad_spend,
  SUM(Conversion_Rate < 0 OR Conversion_Rate > 1) AS bad_conversion_rate,
  SUM(Ad_CTR < 0 OR Ad_CTR > 1)        AS bad_ctr,
  SUM(Ad_CPC < 0)                      AS bad_cpc
FROM Sales;

SELECT Transaction_ID, Units_Sold, Revenue, Profit, Discount_Applied,
       Conversion_Rate, Ad_CTR, Ad_CPC, Ad_Spend
FROM Sales
WHERE Units_Sold < 0
   OR Revenue < 0
   OR Ad_Spend < 0
   OR Conversion_Rate NOT BETWEEN 0 AND 1
   OR Ad_CTR NOT BETWEEN 0 AND 1
   OR Ad_CPC < 0
LIMIT 50;

SELECT
  Category,
  SUM(Units_Sold) AS units,
  SUM(Revenue)    AS revenue,
  SUM(Ad_Spend)   AS ad_spend,
  SUM(Clicks)     AS clicks,
  SUM(Impressions) AS impressions
FROM vw_sales_fact
GROUP BY Category
ORDER BY revenue DESC;

SELECT 
  MIN(Conversion_Rate) AS min_rate,
  MAX(Conversion_Rate) AS max_rate
FROM Sales;

UPDATE Sales
SET Conversion_Rate = 1
WHERE Conversion_Rate > 1;

SELECT 
  MIN(Conversion_Rate) AS min_rate,
  MAX(Conversion_Rate) AS max_rate
FROM Sales;