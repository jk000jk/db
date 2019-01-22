--Creare/vizualizare conturi de logins

-- P1: Folositi B.D. master.

USE master;
GO

-- P2: Creare  Windows login pentru [utm-vac-ts1\user01].

CREATE LOGIN [utm-vac-ts1\user01] FROM WINDOWS;
GO

-- P3: Vizualizati lista logins existenti. 
--         S= SQL Login
--         U= Windows Login 
--         G= Windows Group Login

SELECT * FROM sys.server_principals WHERE type IN ('S','U','G');
GO

-- P4: In particular, notati the valorile coloanelor  name, type, type_desc, 
--         is_disabled, default_database_name si default_language_name.

-- P5: Creati un SQL Server login folosind T-SQL.

CREATE LOGIN Student WITH PASSWORD = 'Pa$$w0rd';
GO

-- P6: Folositi Database Engine Query toolbar icon 
--     pentru a va loga la SQL Server ca Student.
--      (Click pe Database Engine Query, in fereastra Connect to Server,
--       introduceti (local) la server name, selectati SQL Authentication,
--       introduceti Student la user name, 'Pa$$w0rd' la  password si click Connect)

-- P7: In fereastra care se deschide, vizualizati logon tokens disponibile

SELECT * FROM sys.login_token;
GO

-- P8: Notati ca Student este si el membru al rolului server public.
--     Inchideti fereastra care-a fost deschisa la conectarea Student.

-- P9: Creati un SQL Server login pentru Nupur folosind 'GUI interface'.
--          (In Object Explorer, expandati SQL Server, expandati Security,
--           expand Logins, right-click Logins si click New Login.
--           In the Login - New window, enter Nupur as the login name,
--           click SQL Server authentication, introduceti Pa$$w0rd ca password 
--           si confirmati password.
--           Notati optiunile de politica disponibile si click OK 
--           pentru a crea login)


-- P10: Reinterogati lista de logins existenti.

SELECT * FROM sys.server_principals WHERE type IN ('S','U','G');
GO

-- P11: Creati un SQL Server login pentru aplicatia Human Resources
--      cu T-SQL. Apelati user-ul HRApp cu password 'Pa$$w0rd'.
--      Faceti 'Disable' verificarea account policy.

CREATE LOGIN HRApp WITH PASSWORD = 'Pa$$w0rd',
                        CHECK_POLICY = OFF;
GO

-- P12: Afisati lista de  SQL Server logins. Observati coloanele 
--      is_policy_checked, is_expiration_checked si password_hash.
--      Notati diferenta coloanei is_policy_checked dintre utilizatorii
--      Student si HRApp.

SELECT * FROM sys.sql_logins WHERE name IN ('Student','HRApp');
GO


