/*
1.STEPS AND THOUGHT PROCESS:
#Identifying the key tables and the relationship between the tables was the first part of solving the query.
#Determined that inner join should be used for this query in order to include customers who purchased the order in 2016 is alone included.
#SQL operations done and the tought process behind them is as follows 
   - **JOIN**: Joined `Sales.Orders` with `Sales.Customers` on `CustomerID` and Sales.Customers to Sales.CustomerTransactions 
               to link each order with customer details.
   - **WHERE**: Filtered the orders to include only those made in 2016 using `YEAR(soh.OrderDate) = 2016`.
   - **GROUP BY**: Grouped by `CustomerID` and `CustomerName` to calculate the average order value for each customer.
   - **ROUND()**: Rounded the average order value to two decimal places.
   - **ORDER BY**: Sorted the results by average order value in descending order to highlight customers with the highest average spending.
CHALLENGES AND DRAFTS:
#Had difficulty identifying the tables and the variables needed to solve the query.
#Used chatgpt for assistance,it was useful for identifying the tables but was not able to identify the columns.
#Faced the error Column "'Sales.Customers.CustomerID' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause"
while executing my first draft 
DRAFT 1: 
SELECT C.CustomerID, C.CustomerName AS [FullName], ROUND(AVG(CT.TransactionAmount),2) AS [AverageOrderValue]
FROM Sales.Orders soh JOIN  Sales.Customers C ON  C.CustomerID=soh.CustomerID
JOIN Sales.CustomerTransactions CT ON C.CustomerID=CT.CustomerID
WHERE YEAR(soh.OrderDate) = 2016
GROUP BY C.CustomerID,C.CustomerName
ORDER BY[AverageOrderValue] DESC;
#Resolved the error by including GROUP BY*/

SELECT C.CustomerID, C.CustomerName AS [FullName], ROUND(AVG(CT.TransactionAmount),2) AS [AverageOrderValue]
FROM Sales.Orders soh JOIN  Sales.Customers C ON  C.CustomerID=soh.CustomerID
JOIN Sales.CustomerTransactions CT ON C.CustomerID=CT.CustomerID
WHERE YEAR(soh.OrderDate) = 2016
GROUP BY C.CustomerID,C.CustomerName
ORDER BY[AverageOrderValue] DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2.STEPS AND THOUGHT PROCESS:
#Identifying the key tables and the relationship between the tables was the first part of solving the query.
#Joining the tables and determining that left join should be used to ensure that all stock groups are included.This decision was crucial for accurately reflecting total sales.
#Simplifying the query by by eliminating unnecessary joins, this streamlined the query focusing directly on the relationship between stock groups, items, and invoices.
#Applied the filter and sorted the "TotalSalesAmount" in descending order to highlight the top-performing stock groups.

CHALLENGES AND DRAFTS:
#The initial draft included unnecessary joins that complicated the query and lead to incorrect results by introducing irrelevant data
#The unnecessary joins complicated the query and potentially introduced errors.
#Simplifying the joins ensured that the aggregation was accurate, reflecting only the data needed to calculate total sales by stock group
#Intial draft included a having clause for filter but faced this error 
"Column 'Sales.Orders.OrderDate' is invalid in the HAVING clause because it is not contained in either an aggregate function or the GROUP BY clause"
#Overcame the issue by removing the having and using WHERE before the group by
#Intial draft was
SELECT 
    SG.StockGroupID,
    SG.StockGroupName,
    SUM(IL.UnitPrice * IL.Quantity) AS [TotalSalesAmount]
FROM Warehouse.StockGroups SG
LEFT JOIN Warehouse.StockItemStockGroups SI ON SG.StockGroupID = SI.StockGroupID
LEFT JOIN Warehouse.StockItems S ON SI.StockItemID = S.StockItemID
LEFT JOIN Warehouse.StockItemTransactions SD ON S.StockItemID = SD.StockItemID
LEFT JOIN Sales.Customers C ON SD.CustomerID = C.CustomerID
LEFT JOIN Sales.Invoices I ON C.CustomerID = I.CustomerID
LEFT JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
Having I.InvoiceDate BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY SG.StockGroupID, SG.StockGroupName
ORDER BY [TotalSalesAmount] DESC;
#Dropped the unnecessary joins and then used WHERE instead of having to resolve the error,*/

