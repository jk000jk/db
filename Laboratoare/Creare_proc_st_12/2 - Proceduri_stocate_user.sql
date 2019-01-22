--Lucrul cu proceduri stocate user
 
--P1	Vezi B.D. Northwind --->Programmability ---> Stored Procedures
--       ---> dbo.CustOrderHist (click dr.) ---> Modify
--	Afiseaza totalul produselor comandate de un client al carui ID este dat la executie,
--      in ordinea ascendenta a numelor de produse.

USE [Northwind]
GO
/****** Object:  StoredProcedure [dbo].[CustOrderHist]    Script Date: 17.10.2017 08:27:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CustOrderHist] @CustomerID nchar(5)
AS
SELECT ProductName [Nume produs], Total=SUM(Quantity)
FROM Products P, [Order Details] OD, Orders O, Customers C
WHERE C.CustomerID = @CustomerID
AND C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND OD.ProductID = P.ProductID
GROUP BY ProductName
return(@@rowcount) -- a fost adaugata



--	Click dr. pe procedura ---> Execute Stored Procedure
--	Nu se selecteaza Pass Null Value
--	Pt. tab Value se da o valoare (ex.: Alfki)
--	Se executa procedura
-- Codul Transact-SQL generat:

--USE [Northwind]
--GO

--DECLARE	@return_value int

--EXEC	@return_value = [dbo].[CustOrderHist]
--		@CustomerID = N'alfki'

--SELECT	'Return Value' = @return_value

--GO

--Instruct. SELECT se va inlocui cu 
--PRINT 'Linii returnate '+ str(@return_value)


-- P2	Creare procedura stocata cu parametri de intrare si iesire:

USE [Northwind]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Popescu Mihai
-- Create date: 9.11.2016
-- Description:	Imparte doua numere
-- =============================================
CREATE PROCEDURE [dbo].[Impartire_xx] -- xx este nr. user conectat
	-- Add the parameters for the stored procedure here
	@deimp real=1.0  ,  
	@imp real= 1,
	@rezultat real out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	if(@imp = 0)
		SELECT Rezultat='Impartire cu 0!--Nepermis!!!'
		else
		begin
		set @rezultat = @deimp / @imp --sau SELECT …
		end
END

--2.1	Executie procedura stocata prin transmitere nume de parametri

USE [Northwind]
GO

DECLARE	@return_value int,
		@rezultat real

EXEC	@return_value = [dbo].[Impartire_xx]
      	@deimp = 3,
		@imp = 1.5,
		@rezultat = @rezultat OUTPUT

If @rezultat IS NOT NULL
SELECT	@rezultat as [Rezultat impartire]

SELECT	'Return Value' = @return_value

GO

--Obs. Te obliga sa folosesti acelasi nume de parametru ca cel din procedura; obligatoriu sa avem OUTPUT pt. --     parametrii de iesire.

--2.2	Executie procedura stocata prin transmitere de parametri pozitional

USE [Northwind]
GO

DECLARE	@return_value int,
		@rezultat real
EXEC	@return_value = [dbo].[Impartire_xx] 4,3, @rezultat OUTPUT

If @rezultat IS NOT NULL
SELECT	@rezultat as [Rezultat impartire]

SELECT	'Return Value' = @return_value

GO

--Obs. Daca nu se foloseste @return_value=…, va aparea NULL la executia instructiunii 
--SELECT 'Return Value' = @return_value


-- P3	Vizualizare continut procedura stocata:

sp_helptext [Impartire_xx]


-- P4	Afisare informatii despre  procedurile stocate:
--	Utilizand functiile OBJECT_ID si OBJECTPROPERTY:

SELECT OBJECT_ID('[dbo].[Impartire_xx]') -- ID Procedura stocata;
SELECT OBJECTPROPERTY(ID, 'ExecIsAnsiNullsON') -- afiseaza valoarea setarii ANSI NULLS la crearea procedurii;
SELECT OBJECTPROPERTY(ID, 'ExecIsQuotedIdentON') --daca ANSI QUOTED e pe ON cand s-a creat procedura stocata.

-- P5	Se creaza urmatoarea procedura stocata în B.D. angajati:

Use angajati
go

CREATE PROCEDURE AflaSalariuMaxim_xx
@SalMax Money OUTPUT
AS
SELECT @SALMAX=MAX(SAL) 
        FROM emp 

--Procedura calculeaza Salariul maxim din firma.
--Se apeleaza procedura pt. a a calcula prima fiecarui angajat; Prima va fi egala cu 20% din valoarea salariului --propriu + 10% din valoarea celui mai mare salariu din firma

DECLARE @SalMax AS money
EXECUTE AflaSalariuMaxim_xx @SalMax = @SalMax OUTPUT 
SELECT [Salariul maxim] = @SalMax 
SELECT ename , Sal, Sal*0.2 + @SalMax*0.1 AS PRIMA 
FROM emp 

-- P6	Afisare lista proceduri stocate dintr-o B.D.
--      interogand vederea sys.procedures 
--      (din schemele dbo si cele create de user)

SELECT SCHEMA_NAME(schema_id) AS [Nume schema],
       name AS [Nume procedura st.]
FROM sys.procedures ORDER BY [Nume schema],name;
GO
-- P7	Stergere proceduri stocate create de studenti

USE [Northwind]
GO
DROP PROC [Impartire_xx];
GO

USE Angajati
GO
DROP PROC AflaSalariuMaxim_xx;
Go
