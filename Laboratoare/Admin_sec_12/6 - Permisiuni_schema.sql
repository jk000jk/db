--  Permisiuni la nivel de schema

-- P1: Stabilire context B.D. Northwind.

USE Northwind;
GO

-- P2 Creare schema Situatii

CREATE SCHEMA Situatii AUTHORIZATION dbo

-- Creare procedura stocata Afisare_Vanzatori_xx   -- xx este numele dvs. de user 
-- in schema Situatii

CREATE PROCEDURE Situatii.Afisare_vanzatori_xx 
AS
BEGIN
	SET NOCOUNT ON;

   	SELECT [EmployeeID] [Cod angajat],[LastName]+'  '+[FirstName] [Nume si prenume],
	       [Title] [Functia], [HomePhone] [Telefon]

	FROM Employees WHERE Title LIKE 'Sales%'
END
GO

-- P3 Creare login SchemaLogin si apoi user SchemaUser in B.D. Northwind

CREATE LOGIN SchemaLogin WITH PASSWORD = 'Pa$$w0rd', CHECK_POLICY = OFF;
GO

CREATE USER SchemaUser FOR LOGIN SchemaLogin;
GO

-- P4: Revocare permisiune de-a executa procedura stocata Situatii.Afisare_Vanzatori_xx 
--     pentru   SchemaUser.

REVOKE EXECUTE ON situatii.Afisare_Vanzatori_xx FROM SchemaUser;
GO

-- P5: Verificare daca user SchemaUser poate executa procedura stocata.
--         Notati  ca executia este interzisa.

EXECUTE AS USER = 'SchemaUser';
GO

EXEC Situatii.Afisare_Vanzatori_xx;-- xx este numele dvs. de user 
GO

REVERT;
GO

-- P6: Grant EXECUTE pe schema Situatii user-ului SchemaUser.

GRANT EXECUTE ON SCHEMA::Situatii TO SchemaUser;
GO

-- P7: Verificare daca user SchemaUser poate executa procedura stocata.
--         Notati  ca executia este permisa.

EXECUTE AS USER = 'SchemaUser';
GO

EXEC Situatii.Afisare_Vanzatori_xx;-- xx este numele dvs. de user 
GO

REVERT;
GO

-- P8: Aplicare DENY executie pe proc. stoc.  Situatii.Afisare_Vanzatori_xx.

DENY EXECUTE ON Situatii.Afisare_Vanzatori_xx TO SchemaUser;
GO

-- Intrebare: User-ul are permisiunea  EXECUTE la nivel schema 
--           si REVOKE DENY nivel procedura. Executia este permisa?


-- P9: Verificati daca user  SchemaUser poate executa procedura.
--         Notati ca executia  nu este permisa.

EXECUTE AS USER = 'SchemaUser';
GO

EXEC Situatii.Afisare_Vanzatori_xx;
GO

REVERT;
GO

-- P10: Verificati daca alta proc. stoc. din schema poate fi executata.
--         Notati raspunsul afirmativ.

EXECUTE AS USER = 'SchemaUser';
GO

EXEC Situatii.Afisare_Vanzatori_prof; --se presupune ca prof a creat aceasta p.s.
GO

REVERT;
GO

-- P11: Stergere procedura stocata Situatii.Afisare_Vanzatori_xx

DROP Procedure Situatii.Afisare_Vanzatori_xx
GO


