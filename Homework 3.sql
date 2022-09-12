/* Homework 3 */
USE QATestTool;

/* 1. Create a query that will return each person and how many of each address type they have. */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, t.AddressName, COUNT(a.AddressTypeID) AS 'Address Type Count' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.MemberAddress AS a ON m.CustomerID = a.CustomerID
LEFT OUTER JOIN dbo.AddressType AS t ON a.AddressTypeID = t.AddressTypeID
GROUP BY m.MemberID, m.FirstName, m.MiddleName, m.LastName, t.AddressName

/* 2. Create a query that will return each members’ total number of 
orders, the total of their purchase prices and the average purchase price for each customer. */
/*SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, COUNT(o.OrderID) AS 'Total No. Order',
SUM(p.AmountPaid) AS 'Total Purchase Price', AVG(p.AmountPaid) AS 'Average Purchase Price' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
LEFT OUTER JOIN dbo.Payments AS p ON o.OrderID = p.OrderID
GROUP BY m.MemberID, m.FirstName, m.MiddleName, m.LastName ORDER BY m.FirstName;*/

SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, COUNT(o.OrderID) AS 'Total Orders',
SUM(orderAmt.totalPrice) AS 'Total Purchase Price', AVG(orderAmt.totalPrice) AS 'Average Purchase Price' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
LEFT OUTER JOIN (SELECT ol.OrderID, SUM(p.Price*ol.QuantityPurchased) AS totalPrice FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID GROUP BY ol.OrderID) orderAmt
ON o.OrderID = orderAmt.OrderID
GROUP BY m.MemberID, m.FirstName, m.MiddleName, m.LastName,m.CustomerID
ORDER BY m.FirstName;

/* 3. Create a query that will return the current total value of inventory. */ 
SELECT SUM(Price * QuantityInStock) AS 'Total Value of Inventory' FROM dbo.Product;

/* 4. Create a query that will return the minimum, maximum and average prices of all orders. */
SELECT MIN(OrderSum) AS 'Min Order Price', MAX(OrderSum) AS 'Max Order Price', AVG(OrderSum) AS 'Average Order Price'
FROM (SELECT SUM(ol.QuantityPurchased * p.Price) AS OrderSum FROM dbo.Orders AS o
INNER JOIN dbo.OrderLookup AS ol ON o.OrderID = ol.OrderID
INNER JOIN dbo.Product AS p ON p.ProductID = ol.ProductID
GROUP BY o.OrderID) OrderPrice

/* 5. Create a query that will return items that have been ordered more than ten times
but less than twenty times. Display by count from highest to lowest. */
/*SELECT p.Name AS 'Item',p.Brand, p.Description, COUNT(ol.ProductID) AS OrderCount FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID
GROUP BY p.Name, p.Brand, p.Description
HAVING COUNT(ol.ProductID) BETWEEN 11 AND 20
ORDER BY OrderCount DESC;*/

SELECT p.Name AS 'Item',p.Brand, p.Description, COUNT(ol.ProductID) AS OrderCount FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID
GROUP BY p.Name, p.Brand, p.Description
HAVING COUNT(ol.ProductID) BETWEEN 11 AND 19
ORDER BY OrderCount DESC;

/* 6. Return all members with more than 1 of a non primary address type and the count of each address type. */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, t.AddressName, n.AddressTypeID, n.IsPrimary,
COUNT(n.AddressTypeID) AS 'Address Type Count' FROM dbo.Members AS m
INNER JOIN dbo.MemberAddress AS n ON m.CustomerID = n.CustomerID
INNER JOIN dbo.AddressType AS t ON n.AddressTypeID = t.AddressTypeID
WHERE n.IsPrimary = 0
GROUP BY m.MemberID, m.FirstName, m.MiddleName, m.LastName, t.AddressName,n.AddressTypeID, n.IsPrimary
HAVING COUNT(n.IsPrimary) > 1;

/* 7. Create a query that searches for items based on a variable value. */
/*DECLARE @brand VARCHAR(255) = 'Goodyear';
SELECT Name, Brand, Description, Price, QuantityInStock FROM dbo.Product
WHERE Brand = @brand
ORDER BY Name;*/

DECLARE @searchString VARCHAR(255) = '%Fishing%';
SELECT Name, Brand, Description, Price, QuantityInStock FROM dbo.Product
WHERE Name LIKE @searchString OR Brand LIKE @searchString OR Description LIKE @searchString
ORDER BY Name;

