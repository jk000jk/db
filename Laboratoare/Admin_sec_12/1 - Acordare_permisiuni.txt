-- Se va lucra cu aspecte privind securitatea datelor SQL Server


-- I. OBTINERE DE INFORMATII GENERALE DESPRE SQL SERVER (legate de autentificare si autorizare)

--P1 Vizualizare moduri de autentificare la SQL Server:
--   Se lanseaza SSMS si se realizeaza conectarea la SQL Server (Database Engine)
--   folosind modul Windows de autentificare.
--   In Object Explorer, se selecteaza instanta SQL Server pt. care doriti informatii, right click pe aceasta,
--   apoi se selecteaza Properties, urmat de tab-ul Security. Exista doua moduri de autentificare:
--      1. Windows Authentication Mode;
--      2. SQL Server and Windows Authentication Mode.
--   Modul curent de autentificare este selectat printr-un radio buton; daca schimbati modul de autentificare,
--   acesta devine efectiv dupa restartarea serviciului pentru instanta respectiva.

--P2 Vizualizare informatii despre conturile de logins:
--   Pentru instanta la care ne-am conectat, in Object EXplorer se selecteaza folder Security, se expandeaza, apoi
--   se selecteaza folder Logins (daca expandati acest folder, veti vedea conturile de logins existente, iar daca 
--   faceti rigt click pe el si alegeti optiunea de meniu New Login, puteti crea un cont de login nou).
--   Ca exemplu: se vor crea doua conturi de login: 
--   sql1 si sql2, care se vor autentifica de catre SQL Server; se recomanda a se crea de catre profesor, pt. a nu 
--   aparea mesaje de eroare (daca se  incearca crearea acelorasi conturi de catre mai multi studenti).
--   
--   Se mai poate explora subfolder-ul Server Roles, pentru acelasi folder Security,care pastreaza rolurile
--   prefixate la nivel de server (a se vedea membrii acestora).


--P3  Vizualizare informatii despre conturile de utilizatori dintr-o baza de date:
--    Se selecteaza baza de date dorita, in Object Explorer, se expandeaza subfolder Security, apoi se 
--    expandeaza subfolder Users; in acest subfolder:
--         - alegeti un user ---> right click ---> Properties (vizualizare i-tii despre user) sau
--         - right click pe el ---> New user (creare user nou)

-- II. MANAGEMENT PERMISIUNI

-- II.1 CREARE ROLURI STANDARD IN B.D.

--P4 Se vor crea doi utilizatori in B.D. Northwind: sql1 si sql2, care se vor asocia cu cele doua conturi de login 
--   create in P2 (vezi P3 pt. creare).

--P5 Se creaza rolul standard user rol_st_North in B.D. Northwind:
--    expandare subfolder Security ---> expandare subfolder Roles ---> right click subfolder Database Roles
--     ---> New Database Role.
--    Se va tasta numele rolului, apoi i se adauga cei doi users ca membri (vezi P4)

-- II.2 ASIGNARE PERMISIUNI INSTRUCTIUNE (CREARE OBIECTE IN B.D.)

--P5 Se selecteaza B.D. Northwind ---> right click ---> alegere optiune meniu Properties 
--   ---> selectare tab Permissions
--   In fereastra de dialog respectiva se dau permisiunile  Create View si Create Procedure (bifare Grant) 
--   utilizatorului sql2.

--P6 Se schimba contextul de securitate la sql2

EXECUTE AS USER='sql2'
GO

SELECT SUSER_SNAME()  -- vizualizare noul nume

--P7 Se executa codul T-SQL urmator:

USE Northwind
GO

CREATE VIEW test_view_xx  -- xx este nr. dvs. de user
AS
SELECT FIrstName, Lastname
FROM Employees

-- Se poate crea vederea?  Daca da/nu, De ce ?

CREATE TABLE T1 (c1 int)

-- Se poate crea tabela?  Daca da/nu, De ce ? 
Obs. Daca primiti un mesaj de eroare referitor la schema dbo 
--      (nu puteti sa creati obiecte in noul context de securitate)
--      din B.D. Northwind, procedati astfel:
--     expandare Security   --->  expandare Schemas ---> right click pe dbo ---> Properties
--      ---> tab Permissions ---> se adauga cei doi users sql1 si sql2 si fiecaruia i se da permisiunea
--      Alter pe schema (bifare Grant). Reexecutati instructiunile din P7!

