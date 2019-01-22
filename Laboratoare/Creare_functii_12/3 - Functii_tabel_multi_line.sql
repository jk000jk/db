--P1 Stabilire B.D. implicita
USE [Northwind] -- sau alta B.D. de pe serverul SQL
GO

--P2 Creare functie multi linie [dbo].[fn_angajati_xx] --    xx este nr. dv. de user (01, 02, etc)
--    (intoarce numele sau numele si prenumele angajatilor, functie de valoarea parametrului de intrare)

CREATE FUNCTION [dbo].[fn_angajati_xx]
(
	
	@tip_nume nvarchar(9)
)
RETURNS @Table_angajat TABLE 
(
	
	ID_ang int PRIMARY KEY NOT NULL, 
	[Nume angajat] nvarchar(60) NOT NULL
)
AS
BEGIN
	
	if @tip_nume = 'scurt'
	   INSERT @table_angajat 
	   SELECT  Employeeid,Lastname from Employees 
	    else
	    if @tip_nume = 'lung'
	   INSERT @table_angajat  
	   SELECT  Employeeid,firstname+' '+Lastname from Employees 
	     else
		 INSERT @table_angajat  VALUES(1,'Parametru de apel incorect: '+@tip_nume)

	RETURN 
END

--P3 Testare functie (apel corect)
SELECT * FROM [dbo].[fn_angajati_xx]('lung')
--sau
SELECT * FROM [dbo].[fn_angajati_xx]('scurt')

--P4 Testare functie (apel incorect)

SELECT * FROM [dbo].[fn_angajati_xx]('scur')

--P5 Stergere functie
DROP FUNCTION [dbo].[fn_angajati_xx]