SELECT 
    SG.StockGroupID,
    SG.StockGroupName,
    SUM(IL.UnitPrice * IL.Quantity) AS [TotalSalesAmount]
FROM Warehouse.StockGroups SG
LEFT JOIN Warehouse.StockItemStockGroups SI ON SG.StockGroupID = SI.StockGroupID
LEFT JOIN Warehouse.StockItems S ON SI.StockItemID = S.StockItemID
LEFT JOIN Sales.InvoiceLines IL ON S.StockItemID = IL.StockItemID
LEFT JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
WHERE I.InvoiceDate BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY SG.StockGroupID, SG.StockGroupName
ORDER BY [TotalSalesAmount] DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3.STEPS AND THOUGHT PROCESS:
#Identifying the key tables and the relationship between the tables was the first part of solving the query.
#Joining Purchasing.Suppliers with Warehouse.StockItems using SupplierID to connect suppliers to the items they supply.
#Joining Warehouse.StockItems with Sales.InvoiceLines using StockItemID to link each stock item to its corresponding sales data.
#Aggregating and ordering the data and the handling the Null was the final steps.

CHALLENGES AND DRAFTS:
#The first draft attempted to handle cases where the total sales amount could be zero or null by using a CASE statement.
#This approach was redundant because SQL naturally handles sums of non-existent rows as NULL, not zero
#Came to know about COALESCE aggregate function to overcome this issue.
#Intial Draft was:
SELECT S.SupplierID,
       S.SupplierName,
	   CASE WHEN SUM(IL.UnitPrice * IL.Quantity) = 0 THEN 0
	   ELSE SUM(IL.UnitPrice * IL.Quantity)
	   END AS [TotalSalesAmount]
FROM Purchasing.Suppliers S
LEFT JOIN Warehouse.StockItems SI ON S.SupplierID = SI.SupplierID
LEFT JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
GROUP BY S.SupplierID, S.SupplierName
ORDER BY TotalSalesAmount DESC;
#The CASE statement was redundant and unnecessarily complicated the query. Used  COALESCE aggregate function instead of CASE statement.*/

SELECT S.SupplierID,
       S.SupplierName,
	   COALESCE(SUM(IL.UnitPrice * IL.Quantity), 0) AS [TotalSalesAmount]
FROM Purchasing.Suppliers S
LEFT JOIN Warehouse.StockItems SI ON S.SupplierID = SI.SupplierID
LEFT JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
GROUP BY S.SupplierID, S.SupplierName
ORDER BY TotalSalesAmount DESC;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4.STEPS AND THOUGHT PROCESS:
#Identifying the key tables and the relationship between the tables was the first part of solving the query.
#Intial approach was to use count after joining the tables, but after analysic with ChatGPT found this could lead to 
inflated counts due to the Cartesian product effect when both tables have records.
#Instead used subqueries to count the usage of delivery methods in Sales.Invoices and Purchasing.PurchaseOrders separately
#Joining the tables to find the total usage counts in both sales and purchasing.

CHALLENGES AND DRAFTS:
#The first draft counted delivery method usage after performing the join, which could result in inflated counts due to the nature of SQL joins
#By isolating the counting process using subqueries, the refined query ensures that counts are accurate and not affected by the join.
#The first draft did not account for scenarios where a delivery method might not be used in either sales or purchases, leading to potential null values in the result
#The use of COALESCE in the final query addresses this by replacing null values with 0, ensuring that every delivery method is accounted for even if it has no usage.
#Intial draft was
SELECT DM.DeliveryMethodID,
       DM.DeliveryMethodName,
	   COUNT(I.DeliveryMethodID) AS [SalesUsageCounts],
	   COUNT(PO.DeliveryMethodID) AS [PurchaseUsageCounts]
