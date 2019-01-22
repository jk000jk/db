-- Creare utilizatori intr-o B.D.

-- P1: Comutati la B.D. Northwind. Notati ca nu puteti  
--     crea un user intr-o B.D. database dintr-o alta B.D.
--     Users sunt creati intotdeauna in B.D. curenta


USE northwind;
GO

-- P2: Creati un user pentru login Student creat anterior cu T-SQL.

CREATE USER Student FOR LOGIN Student;
GO

-- P3: Creati un user in B.D. Northwind  pentru logon HRApp, 
--     care-a fost creat anterior, folosind GUI. 
--     (In Object Explorer, expandati SQL Server, expandati Security,
--      expandati Logins, right-click Logins si click Refresh.
--      Right-click login HRApp si click Properties.
--      In panelul Select a page , click User Mapping. 
--      In lista de mappings, check coloana Map pt. B.D. Northwind
--      si click OK)

-- P4: Interogare lista de  users existenti. Revedeti lista
--     de users returnata. Notati in particular users:
--     guest, INFORMATION_SCHEMA si sys users. 
--            S = SQL User
--            U = Windows User

SELECT * FROM sys.database_principals WHERE type IN ('S','U');
GO

-- P5: Conectati-va la  database engine folosind 
--     Database Engine Query toolbar icon. 
--     Conectati-va ca user Student.
--     (Click pe Database Engine Query, in fereastra Connect to Server,
--      introduceti (local) la server name, selectati SQL Authentication, 
--      introduceti Student la user name,'Pa$$w0rd' la password si click Connect)

-- P6: In 'query window' care se deschide, executati urmatoarea interogare
--         pentru a vedea user tokens asociati cu Student in B.D. Northwind.
--         Notati ca Student este un membru al rolului public din B.D. 

USE Northwind;
GO

SELECT * FROM sys.user_token;
GO


