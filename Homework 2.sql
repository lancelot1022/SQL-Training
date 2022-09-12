/* Homework 2 - submission 2*/
USE QATestTool;

/* 1. Create a query that returns members who have placed orders and their placed orders. */
/*SELECT CONCAT(m.FirstName,' ', m.MiddleName,' ', m.LastName) AS 'Members', o.OrderID AS 'Placed Order' FROM dbo.Members AS m
INNER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID; */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName,
o.OrderID, o.OrderDate, o.ProcessedDate, o.ShippedDate FROM dbo.Members AS m
INNER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
ORDER BY MemberID;

/* 2.	Create a query that returns any members that have not placed an order. */
/*SELECT CONCAT(m.FirstName,' ', m.MiddleName,' ', m.LastName) AS 'Members' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL; */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, o.OrderID, o.OrderDate FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

/*3. Create a query that returns all female members with a first name that starts with C, or a last name that starts with W. */
/*SELECT CONCAT(FirstName,' ', MiddleName,' ', LastName) AS 'Members' FROM dbo.Members
WHERE (FirstName LIKE 'C%' OR LastName LIKE 'W%') AND Gender = 'F';*/

/*SELECT MemberID, FirstName, MiddleName, LastName FROM dbo.Members
WHERE Gender = 'F' AND (FirstName LIKE 'C%' OR LastName LIKE 'W%');*/

SELECT MemberID, FirstName, MiddleName, LastName FROM dbo.Members
WHERE (Gender = 'F' AND FirstName LIKE 'C%') OR LastName LIKE 'W%'
ORDER BY FirstName;

/* 4. Using a sub query, create a query that returns all members that have placed an order that was shipped to a secondary address. */
/*SELECT CONCAT(m.FirstName,' ', m.MiddleName,' ', m.LastName) AS 'Members' FROM dbo.Members AS m
INNER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
WHERE o.CustomerID IN (SELECT CustomerID FROM dbo.MemberAddress WHERE AddressTypeID = 2); 
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, o.OrderID FROM dbo.Members AS m
INNER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
WHERE o.CustomerID IN (SELECT CustomerID FROM dbo.MemberAddress WHERE IsPrimary = 0); 
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName FROM dbo.Members AS m
WHERE m.CustomerID IN    
(SELECT o.CustomerID FROM dbo.MemberAddress AS ma
INNER JOIN dbo.Orders AS o ON ma.CustomerID = o.CustomerID
WHERE IsPrimary = 0); */

SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName FROM dbo.Members AS m
WHERE m.CustomerID IN    
(SELECT o.CustomerID FROM dbo.MemberAddress AS ma
INNER JOIN dbo.Orders AS o ON ma.MemberAddressId = o.ShipToAddressID
WHERE IsPrimary = 0);

/* 6. Create a query that returns each person that lives in the state of MN or the city of Plymouth. */
/*SELECT CONCAT(m.FirstName,' ', m.MiddleName,' ', m.LastName) AS 'Person', n.StateAbbreviation AS 'State',
n.City AS 'City' FROM dbo.Members AS m
INNER JOIN dbo.MemberAddress AS n ON m.CustomerID = n.CustomerID
WHERE n.IsPrimary = 1 AND
n.StateAbbreviation = 'MN' OR n.City = 'Plymouth'; */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, n.StateAbbreviation,n.City FROM dbo.Members AS m
INNER JOIN dbo.MemberAddress AS n ON m.CustomerID = n.CustomerID
WHERE n.IsPrimary = 1 AND (n.StateAbbreviation = 'MN' OR n.City = 'Plymouth');

/* 7. Create a query that returns all members that have a Payment Type but have not made any Account Payments. */
/*SELECT CONCAT(m.FirstName,' ', m.MiddleName,' ', m.LastName) AS 'Members' FROM dbo.Members AS m
INNER JOIN dbo.MembersPaymentType AS n ON m.CustomerID = n.CustomerID
WHERE n.CustomerID NOT IN (SELECT CustomerID FROM dbo.MembershipAccountPayments); */
SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, n.AcctNickname, n.PaymentType,
n.NameOnAccount, n.CardNumber, n.RoutingNum, n.BankAcctNum FROM dbo.Members AS m
INNER JOIN dbo.MembersPaymentType AS n ON m.CustomerID = n.CustomerID
WHERE n.CustomerID NOT IN (SELECT CustomerID FROM dbo.MembershipAccountPayments);

/* 8. Create a query that returns any item that contains the word basketball. */
/*SELECT Name AS 'Item' FROM dbo.Product
WHERE Name LIKE '%basketball%' OR Description LIKE '%basketball%'; */

/*SELECT p.Name AS 'Item', p.Brand, p.Description AS 'Item Description',
d.DepartmentName, d.Description AS 'Department Description' FROM dbo.Product AS p
INNER JOIN dbo.ProductDepartment AS d ON p.DepartmentID = d.DepartmentID
WHERE p.Name LIKE '%basketball%' OR p.Description LIKE '%basketball%' OR d.Description LIKE '%basketball%'; */

SELECT p.Name, p.Brand, p.Description FROM dbo.Product AS p
WHERE p.Name LIKE '%basketball%' OR p.Description LIKE '%basketball%';

/* 9. Create a query that show how many of each item Charles Corbett ordered in each of their orders */
SELECT ol.OrderID AS 'Order', p.Name AS 'Item', ol.QuantityPurchased AS 'Quantity' FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Orders AS o ON ol.OrderID = o.OrderID
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID
INNER JOIN dbo.Members AS m ON o.CustomerID = m.CustomerID
WHERE m.FirstName = 'Charles' AND m.LastName = 'Corbett'
ORDER BY ol.OrderID;

SELECT m.MemberID, m.FirstName, m.MiddleName, m.LastName, ol.OrderID AS 'Order', p.Name AS 'Item', ol.QuantityPurchased AS 'Quantity' FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Orders AS o ON ol.OrderID = o.OrderID
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID
INNER JOIN dbo.Members AS m ON o.CustomerID = m.CustomerID
WHERE m.FirstName = 'Charles' AND m.LastName = 'Corbett'
ORDER BY ol.OrderID;

/* 10. Create a query that returns only the 100 most recent orders placed. */
SELECT TOP 100 OrderID, OrderDate FROM dbo.Orders
ORDER BY OrderDate DESC;

/*End of Homework 2*/
