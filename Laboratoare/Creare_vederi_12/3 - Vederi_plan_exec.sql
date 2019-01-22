
-- Demonstratie: Lucrul cu vederile si planurile de executie asociate

-- P1 - Deschideti o interogare noua in B.D. Northwind

USE northwind;
GO

--P2 - Creare vedere dbo.Czi_angajat_xx

CREATE VIEW dbo.Czi_angajat_xx AS --xx este numarul user conectat la server
SELECT e.EmployeeID [Cod angajat],e.FirstName+' '+e.LastName [Nume angajat], 
       o.OrderDate [Data c-zii], o.OrderID [Nr. comanda]
FROM dbo.Employees AS e 
JOIN dbo.Orders AS o
ON e.EmployeeID = o.EmployeeID;
GO

-- P3 - Interogati vederea si vizualizati planul de executie

SELECT * FROM dbo.Czi_angajat_xx order by [Nume angajat],[Data c-zii];
GO

-- P4 - Stergeti vederea

DROP VIEW dbo.Czi_angajat_xx;
GO

-- P5 - Creati alta vedere (dbo.Vanz_prod_xx)

CREATE VIEW dbo.Vanz_prod_xx
AS
SELECT        o.OrderID,  o.OrderDate, p.ProductID, p.ProductName, p.CategoryID
FROM            dbo.Products AS p INNER JOIN
                         dbo.[Order Details] AS od ON p.ProductID = od.ProductID INNER JOIN
                         dbo.Orders AS o ON od.OrderID = o.OrderID
GO

-- P6 - Vizualizati simultan cele doua planuri de interogare (identice)

SELECT * 
FROM dbo.Vanz_prod_xx;
GO
-- si

SELECT OrderID,  OrderDate, ProductID
FROM dbo.Vanz_prod_xx;
GO

-- P7 - Evaluati planul de interogare

-- P8 - Stergeti vederea

DROP VIEW dbo.Vanz_prod_xx;
GO

