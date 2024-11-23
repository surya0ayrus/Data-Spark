CREATE DATABASE globalelectronic;
USE globalelectronic;
SHOW Table status;
SHOW tables;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;FLUSH PRIVILEGES;

CREATE USER 'new connection'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON *.* TO 'new connection'@'localhost';
FLUSH PRIVILEGES;






DESCRIBE Project2;

#1 "Monthly Sales Performance Trend Analysis"
#Tracks revenue, order volume, and unit sales by month and year

SELECT 
    YEAR(`Order Date`) as Year,    -- Changed from OrderDate to `Order Date`
    MONTH(`Order Date`) as Month,
    SUM(`Unit Price USD` * Quantity) as TotalRevenue,
    COUNT(DISTINCT `Order Number`) as TotalOrders,
    SUM(Quantity) as TotalUnits
FROM Project2
GROUP BY YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY Year, Month;

#2  "Product Category Performance & Profitability Breakdown"
#Analyzes category-wise product diversity, sales volume, revenue, and profit margins
SELECT 
    Category,
    COUNT(DISTINCT `Product Name`) as UniqueProducts,
    SUM(Quantity) as UnitsSold,
    SUM(`Unit Price USD` * Quantity) as Revenue,
    SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) as Profit,
    (SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) / SUM(`Unit Price USD` * Quantity) * 100) as ProfitMargin
FROM Project2
GROUP BY Category
ORDER BY Revenue DESC;

#3"Customer Purchase Behavior and Value Analysis"
#Shows customer ordering patterns, spending habits, and customer value metrics

SELECT 
    CustomerKey,
    COUNT(DISTINCT `Order Number`) as OrderCount,
    SUM(`Unit Price USD` * Quantity) as TotalSpent,
    AVG(`Unit Price USD` * Quantity) as AvgOrderValue,
    MAX(`Order Date`) as LastOrderDate
FROM Project2
GROUP BY CustomerKey
ORDER BY TotalSpent DESC;

#4"Geographic Sales Distribution by State and City"
#Maps revenue and customer concentration across different locations


SELECT 
    State,
    City,
    COUNT(DISTINCT CustomerKey) as CustomerCount,
    SUM(`Unit Price USD` * Quantity) as Revenue,
    COUNT(DISTINCT `Order Number`) as OrderCount
FROM Project2
GROUP BY State, City
ORDER BY Revenue DESC;

#5"Product-Level Performance and Profitability Analysis"
#Detailed breakdown of individual product performance across brands and categories
SELECT 
    `Product Name`,
    Brand,
    Category,
    SUM(Quantity) as UnitsSold,
    SUM(`Unit Price USD` * Quantity) as Revenue,
    SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) as Profit,
    (SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) / SUM(`Unit Price USD` * Quantity) * 100) as ProfitMargin
FROM Project2
GROUP BY `Product Name`, Brand, Category
ORDER BY Profit DESC;

#6"Store Performance and Customer Distribution Analysis"
#Evaluates store efficiency through revenue, profit, and customer metrics

SELECT 
    StoreKey,
    COUNT(DISTINCT `Order Number`) as OrderCount,
    COUNT(DISTINCT CustomerKey) as UniqueCustomers,
    SUM(`Unit Price USD` * Quantity) as Revenue,
    SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) as Profit
FROM Project2
GROUP BY StoreKey
ORDER BY Revenue DESC;

#7"Brand Performance and Market Share Analysis"
#Compares brand performance through product range, sales volume, and profitability
SELECT 
    Brand,
    COUNT(DISTINCT `Product Name`) as ProductCount,
    SUM(Quantity) as UnitsSold,
    SUM(`Unit Price USD` * Quantity) as Revenue,
    SUM((`Unit Price USD` - `Unit Cost USD`) * Quantity) as Profit
FROM Project2
GROUP BY Brand
ORDER BY Revenue DESC;

#8"Sales Timing Analysis - Day and Hour Patterns"
#Reveals peak sales periods and temporal purchase patterns

SELECT 
    DAYNAME(`Order Date`) as DayOfWeek,
    HOUR(`Order Date`) as HourOfDay,
    COUNT(DISTINCT `Order Number`) as OrderCount,
    SUM(`Unit Price USD` * Quantity) as Revenue
FROM Project2
GROUP BY DAYNAME(`Order Date`), HOUR(`Order Date`)
ORDER BY DayOfWeek, HourOfDay;

#9"Product Association Analysis (Market Basket Analysis)"
#Identifies frequently co-purchased products for cross-selling opportunities

SELECT 
    p1.`Product Name` as Product1,
    p2.`Product Name` as Product2,
    COUNT(*) as PurchasedTogether
FROM Project2 p1
JOIN Project2 p2 
    ON p1.`Order Number` = p2.`Order Number`
    AND p1.`Product Name` < p2.`Product Name`
GROUP BY p1.`Product Name`, p2.`Product Name`
ORDER BY PurchasedTogether DESC
LIMIT 20;

#10"Customer Loyalty and Retention Analysis"
#Measures customer longevity, repeat purchase behavior, and lifetime value

SELECT 
    CustomerKey,
    COUNT(DISTINCT `Order Number`) as TotalOrders,
    DATEDIFF(MAX(`Order Date`), MIN(`Order Date`)) as CustomerLifeSpan,
    SUM(`Unit Price USD` * Quantity) / COUNT(DISTINCT `Order Number`) as AvgOrderValue,
    MAX(`Order Date`) as LastOrderDate
FROM Project2
GROUP BY CustomerKey
HAVING COUNT(DISTINCT `Order Number`) > 1
ORDER BY CustomerLifeSpan DESC;

