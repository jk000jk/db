--P1 Stabilire B.D. implicita
USE [Northwind] -- sau alta B.D. de pe serverul SQL
GO

--P2 Creare functie mono linie dbo.fn_Produse_xx
--   Afiseaza produsele care respecta un patern transmis ca parametru de intrare

CREATE FUNCTION [dbo].[fn_Produse_xx] --    xx este nr. dv. de user (01, 02, etc)
(	
	-- parametru de intrare
	@param_nume nvarchar(40)
)
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT * FROM products WHERE ProductName LIKE @param_nume
)

--P3 Testare functie

SELECT * FROM dbo.fn_Produse_xx('c%')
--sau
SELECT * FROM dbo.fn_Produse_xx('a%')

--P4  Stergere functie dbo.fn_Produse_xx

DROP FUNCTION dbo.fn_Produse_xx


--P5 Crearea celei de-a doua functii tabel mono linie: dbo.ExtractProtocolFromURL_xx
--   (afiseaza numele protocolului dintr-un apel de pagina cu un browser Internet)

CREATE FUNCTION [dbo].[ExtractProtocolFromURL_xx]
( @URL nvarchar(1000))
RETURNS TABLE
AS 
RETURN SELECT
		Protocol=CASE WHEN CHARINDEX(N':',@URL,1) >= 1
        THEN SUBSTRING(@URL,1,CHARINDEX(N':',@URL,1) - 1)
		ELSE 'Apel gresit functie!'
END;


--P6 Apel functie [dbo].[ExtractProtocolFromURL_xx] corect

SELECT * FROM [dbo].[ExtractProtocolFromURL_xx]('https://portal.azure.com')

--P7 Apel functie [dbo].[ExtractProtocolFromURL_xx] incorect

SELECT * FROM [dbo].[ExtractProtocolFromURL_xx]('https//portal.azure.com')

--P8  Stergere functie  [dbo].[ExtractProtocolFromURL_xx]

DROP FUNCTION [dbo].[ExtractProtocolFromURL_xx]
