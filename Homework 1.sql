/* Homework 1 - submission 2*/
USE QATestTool;

/* 4. Create a query that will return the full name and birthdate of each member. */
/* SELECT CONCAT(FirstName,' ', MiddleName,' ', LastName) AS 'Full Name', BirthDate FROM dbo.Members; */
SELECT FirstName, MiddleName, LastName, BirthDate FROM dbo.Members;

/* 5. Create a query that will return the first 300 records in a table. */
SELECT TOP 300 * FROM dbo.MemberAddress;

/* 7. Create a query that returns all addresses from Montana */
/* SELECT AddressLine1 AS 'Address' FROM dbo.MemberAddress
WHERE StateAbbreviation = 'MT'; */
SELECT * FROM dbo.MemberAddress
WHERE StateAbbreviation = 'MT';

/* 8. Create a query that returns each product and its price with a price of $28.00 or more. */
SELECT Name,Price FROM dbo.Product
WHERE Price >= 28.00;

/* 9. Create a query that returns all orders placed from September 1 to September 30 of last year. */
/* SELECT * FROM dbo.Orders
WHERE OrderDate BETWEEN DATEADD(YEAR,-1,CONCAT(YEAR(GETDATE()),'-09-01'))
AND DATEADD(YEAR,-1,CONCAT(YEAR(GETDATE()),'-09-30')); */
SELECT * FROM dbo.Orders
WHERE OrderDate BETWEEN '09-01-2020' AND '09-30-2020';

/* 10. Create a query that returns all orders placed excluding orders between September 1 and September 30 of last year. */
/* SELECT * FROM dbo.Orders
WHERE OrderDate NOT BETWEEN DATEADD(YEAR,-1,CONCAT(YEAR(GETDATE()),'-09-01'))
AND DATEADD(YEAR,-1,CONCAT(YEAR(GETDATE()),'-09-30')); */
SELECT * FROM dbo.Orders
WHERE OrderDate NOT BETWEEN '09-01-2020' AND '09-30-2020';
 
/* End of Homework 1 */