FROM Application.DeliveryMethods DM
LEFT JOIN Sales.Invoices I ON DM.DeliveryMethodID = I.DeliveryMethodID
LEFT JOIN Purchasing.PurchaseOrders PO ON DM.DeliveryMethodID = PO.DeliveryMethodID
GROUP BY DM.DeliveryMethodID,DM.DeliveryMethodName;
#The use of subqueries and COALESCE in the final query ensures accurate counting and proper handling of null values, providing a more reliable and clear result.*/
SELECT 
    DM.DeliveryMethodID,
    DM.DeliveryMethodName,
    COALESCE(SalesUsageCount, 0) AS SalesUsageCount,
    COALESCE(PurchaseUsageCount, 0) AS PurchaseUsageCount
FROM Application.DeliveryMethods DM
LEFT JOIN (
    SELECT 
        DeliveryMethodID, 
        COUNT(*) AS SalesUsageCount
    FROM Sales.Invoices
    GROUP BY DeliveryMethodID
) SI ON DM.DeliveryMethodID = SI.DeliveryMethodID
LEFT JOIN (
    SELECT 
        DeliveryMethodID, 
        COUNT(*) AS PurchaseUsageCount
    FROM Purchasing.PurchaseOrders
    GROUP BY DeliveryMethodID
) PO ON DM.DeliveryMethodID = PO.DeliveryMethodID;

-------------------------------------------------------------------------------------------------------------------------------------------
/*
5.STEPS AND THOUGHT PROCESS:
#Identifying the key tables and the relationship between the tables was the first part of solving the query.
#Calculation of UniqueProductsCount using Count aggregate function and DISTINCT to find unique products. 
#TotalAmountSpent is calculated using the SUM aggregate function.
#To identify the top 10 customers based on the number of unique products purchased and the total amount spent
an INNER JOIN was used.

CHALLENGES AND DRAFTS:
#The use of subqueries in the initial draft added complexity without adding value for this specific case, 
as we are only interested in customers who made purchases.
#By directly aggregating data in the final query,complexity of subqueries was avoided.
#Intially used LEFT JOIN to include all the customers but since we are interested in top 10 customers,
replaced it with INNER JOIN. 
#Used chatGPT for overcoming the issues and makinf the query more efficient.
#Intial draft was
SELECT TOP 10
    C.CustomerID,
    C.CustomerName,
    COALESCE(UniqueProductsCount, 0) AS UniqueProductsCount,
    COALESCE(TotalAmountSpent, 0) AS TotalAmountSpent
FROM Sales.Customers C
LEFT JOIN (
    SELECT 
        I.CustomerID,
        COUNT(DISTINCT IL.StockItemID) AS UniqueProductsCount
    FROM Sales.Invoices I
    INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    WHERE YEAR(I.InvoiceDate) = 2016
    GROUP BY I.CustomerID
) UP ON C.CustomerID = UP.CustomerID
LEFT JOIN (
    SELECT 
        I.CustomerID,
        SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
    FROM Sales.Invoices I
    INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    WHERE YEAR(I.InvoiceDate) = 2016
    GROUP BY I.CustomerID
) TA ON C.CustomerID = TA.CustomerID
ORDER BY UniqueProductsCount DESC, TotalAmountSpent DESC;
#The final query directly calculates the required metrics and uses INNER JOIN to include only 
relevant customers, simplifying the process and focusing on customers with actual purchases.*/

SELECT TOP 10 
    C.CustomerID,
    C.CustomerName,
    COUNT(DISTINCT IL.StockItemID) AS UniqueProductsCount,
    SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
FROM Sales.Customers C
JOIN Sales.Invoices I ON C.CustomerID = I.CustomerID
JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
WHERE YEAR(I.InvoiceDate) = 2016
GROUP BY C.CustomerID, C.CustomerName
ORDER BY UniqueProductsCount DESC, TotalAmountSpent DESC;

