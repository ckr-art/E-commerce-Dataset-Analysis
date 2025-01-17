-- Identifing the Top 5 Most Popular Products by Sales Volume--

SELECT p.ProductName,
SUM(o.Quantity) AS TotalUnitsSold
FROM 
    Orders o
JOIN 
    Products p ON o.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalUnitsSold DESC
LIMIT 5;

-- Calculatig the Monthly Revenue Growth Rate --

WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(o.OrderDate, '%Y-%m') AS Month,
        SUM(o.TotalAmount) AS Revenue
    FROM 
        Orders o
    GROUP BY 
        DATE_FORMAT(o.OrderDate, '%Y-%m')
),
RevenueGrowth AS (
    SELECT 
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue,
        ((Revenue - LAG(Revenue) OVER (ORDER BY Month)) / LAG(Revenue) OVER (ORDER BY Month)) * 100 AS GrowthRate
    FROM 
        MonthlyRevenue
)
SELECT 
    Month,
    Revenue,
    PreviousMonthRevenue,
    GrowthRate
FROM 
    RevenueGrowth;

-- Finding Customers Who Made Purchases in Consecutive Months --

WITH MonthlyCustomers AS (
    SELECT 
        CustomerID,
        DATE_FORMAT(OrderDate, '%Y-%m') AS PurchaseMonth
    FROM 
        Orders
    GROUP BY 
        CustomerID, DATE_FORMAT(OrderDate, '%Y-%m')
),
ConsecutivePurchases AS (
    SELECT 
        curr.CustomerID,
        curr.PurchaseMonth AS CurrentMonth,
        prev.PurchaseMonth AS PreviousMonth
    FROM 
        MonthlyCustomers curr
    JOIN 
        MonthlyCustomers prev
    ON 
        curr.CustomerID = prev.CustomerID
        AND curr.PurchaseMonth = DATE_ADD(prev.PurchaseMonth, INTERVAL 1 MONTH)
)
SELECT 
    CustomerID,
    CurrentMonth,
    PreviousMonth
FROM 
    ConsecutivePurchases;

-- Determine the Average Order Value by Customer Segment --

WITH CustomerSpending AS (
    SELECT 
        c.CustomerID,
        c.Name,
        SUM(o.TotalAmount) AS TotalSpending
    FROM 
        Customers c
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    GROUP BY 
        c.CustomerID, c.Name
),
CustomerSegments AS (
    SELECT 
        CustomerID,
        Name,
        TotalSpending,
        CASE 
            WHEN TotalSpending > 10000 THEN 'High Spender'
            WHEN TotalSpending BETWEEN 5000 AND 10000 THEN 'Medium Spender'
            ELSE 'Low Spender'
        END AS Segment
    FROM 
        CustomerSpending
)
SELECT 
    Segment,
    AVG(TotalSpending) AS AvgSpendingPerCustomer
FROM 
    CustomerSegments
GROUP BY 
    Segment;
    
-- Identifing the Most Profitable Customers --
 
   Select  c.CustomerID, c.Name,
    SUM(o.TotalAmount - (o.Quantity * p.CostPrice)) AS TotalProfit
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Products p ON o.ProductID = p.ProductID
GROUP BY 
    c.CustomerID, c.Name
ORDER BY 
    TotalProfit DESC
LIMIT 5;

-- Analyzig Product Performance Across Categories --

SELECT 
    p.Category,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalUnitsSold,
    SUM(o.TotalAmount) AS TotalRevenue
FROM 
    Orders o
JOIN 
    Products p ON o.ProductID = p.ProductID
GROUP BY 
    p.Category
ORDER BY 
TotalRevenue DESC;
    
-- Calculate Repeat Purchase Rate by Customer --

WITH CustomerOrders AS (
    SELECT 
        CustomerID,
        COUNT(OrderID) AS TotalOrders
    FROM 
        Orders
    GROUP BY 
        CustomerID
)
SELECT 
    CustomerID,
    TotalOrders,
    CASE 
        WHEN TotalOrders > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS CustomerType
FROM 
    CustomerOrders;
 
 
-- Determine the Revenue Contribution of Each Customer Segment --

WITH CustomerSpending AS (
    SELECT 
        c.CustomerID,
        c.Name,
        SUM(o.TotalAmount) AS TotalSpending
    FROM 
        Customers c
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    GROUP BY 
        c.CustomerID, c.Name
),
CustomerSegments AS (
    SELECT 
        CustomerID,
        Name,
        TotalSpending,
        CASE 
            WHEN TotalSpending > 10000 THEN 'High Spender'
            WHEN TotalSpending BETWEEN 5000 AND 10000 THEN 'Medium Spender'
            ELSE 'Low Spender'
        END AS Segment
    FROM 
        CustomerSpending
)
SELECT 
    Segment,
    SUM(TotalSpending) AS RevenueContribution,
    (SUM(TotalSpending) * 100.0 / (SELECT SUM(TotalSpending) FROM CustomerSpending)) AS PercentageContribution
FROM 
    CustomerSegments
GROUP BY 
    Segment;