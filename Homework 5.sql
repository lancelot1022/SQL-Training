/* Homework 5 */
USE QATestTool;

/* 3. Create a script that tests the USP_AddMemberMach2 stored procedure
and includes comments that explain what’s happened in each section. Log your test results in the TestResults table.
Include a positive test and a negative test. MemberLevel = S, G or P only. */

/*
Test Case 01
Title:		Verify Stored Procedure USP_AddMemberMach2
Scenario:	1. Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters
			2. Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters
*/

-- SETUP: Create a temporary table from dbo.Members as control unit. Delete existing temporary table with the same name.
/*DROP TABLE IF EXISTS  #tempMemberTC01
GO
SELECT * INTO #tempMemberTC01 FROM dbo.Members

-- Variable declarations.
DECLARE @origMemberCount INT = 0;
DECLARE @newMemberCount INT = 0;

--DECLARE @origMemberCountSc02 INT = 0;
--DECLARE @newMemberCountSc02 INT = 0;

DECLARE @varMemberLvl CHAR(1);
DECLARE @varFirstName VARCHAR(25);
DECLARE @varMiddleName VARCHAR(24);
DECLARE @varLastName VARCHAR(50);
DECLARE @varBirthDate DATE;
DECLARE @varGender CHAR(1);
DECLARE @varStoreCode VARCHAR(3);

-- Scenario 01:
-- Set SP parameter values.
SET @varMemberLvl = 'G';
SET @varFirstName = 'InvalidFirstNameExceedingAllowedNumberOfCharacters';
SET @varMiddleName = 'A';
SET @varLastName = 'Smith';
SET @varBirthDate = '1966-03-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 01 Validation:
IF(@origMemberCount = @newMemberCount)
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','PASS',@origMemberCount,@newMemberCount,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','FAIL',@origMemberCount,@newMemberCount,SYSTEM_USER,GETDATE())

-- Scenario 2
-- Set SP parameter values.
SET @varMemberLvl = 'S';
SET @varFirstName = 'Alex';
SET @varMiddleName = 'N';
SET @varLastName = 'Medoza';
SET @varBirthDate = '1982-06-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Execute Store Procedure.
EXEC dbo.USP_AddMemberMach2
@MemberLevel = @varMemberLvl,
@FirstName = @varFirstName,
@MiddleName = @varMiddleName,
@LastName = @varLastName,
@BirthDate = @varBirthDate,
@Gender = @varMemberLvl,
@StoreCode = @varStoreCode

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount  = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 02 Validation:
IF(@origMemberCount  < @newMemberCount )
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','PASS',@origMemberCount+1,@newMemberCount ,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','FAIL',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())

-- View Test Results
SELECT * FROM dbo.TestResults

DROP TABLE IF EXISTS  #tempMemberTC01
GO
SELECT * INTO #tempMemberTC01 FROM dbo.Members

-- Variable declarations.
DECLARE @origMemberCount INT = 0;
DECLARE @newMemberCount INT = 0;

--DECLARE @origMemberCountSc02 INT = 0;
--DECLARE @newMemberCountSc02 INT = 0;

DECLARE @varMemberLvl CHAR(1);
DECLARE @varFirstName VARCHAR(25);
DECLARE @varMiddleName VARCHAR(24);
DECLARE @varLastName VARCHAR(50);
DECLARE @varBirthDate DATE;
DECLARE @varGender CHAR(1);
DECLARE @varStoreCode VARCHAR(3);

-- Scenario 01:
DECLARE @testIdCount1 INT = (SELECT COUNT(*) FROM dbo.TestResults);

-- Set SP parameter values.
SET @varMemberLvl = 'G';
SET @varFirstName = 'InvalidFirstNameExceedingAllowedNumberOfCharacters';
SET @varMiddleName = 'A';
SET @varLastName = 'Smith';
SET @varBirthDate = '1966-03-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 01 Validation:
IF(@origMemberCount < @newMemberCount)
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','PASS',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount1,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','FAIL',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())

-- Scenario 2
DECLARE @testIdCount2 INT = (SELECT COUNT(*) FROM dbo.TestResults);

-- Set SP parameter values.
SET @varMemberLvl = 'S';
SET @varFirstName = 'Alex';
SET @varMiddleName = 'N';
SET @varLastName = 'Medoza';
SET @varBirthDate = '1982-06-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Execute Store Procedure.
EXEC dbo.USP_AddMemberMach2
@MemberLevel = @varMemberLvl,
@FirstName = @varFirstName,
@MiddleName = @varMiddleName,
@LastName = @varLastName,
@BirthDate = @varBirthDate,
@Gender = @varMemberLvl,
@StoreCode = @varStoreCode

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount  = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 02 Validation:
IF(@origMemberCount < @newMemberCount )
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount2,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','PASS',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount2,'Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','FAIL',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())

-- View Test Results
SELECT * FROM dbo.TestResults
*/

-- Submission 3
-- Deletes temparary table if it exists
DROP TABLE IF EXISTS  #tempMemberTC01
GO
SELECT * INTO #tempMemberTC01 FROM dbo.Members

-- Variable declarations.
DECLARE @origMemberCount INT = 0;
DECLARE @newMemberCount INT = 0;

DECLARE @varMemberLvl CHAR(1);
DECLARE @varFirstName VARCHAR(25);
DECLARE @varMiddleName VARCHAR(24);
DECLARE @varLastName VARCHAR(50);
DECLARE @varBirthDate DATE;
DECLARE @varGender CHAR(1);
DECLARE @varStoreCode VARCHAR(3);

-- Scenario 01:
-- Set TestID value for scenario 1
DECLARE @testIdCount1 INT = 1;