--------------------------------------------------------------------------------------------------------------------------------------------
/*6.STEPS AND THOUGHT PROCESS:
#The initial idea was to use subquery to select the top 5 customers based on the number of unique products purchased and the total amount spent. 
then join the result with the Sales.Invoices, Sales.InvoiceLines, and Warehouse.StockItems tables to get 
detailed purchase information for each of these top customers.
#Eventhough this idea was successful the query was not readable and difficult
#Using ChatGPT used CTE instead of subquery to simplifies the query.
#Using subquery inside the CTE to calculate the top 5 customers and JOIN to get the purchase details.
#Finally filtered the data and ordered it in descending order to find top5 customers.

CHALLENGES AND DRAFTS:
# The initial draft contained a nested subquery that combined both the selection of 
top customers and their detailed purchase information. This made the query harder to read and understand.
# Using CTE to make the core more readable and simple
#The intial draft was
SELECT 
    TC.CustomerID,
    TC.CustomerName,
    SI.StockItemID,
    SI.StockItemName,
    COUNT(I.InvoiceID) AS NumberOfOrders,
    SUM(IL.Quantity) AS TotalQuantityOrdered,
    SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
FROM (
    SELECT TOP 5 
        C.CustomerID,
        C.CustomerName,
        COUNT(DISTINCT IL.StockItemID) AS UniqueProductsCount,
        SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
    FROM Sales.Customers C
    INNER JOIN Sales.Invoices I ON C.CustomerID = I.CustomerID
    INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    WHERE YEAR(I.InvoiceDate) = 2016
    GROUP BY C.CustomerID, C.CustomerName
    ORDER BY UniqueProductsCount DESC, TotalAmountSpent DESC
) AS TC
INNER JOIN Sales.Invoices I ON TC.CustomerID = I.CustomerID
INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
WHERE YEAR(I.InvoiceDate) = 2016
GROUP BY TC.CustomerID, TC.CustomerName, SI.StockItemID, SI.StockItemName
ORDER BY TotalAmountSpent DESC, SI.StockItemID;
#The initial draft used a nested subquery approach, which combined the logic for identifying the top customers and retrieving their purchase details. 
This made the query complex and less maintainable. The final query uses a CTE to separately handle the identification of top customers and the retrieval of 
detailed purchase information, making the query more readable and efficient. This approach separates concerns, simplifies the query structure, and enhances performance.*/

WITH TopCustomers AS (
    SELECT TOP 5 
        C.CustomerID,
        C.CustomerName,
        COUNT(DISTINCT IL.StockItemID) AS UniqueProductsCount,
        SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
    FROM Sales.Customers C
    INNER JOIN Sales.Invoices I ON C.CustomerID = I.CustomerID
    INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
    WHERE YEAR(I.InvoiceDate) = 2016
    GROUP BY C.CustomerID, C.CustomerName
    ORDER BY UniqueProductsCount DESC, TotalAmountSpent DESC
)
SELECT 
    TC.CustomerID,
    TC.CustomerName,
    SI.StockItemID,
    SI.StockItemName,
    COUNT(I.InvoiceID) AS NumberOfOrders,
    SUM(IL.Quantity) AS TotalQuantityOrdered,
    SUM(IL.UnitPrice * IL.Quantity) AS TotalAmountSpent
FROM TopCustomers TC
INNER JOIN Sales.Invoices I ON TC.CustomerID = I.CustomerID
INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
WHERE YEAR(I.InvoiceDate) = 2016
GROUP BY TC.CustomerID, TC.CustomerName, SI.StockItemID, SI.StockItemName
ORDER BY TotalAmountSpent DESC, SI.StockItemID;



-------------------------------------------------------------------END OF TASK A & TASK B-----------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------EDA------------------------------------------------------------------------------------------------------------


--1. What is the stock turnover rate? Which goods are in the greatest demand and which are in the least?

--Stock Turnover Rate
SELECT TOP 10
    SI.StockItemID,
    SI.StockItemName,
    SUM(IL.Quantity) AS TotalQuantitySold,
    SIH.QuantityOnHand,
    CASE WHEN SIH.QuantityOnHand = 0 THEN NULL 
     --    ELSE CAST(SUM(IL.Quantity) AS FLOAT) / SIH.QuantityOnHand 
	 ELSE ROUND(CAST(SUM(IL.Quantity) AS FLOAT) / NULLIF(AVG(SIH.QuantityOnHand), 0),2)
    END AS StockTurnoverRate
FROM 
    Warehouse.StockItems SI
JOIN 
    Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