/* 8. Create a query that shows how many phone numbers are in the same area code
and the number of unique members from those area codes. */
/*SELECT LEFT(PhoneNumber,3) AS AreaCode, COUNT(LEFT(PhoneNumber,3)) AS 'Area Code Phone No. Count',
COUNT(DISTINCT CustomerID) AS 'Unique Member Count' FROM dbo.PhoneNumber
GROUP BY LEFT(PhoneNumber,3)*/

SELECT LEFT(ISNULL(p.PhoneNumber,0),3) AS AreaCode, COUNT(LEFT(ISNULL(p.PhoneNumber,0),3)) AS 'Area Code Phone No. Count',
COUNT(DISTINCT m.CustomerID) AS 'Unique Member Count' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.PhoneNumber AS p ON m.CustomerID = p.CustomerID
GROUP BY LEFT(ISNULL(p.PhoneNumber,0),3)

/* 9. Create a query that displays member phone numbers in the standard US format */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName,
FORMAT(CAST(p.PhoneNumber AS NUMERIC),'(###) ###-####') AS 'Phone Number' FROM dbo.Members AS m
INNER JOIN dbo.PhoneNumber AS p ON m.CustomerID = p.CustomerID
ORDER BY m.MemberID

/* 10. Create a query that returns two columns of data:
the average price of all orders that have been placed (do not limit decimal places)
and the average price of all orders that have been placed rounded to 4 decimal places. */
SELECT AVG(OrderSum) AS 'Ave. Order Total Price', CAST(ROUND(AVG(OrderSum),4) AS NUMERIC(19,4)) AS 'Rounded Ave. Total Price'
FROM (SELECT SUM(ol.QuantityPurchased * p.Price) AS OrderSum FROM dbo.Orders AS o
INNER JOIN dbo.OrderLookup AS ol ON o.OrderID = ol.OrderID
INNER JOIN dbo.Product AS p ON p.ProductID = ol.ProductID
GROUP BY o.OrderID) OrderPrice

/* 11.	Create a query that tells us how long the longest last name is and how long the shortest last name is and show the names. */
/*SELECT MemberID, FirstName, MiddleName, LastName, LEN(LastName) AS LastNameLength FROM dbo.Members
WHERE LEN(LastName) 
IN ((SELECT MAX(LEN(LastName)) FROM dbo.Members),(SELECT MIN(LEN(LastName)) FROM dbo.Members))
ORDER BY LastNameLength DESC;

DECLARE @maxLastName INT = (SELECT MAX(LEN(LastName)) FROM dbo.Members);
DECLARE @minLastName INT = (SELECT MIN(LEN(LastName)) FROM dbo.Members);

SELECT MemberID, FirstName, MiddleName, LastName, LEN(LastName) AS LastNameLength FROM dbo.Members
WHERE LEN(LastName) 
IN (@maxLastName, @minLastName)
ORDER BY LastNameLength DESC;*/
DECLARE @maxLastName INT = (SELECT MAX(LEN(LastName)) FROM dbo.Members);
DECLARE @minLastName INT = (SELECT MIN(LEN(LastName)) FROM dbo.Members);

SELECT LastName, LEN(LastName) AS LastNameLength FROM dbo.Members
WHERE LEN(LastName) 
IN (@maxLastName, @minLastName)
GROUP BY LastName
ORDER BY LastNameLength DESC;

/* 12. Create a query that only returns half of the products from the database. */
SELECT TOP 50 PERCENT * FROM dbo.Product;

/* 13. Create a query that shows how many days have passed since the first order was placed. */
SELECT DATEDIFF(day,MIN(OrderDate), GETDATE()) AS 'Days Passed' FROM dbo.Orders;

/* 14. Create a query that adds a new person to the members table. */
INSERT INTO dbo.Members
(MemberID,FirstName,MiddleName,LastName,BirthDate,Gender,AccountCreationDate,StatusID)
VALUES('P031282320','Alphinaud','N','Leveilleur','1992-10-22','M',GETDATE(),1)

/* 15. Create a query that updates the middlename and birthdate of the user added in question 14. */
UPDATE dbo.Members
SET MiddleName = 'S', BirthDate = '1988-12-03'
WHERE FirstName = 'Alphinaud' AND LastName = 'Leveilleur';

--UPDATED answer:
UPDATE dbo.Members
SET MiddleName = 'S', BirthDate = '1988-12-03'
WHERE MemberID ='P031282320' AND FirstName = 'Alphinaud' AND LastName = 'Leveilleur';

/* End of Homework 3 */
