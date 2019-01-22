--Creare user B.D. fara cont de login

-- P1: Comutati contextul la B.D. master. 

USE master;
GO

-- P2: Creati un user FLogin care cere acces numai la B.D. Northwind
--     si care nu e asociat cu un login.
--   Obs.: 
--   B.D Nortwind trebuie trecuta in mod containment, altfel nu se poate crea user.
--   Se verifica sa nu fie accesata B.D. Northwind, apoi in GUI se
--   face right click Northwind --> Properties --> tab Options 
--   Se alege Partial pentru proprietatea Containment Type, apoi se reface
--   contextul la B.D. Northwind si se creaza user FLogin.
--(pt. revenire executati:
--alter database northwind set CONTAINMENT = NONE
--reconfigure
--go)

CREATE USER FLogin WITH PASSWORD = 'Pa$$w0rd';
GO

-- P3: Interogati lista  users existenti. 
--            S = SQL User
--            U = Windows User
-- Vezi val. coloanei authentication_type pentru user FLogin:
--            2 = Database authentication

SELECT * FROM sys.database_principals WHERE type IN ('S','U');
GO

-- P4: Deschideti o conexiune la B.D. Northwind ca user FLogin
--     (Click New Database Engine Query toolbar item.
--      Alegeti SQL Server Authentication, introduceti user Flogin
--      si password 'Pa$$w0rd'. Click the Options button
--      si setati optiunea 'Connect to Database option' la Northwind, apoi click Connect.
--      Conexiunea este deschisa.)
 

-- P5: Incercati sa faceti o conexiune noua la B.D. master ca user FLogin
--     (Click New Database Engine Query toolbar item.
--      Alegeti SQL Server Authentication, introduceti user Flogin
--      si password 'Pa$$w0rd'. Click the Options button
--      si setati optiunea 'Connect to Database option' la master, apoi click Connect.
--      Conexiunea va esua.)