JOIN 
    Warehouse.StockItemHoldings SIH ON SI.StockItemID = SIH.StockItemID
GROUP BY 
    SI.StockItemID, SI.StockItemName, SIH.QuantityOnHand
ORDER BY 
    StockTurnoverRate DESC;

--Highest Demand Items
SELECT 
    TOP 10 SI.StockItemID,
    SI.StockItemName,
    SUM(IL.Quantity) AS TotalQuantitySold
FROM Warehouse.StockItems SI
LEFT JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY TotalQuantitySold DESC;


--Lowest Demand Items
SELECT 
    TOP 10 SI.StockItemID,
    SI.StockItemName,
    SUM(IL.Quantity) AS TotalQuantitySold
FROM Warehouse.StockItems SI
LEFT JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY TotalQuantitySold ASC;

--2.What seasonal trends does the product follow? What are the most popular products that are sold each year?
--By Year
SELECT 
    SI.StockItemID,
    SI.StockItemName,
	YEAR(I.InvoiceDate) AS Year,
    SUM(IL.Quantity) AS TotalQuantitySold
FROM Sales.Invoices I
INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
GROUP BY YEAR(I.InvoiceDate), SI.StockItemID, SI.StockItemName
ORDER BY TotalQuantitySold DESC;


--By Month
SELECT 
    SI.StockItemID,
    SI.StockItemName,
    SUM(IL.Quantity) AS TotalQuantitySold,
	MONTH(I.InvoiceDate) AS Month,
	YEAR(I.InvoiceDate) AS Year
FROM Sales.Invoices I
INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
GROUP By MONTH(I.InvoiceDate), YEAR(I.InvoiceDate),SI.StockItemID, SI.StockItemName
ORDER BY TotalQuantitySold DESC;

--3.Which vendors are the least reliable? Which suppliers have the most late deliveries?

SELECT 
    S.SupplierID,
    S.SupplierName,
    COUNT(*) AS LateDeliveries
FROM Purchasing.PurchaseOrders PO
JOIN Purchasing.Suppliers S ON PO.SupplierID = S.SupplierID
JOIN Purchasing.PurchaseOrderLines POL ON PO.PurchaseOrderID = POL.PurchaseOrderID
JOIN Warehouse.StockItems SI ON POL.StockItemID = SI.StockItemID
JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
WHERE I.ConfirmedDeliveryTime > PO.ExpectedDeliveryDate
  AND I.ConfirmedDeliveryTime IS NOT NULL
  AND PO.ExpectedDeliveryDate IS NOT NULL
GROUP BY S.SupplierID, S.SupplierName
ORDER BY LateDeliveries DESC;

--4.Which products are outliers in terms of sales and volume and revenue. Which products exhibit a notable deviation from average performance?

SELECT 
    SI.StockItemID,
    SI.StockItemName,
    SUM(IL.Quantity) AS TotalQuantitySold,
    SUM(IL.UnitPrice * IL.Quantity) AS TotalRevenue,
    (SUM(IL.Quantity) - AvgQuantitySold) / AvgQuantitySold AS SalesDeviation,
     ROUND((SUM(IL.UnitPrice * IL.Quantity) - AvgRevenue) / AvgRevenue, 2) AS RevenueDeviation
FROM Sales.InvoiceLines IL
INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
CROSS JOIN (
    SELECT 
        AVG(SUM(IL.Quantity)) OVER () AS AvgQuantitySold,
        AVG(SUM(IL.UnitPrice * IL.Quantity)) OVER () AS AvgRevenue
    FROM Sales.InvoiceLines IL
    GROUP BY IL.StockItemID
) AS AvgData
GROUP BY SI.StockItemID, SI.StockItemName, AvgQuantitySold, AvgRevenue
HAVING ABS((SUM(IL.Quantity) - AvgQuantitySold) / AvgQuantitySold) > 1.5 
    OR ABS((SUM(IL.UnitPrice * IL.Quantity) - AvgRevenue) / AvgRevenue) > 1.5
ORDER BY RevenueDeviation DESC, SalesDeviation DESC;


-----------------------------------------------------------------------END----------------------------------------------------------------------------------------------------------------