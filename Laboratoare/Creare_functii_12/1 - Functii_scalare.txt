--P1 Stabilire B.D. implicita
USE [Northwind] -- sau alta B.D. de pe serverul SQL
GO


--P2 Creare functie scalara fn_FormatareData_xx 
--   (formateaza data calendaristica transmisa ca parametru la apel)
--    xx este nr. dv. de user (01, 02, etc)

CREATE FUNCTION [dbo].[fn_FormatareData_xx]
(
	-- Adauga parametrii functiei aici
	@indata datetime, @separator char(1)
)
RETURNS nvarchar(20) --tipul de data returnat
AS
BEGIN
	
	
	RETURN CONVERT(nvarchar(20),DATEPART(dd, @indata))
	+@separator
	+CONVERT(nvarchar(20),DATEPART(mm, @indata))
	+@separator
	+CONVERT(nvarchar(20),DATEPART(yyyy, @indata))
END

--P3 Apelul functiei dbo.fn_FormatareData_xx

SELECT dbo.fn_FormatareData_xx(GETDATE(), '/') [Data de astazi]

--P4 Stergerea functiei dbo.fn_FormatareData_xx

DROP FUNCTION dbo.fn_FormatareData_xx
GO

--P5 A doua functie scalara: fn_newRegion_xx
--   Afiseaza regiunea (valoarea cp. Region ) din tabelul Employees
--   sau 'Valoare neintrodusa!', daca val. cp. Region este neintrodusa.

CREATE FUNCTION [dbo].[fn_newRegion_xx] 
(
	@regiune nvarchar(30)
)
RETURNS nvarchar(30)
AS
BEGIN
	 IF @regiune is NULL
	 SET @regiune = 'Valoare neintrodusa!'

	-- Intoarce rezultatul
	RETURN @regiune

END

--P6 Apelul functiei [dbo].[fn_newRegion_xx] 

SELECT Lastname [Nume], City [Oras],
       dbo.[fn_newRegion_xx] (Region) [Regiune], Country [Tara]
FROM Employees


--P7 Stergerea functiei dbo.[fn_newRegion_xx]

DROP FUNCTION dbo.[fn_newRegion_xx]
GO

--P8 A treia functie scalara: fn_TaxaProduse_xx
--   Intoarce o rata de modificare a pretului unui produs
--   in functie de categoria din care face parte.

CREATE FUNCTION [dbo].[fn_TaxaProduse_xx] 
   (@ProdID INT)
RETURNS numeric(5,4)
AS
BEGIN
RETURN
(SELECT 
   CASE CategoryID 
      WHEN 1 THEN 1.10
      WHEN 2 THEN 1
      WHEN 3 THEN 1.10
      WHEN 4 THEN 1.05
      WHEN 5 THEN 1
      WHEN 6 THEN 1.05
      WHEN 7 THEN 1
      WHEN 8 THEN 1.05
   END Taxa
FROM Products  
WHERE ProductID = @ProdID)
END


--P9 Apelul functiei [dbo].[fn_TaxaProduse_xx]

SELECT ProductName [Nume produs], UnitPrice [Pret unitar],
        CategoryId [ID Categorie],[dbo].[fn_TaxaProduse_xx] (ProductId) [Rata de taxare],
        UnitPrice * [dbo].[fn_TaxaProduse_xx] (ProductId) [Pretul unitar modificat]
FROM Products
ORDER BY ProductID


--P10 Stergerea functiei dbo.[fn_newRegion_xx]

DROP FUNCTION [dbo].[fn_TaxaProduse_xx]
GO