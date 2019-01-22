-- Creare vedere si operatii pe aceasta

-- P1 - Deschideti o fereastra noua si executati

USE northwind; --sau alta B.D. 
GO

-- P2 - Creati o vedere noua
--      (va extrage clientii care au telefon)

CREATE VIEW dbo.Fax_clienti_xx --xx este numarul dvs. de user
AS
SELECT CustomerID , ContactTitle , ContactName, City, Address 
FROM Customers AS c
WHERE c.Phone IS NOT NULL;
GO

-- P3 - Interogati vederea

SELECT * FROM dbo.Fax_clienti_xx;
GO

-- P4 - Interogati vederea ordonand rezultatele

SELECT * 
FROM dbo.Fax_clienti_xx
ORDER BY CustomerID, ContactTitle;
GO

-- P5 - Afisati corpul vederii  via OBJECT_DEFINITION 

SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.Fax_clienti_xx',N'V'));
GO
--sau 
sp_helptext 'dbo.Fax_clienti_xx' --compatibila cu versiuni mai vechi de SQL Server

-- P6 - Modificati vederea pt. a folosi WITH ENCRYPTION

ALTER VIEW dbo.Fax_clienti_xx
WITH ENCRYPTION
AS
SELECT CustomerID, ContactTitle, ContactName, City, Address 
FROM Customers AS c
WHERE c.Phone IS NOT NULL;

-- P7 - Afisati corpul vederii, din nou, via OBJECT_DEFINITION

SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.Fax_clienti_xx',N'V'));
GO
--sau 
sp_helptext 'dbo.Fax_clienti_xx' --compatibila cu versiuni mai vechi de SQL Server

select OBJECT_id('dbo.Fax_clienti_xx') --viz. ID vedere
select OBJECT_NAME (430624577)--viz. nume vedere
SELECT * --vizualizare text vedere
  FROM [Northwind].[sys].[syscomments]
  where id=430624577

-- P8 Vom recrea vederea dbo.Fax_clienti_xx cu textul continut initial

ALTER VIEW dbo.Fax_clienti_xx
AS
SELECT CustomerID, ContactTitle, ContactName, City, Address 
FROM Customers AS c
WHERE c.Phone IS NOT NULL;

-- P9 - Scriptare vedere dbo.Fax_clienti_xx  
--           (In Object Explorer, in database Northwind, expandati Views. Right-click
--           dbo.Fax_clienti_xx, click Script View As, click CREATE to, click New Query Editor Window)

-- P10 - Stergere vedere

DROP VIEW dbo.Fax_clienti_xx;
GO