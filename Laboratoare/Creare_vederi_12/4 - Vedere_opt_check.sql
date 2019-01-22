--  Folosire optiune WITH CHECK OPTION pt. o vedere

-- P1 Se stabileste B.D. de lucru si apoi se creaza vederea
USE Northwind
GO

CREATE VIEW dbo.Produse_xx ---xx este nr. user conectat la server UTM
AS
SELECT ProductID, ProductName, SupplierID, CategoryID
FROM Products 
WHERE SupplierID = 14
WITH CHECK OPTION

--P2 Vizualizare cod si certificare ca textul e introdus in clar

sp_helptext 'dbo.Produse_xx'
GO

--sau
SELECT * FROM sys.syscomments WHERE id=OBJECT_ID('dbo.Produse_xx')--vezi cp. encrypted si cp. text

--sau
SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.Produse_xx',N'V'));
GO

--P3 Vizualizare dependente (obiecte care depind/ de care depinde) vedere

sp_depends Produse_xx
-- sau click dreapta pe numele vederii---> View Dependencies


--P4 Actualizare tabela Products prin vederea creata anterior cu date care nu respecta clauza CHECK
--inainte se listeaza tabela Products pt. SupplierID = 14
SELECT * from Products where SupplierID = 14
--apoi

UPDATE dbo.Produse_xx
SET SupplierID = 12 WHERE ProductID = 31 
--Mesajul primit este:

Msg 550, Level 16, State 1, Line 1
The attempted insert or update failed because the target view either specifies WITH CHECK OPTION or spans a view that specifies WITH CHECK OPTION and one or more rows resulting from the operation did not qualify under the CHECK OPTION constraint.
The statement has been terminated.

--Se poate schimba numele unui produs:
-- UPDATE dbo.Produse_xx
-- SET ProductName = ProductName+'_nou' WHERE ProductID = 31
--Refacere:
-- UPDATE dbo.Produse_xx
-- SET ProductName = substring(ProductName,1,charindex('_nou',ProductName)-1)
--            WHERE ProductID = 31


--P5 Localizare definitie vederi:
SELECT * FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE
WHERE view_name='Produse_xx' -- se listeaza coloanele referentiate in vedere si tabelele de provenienta


SELECT * FROM INFORMATION_SCHEMA.VIEW_TABLE_USAGE
WHERE view_name='Produse_xx' -- se listeaza  tabelele folosite de vedere

--P6 Se sterge vederea:

DROP VIEW Produse_xx