-- Set SP parameter values.
SET @varMemberLvl = 'G';
SET @varFirstName = 'InvalidFirstNameExceedingAllowedNumberOfCharacters';
SET @varMiddleName = 'A';
SET @varLastName = 'Smith';
SET @varBirthDate = '1966-03-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 01 Execution:
IF(@origMemberCount < @newMemberCount)
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount1,'Scenario 01: Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','PASS',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount1,'Scenario 01: Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Invalid paramters','FAIL',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())

-- Scenario 2
-- Set TestID value for scenario 2
DECLARE @testIdCount2 INT = 2;

-- Set SP parameter values.
SET @varMemberLvl = 'S';
SET @varFirstName = 'Alex';
SET @varMiddleName = 'N';
SET @varLastName = 'Medoza';
SET @varBirthDate = '1982-06-01';
SET @varMemberLvl = 'M';
SET @varStoreCode = 110;

-- Execute Store Procedure.
EXEC dbo.USP_AddMemberMach2
@MemberLevel = @varMemberLvl,
@FirstName = @varFirstName,
@MiddleName = @varMiddleName,
@LastName = @varLastName,
@BirthDate = @varBirthDate,
@Gender = @varMemberLvl,
@StoreCode = @varStoreCode

-- Get member counts from temporary and actual Member tables.
SET @origMemberCount = (SELECT COUNT(*) FROM #tempMemberTC01)
SET @newMemberCount  = (SELECT COUNT(*) FROM dbo.Members)

-- Scenario 02 Execution:
IF(@origMemberCount < @newMemberCount )
	--PASS Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount2,'Scenario 02: Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','PASS',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())
ELSE
	--FAIL Result
	INSERT INTO dbo.TestResults VALUES
	(@testIdCount2,'Scenario 02: Verify Stored Procedure USP_AddMemberMach2','Create new member via SP: Procedure USP_AddMemberMach2 - Valid parameters','FAIL',@origMemberCount+1,@newMemberCount,SYSTEM_USER,GETDATE())

-- View Test Results
SELECT * FROM dbo.TestResults
/* End of Test Case 01 */

/* 5. Create two queries that shows each customer, their total number of orders, and
the total value of their most expensive order. The first query must use Joins, the second query must use Outer Apply.
Results of the queries should be the same. */
SELECT m.CustomerID, m.FirstName, m.MiddleName, m.LastName, COUNT(o.OrderID) AS 'Total Orders',
MAX(orderAmt.totalPrice) AS 'Most Expensive Order' FROM dbo.Members AS m
LEFT OUTER JOIN dbo.Orders AS o ON m.CustomerID = o.CustomerID
LEFT OUTER JOIN (SELECT ol.OrderID,SUM(p.Price*ol.QuantityPurchased) AS totalPrice FROM dbo.OrderLookup AS ol
INNER JOIN dbo.Product AS p ON ol.ProductID = p.ProductID GROUP BY ol.OrderID) orderAmt
ON o.OrderID = orderAmt.OrderID
GROUP BY m.CustomerID, m.FirstName, m.MiddleName, m.LastName,m.CustomerID
ORDER BY m.CustomerID;

SELECT m.CustomerID, m.FirstName, m.MiddleName, m.LastName, COUNT(ORD.OrderID) AS 'Total Orders',
MAX(AMT.totalPrice) AS 'Most Expensive Order' FROM dbo.Members AS m
OUTER APPLY(SELECT * FROM dbo.Orders AS o WHERE o.CustomerID = m.CustomerID) ORD
OUTER APPLY(SELECT ol.OrderID,SUM(PRD.Price*ol.QuantityPurchased) AS totalPrice FROM dbo.OrderLookup AS ol
OUTER APPLY(SELECT p.Price FROM dbo.Product AS p WHERE ol.ProductID = p.ProductID ) PRD 
WHERE ORD.OrderID = ol.OrderID GROUP BY ol.OrderID) AMT
GROUP BY m.CustomerID, m.FirstName, m.MiddleName, m.LastName,m.CustomerID
ORDER BY m.CustomerID;

/* 6. Create a query that returns all columns that contain “Store” and the table they belong to. */
SELECT COLUMN_NAME, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Store%';

/* 7.Create a query that shows all available collations that are case sensitive, accent insensitive and
have supplementary characters.*/
/*SELECT COLLATION_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLLATION_NAME LIKE '%_CS%' AND COLLATION_NAME LIKE '%_AI%'AND COLLATION_NAME LIKE '%_SC%'

SELECT db.Name, fn.Name FROM SYS.DATABASES db
INNER JOIN SYS.FN_HELPCOLLATIONS() fn ON db.collation_name = fn.Name
WHERE fn.Name LIKE '%_CS%' AND fn.Name LIKE '%_AI%'AND fn.Name LIKE '%_SC%'

-- Hi Zach, I'm not sure if the query should only result to collations that are exclusively CS, AI and SC (1st query) or
-- it should also display collations with additional settings (2nd query). In both query I can't get the expected result
-- of 388 results.
SELECT * FROM SYS.FN_HELPCOLLATIONS() fn
WHERE fn.Name LIKE '%_CS_AI_SC%';

SELECT * FROM SYS.FN_HELPCOLLATIONS() fn
WHERE CHARINDEX('_CS',fn.Name) > 0
AND CHARINDEX('_AI',fn.Name) > 0
AND CHARINDEX('_SC',fn.Name) > 0
*/
-- Submission 3
SELECT * FROM SYS.FN_HELPCOLLATIONS() fn
WHERE fn.description LIKE '%case-sensitive%accent-insensitive%supplementary characters%UTF8' 

/* End of Homework 5 */ 
