/* Homework 4 */
USE QATestTool;

/* 2. Create a temp table and populate the data for each member that will show how many orders a member has placed.
Show results of querying the table. */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, COUNT(o.OrderID) AS 'Orders'
INTO #tempMemberOrderCount
FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
GROUP BY m.MemberID, m.FirstName, m.MiddleName, m.LastName

SELECT * FROM #tempMemberOrderCount;

/* 4. Create a query that adds Routing Number and Account number together. (not concat) */
SELECT RoutingNum, BankAcctNum,
(CAST(RoutingNum AS bigint)+CAST(BankAcctNum AS bigint)) AS 'Sum' FROM dbo.MembersPaymentType
WHERE RoutingNum IS NOT NULL AND BankAcctNum IS NOT NULL;

/* 5. Create a query that shows all order dates in the Italian format. */
SELECT OrderID, FORMAT(OrderDate,'d','it-IT') AS 'Order Date Italian Format' FROM dbo.Orders

/* 6.Create a query that returns all orders placed in a year that were not processed until the following year. */
/*SELECT OrderID, OrderDate, ProcessedDate FROM dbo.Orders
WHERE DATEDIFF(YEAR, OrderDate,ProcessedDate) = 1; */

SELECT OrderID, OrderDate, ProcessedDate FROM dbo.Orders
WHERE DATEDIFF(YEAR, OrderDate,ProcessedDate) >= 1;

/* 7. Create a new view that shows the number of members per store, how many orders have been placed for each store,
and the average number of orders per member for each store. */
/*GO
CREATE VIEW viewStoreStats2
AS
SELECT s.StoreName, COUNT(DISTINCT(o.CustomerID)) AS 'Members/Store', COUNT(o.OrderID) AS 'Order/Store',
COUNT(o.OrderID)/COUNT(DISTINCT(o.CustomerID)) AS 'Ave. Orders/Member/Store'
FROM dbo.Stores AS s
LEFT OUTER JOIN dbo.Orders AS o ON s.StoreID = o.StoreID
GROUP BY s.StoreName;
GO 
GO
CREATE VIEW viewStoreStats2
AS
SELECT s.StoreName, COUNT(DISTINCT(m.CustomerID)) AS 'Members/Store', COUNT(DISTINCT(o.OrderID)) AS 'Order/Store',
CAST(COUNT(DISTINCT(o.OrderID)) AS float)/CAST(COUNT(DISTINCT(o.CustomerID)) AS float) AS 'Ave. Orders/Member/Store' FROM dbo.Members AS m
FULL OUTER JOIN dbo.Stores AS s ON RIGHT(m.MemberID,3) = s.StoreCode
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
GROUP BY s.StoreName;
GO */

GO
CREATE VIEW viewStoreStats2
AS
SELECT s.StoreName, COUNT(DISTINCT(m.CustomerID)) AS 'Members/Store', COUNT(DISTINCT(o.OrderID)) AS 'Order/Store',
CAST(COUNT(DISTINCT(o.OrderID)) AS float)/NULLIF(CAST(COUNT(DISTINCT(o.CustomerID)) AS float),0) AS 'Ave. Orders/Member/Store'
FROM dbo.Orders AS o
LEFT OUTER JOIN dbo.Stores AS s ON s.StoreID = o.StoreID
RIGHT OUTER JOIN dbo.Members AS m ON m.CustomerID = o.CustomerID
GROUP BY s.StoreName;
GO

/* 8. Add a new user to the database without using Insert or Merge. */
EXEC dbo.USP_AddMemberMach2
@MemberLevel = 'G',
@FirstName = 'Thancred',
@MiddleName = 'M',
@LastName = 'Waters',
@BirthDate = '1988-12-03',
@Gender = 'M',
@StoreCode = 110

/* 9. Place two orders using an existing stored procedure. 
One order must contain an item that will mark the FlaggedForReview column as 1
and the other must mark the column as a 0. Query the results to show both orders that were placed
and the items within the orders. */

EXEC dbo.USP_NewOrder
@CustomerID = 50,
@StoreID = 7,
@ShipToAddressID = 366,
@ProductID = 190,
@Quantity = 1;

EXEC dbo.USP_NewOrder
@CustomerID = 100,
@StoreID = 8,
@ShipToAddressID = 1162,
@ProductID = 7,
@Quantity = 1;

SELECT o.OrderID, p.Name AS 'Item', o.OrderDate, o.FlaggedForReview FROM dbo.Orders AS o
INNER JOIN dbo.OrderLookup AS ol ON o.OrderID = ol.OrderID
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID
WHERE o.CustomerID IN (50,100) AND o.OrderDate = CONVERT(DATE,GETDATE());

/* 10. Create a query that shows stock levels for items as well as a case statement that adds a comment
for Under Stocked, Stocked, Well Stocked, and Over Stocked. Break points are 21, 41 and 52 */
/*SELECT p.Name, p.Brand, p.Description, p.QuantityInStock, "Stock Levels" =
CASE
	WHEN p.QuantityInStock <= 21 THEN 'Under Stocked'
	WHEN p.QuantityInStock <= 41 THEN 'Stocked'
	ELSE 'Over Stocked'
END
FROM dbo.Product p
ORDER BY p.ProductID */
SELECT p.Name, p.Brand, p.Description, p.QuantityInStock, "Stock Levels" =
CASE
	WHEN p.QuantityInStock < 0 THEN 'Negative Stock'
	WHEN p.QuantityInStock <= 21 THEN 'Under Stocked'
	WHEN p.QuantityInStock <= 41 THEN 'Stocked'
	WHEN p.QuantityInStock <= 52 THEN 'Well Stocked'
	ELSE 'Over Stocked'
END
FROM dbo.Product p
ORDER BY p.ProductID

/* 11. Create a query that uses a PIVOT to show how many members joined each store per month. */
WITH BaseQuery AS
(
	SELECT m.CustomerID,s.[StoreName], MONTH(m.AccountCreationDate) AS 'Month' FROM dbo.Members as m
	INNER JOIN dbo.Stores as s ON RIGHT(m.MemberID,3) = s.StoreCode
)
SELECT [StoreName], [01] AS [JAN], [02] AS [FEB], [03] AS [MAR], [04] AS [APR], [05] AS [MAY],
[06] AS [JUN], [07] AS [JUL], [08] AS [AUG], [09] AS [SEP], [10] AS [OCT], [11] AS [NOV], [12] AS [DEC]
FROM BaseQuery
PIVOT
(
	COUNT(CustomerID)
	FOR [Month] IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
)
	AS PivotTable;

/* End of Homework 4 */