DROP VIEW test_view_xx
GO

--P8 Se schimba contextul de securitate la cel avut anterior P6 (de admin)

REVERT
GO

SELECT SUSER_SNAME() -- vizualizare noul user


-- II.3 ASIGNARE PERMISIUNI OBIECT (PE OBIECTE DIN B.D.)

--P9  In B.D. Northwind ---> expandare subfolder Tables  ---> right click o tabela ---> Properties
--    ---> selectie tab Permissions ---> acordare permisiuni.
--    Se foloseste urmatorul tabel pt. a acorda, revoca si interzice permisiuni pe obiectele din B.D.
--    Northwind pentru utilizatori si roluri (se bifeaza/ debifeaza permisiunea Control):

--Obiect                         Cont user/rol (R)            Permisiune acordata
----------------------------------------------------------------------------------
--tabela Categories               public (R)                       Grant all
----------------------------------------------------------------------------------
--tabela Customers                 sql2                            Deny All
----------------------------------------------------------------------------------
--tabela Customers                 rol_st_North (R)                Grant all
----------------------------------------------------------------------------------
--tabela Customers                public (R)                       Revoke All
----------------------------------------------------------------------------------
--tabela Employees                public (R)                       Revoke All
----------------------------------------------------------------------------------
--tabela Products                 public (R)                       Revoke All
----------------------------------------------------------------------------------

--P10 Se schimba contextul de securitate la sql1

EXECUTE AS USER='sql1'
GO

SELECT SUSER_SNAME()  -- vizualizare noul nume

--P11 Se executa urmatoarele instructiuni T-SQL.
--    Explicati rezultatele obtinute.

USE Northwind
GO

SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM Categories
SELECT * FROM Products

--P12 Se schimba contextul de securitate la cel avut anterior P6 (de admin)

REVERT
GO

SELECT SUSER_SNAME() -- vizualizare noul user

--P13 Se schimba contextul de securitate la sql2

EXECUTE AS USER='sql2'
GO

SELECT SUSER_SNAME()  -- vizualizare noul nume

--P14 Se executa urmatoarele instructiuni T-SQL.
--    Explicati rezultatele obtinute.

USE Northwind
GO

SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM Categories
SELECT * FROM Products

--P15 Se schimba contextul de securitate la cel avut anterior P6 (de admin)

REVERT
GO

SELECT SUSER_SNAME() -- vizualizare noul user


-- II.4 CREARE ROLURI APLICATIE IN B.D. Northwind (NU AU MEMBRI !!)

--P16   Expandare subfolder Security ---> expandare subfolder Roles ---> 
--      right click subfolder Application Roles ---> New Application Role.
--      Se va crea rolul aplicatie cu numele rol_aplic si parola 'parola[123]'.

--P17   Rolului rol_aplic i se asigneaza urmatoarele permisiuni:
--      (Selectie rol_aplic ---> right click --> Properties ---> tab Securables)

--Obiect                                   Permisiuni acordate
----------------------------------------------------------------------------------
--tabela Categories                           SELECT
----------------------------------------------------------------------------------
--tabela Customers                            DELETE, INSERT
----------------------------------------------------------------------------------
--tabela Order Details                        SELECT, INSERT, UPDATE
----------------------------------------------------------------------------------
--tabela Orders                               SELECT, INSERT, UPDATE
----------------------------------------------------------------------------------
--tabela Products                             SELECT
---------------------------------------------------------------------------

--P18 Se schimba contextul de securitate la sql1

USE Northwind
GO

EXECUTE AS USER='sql1'
GO

SELECT USER_NAME()  -- vizualizare noul nume user


--P19 Se activeaza rolul aplicatie rol_aplic de catre utilizatorul sql1 
--     (membru al rolului standard rol_st_North)
--     si se executa anumite i-ni T-SQL. Explicati rezultatele obtinute.


EXEC sp_setapprole 'rol_aplic','parola[123]' --activare rol aplicatie

SELECT 'Noul nume: '+USER_NAME() --vizualizare nume rol aplicatie

SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM Categories
SELECT * FROM Products
DELETE FROM Products

--P20 Inchideti fereastra de interogare si se va dezactiva rolul aplicatie utilizat in sesiunea resp.