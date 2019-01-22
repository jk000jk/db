--SID diferit pt. user si cont login la restaurare B.D.

-- P1 - In acest moment va aflati in situatia unui administrator de B.D. care 
--      primeste un backup al unei B.D. si acesta contine un user pt. un cont
--      de login inexistent. In primul moment restaurati B.D.

USE master;
GO

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = N'Mismatch')
  DROP DATABASE Mismatch;
GO

RESTORE DATABASE Mismatch 
FROM DISK = 'C:\UTM\cursuri\Baze_de_date_III_ZI\Curs_semestrul_2\Laboratoare\Admin_sec_12\mismatch.bak'
WITH
MOVE 'Mismatch_Dat' TO 
  'c:\date\Mismatch_Data.mdf', --sau alt director existent
        MOVE 'Mismatch_Log' 
  TO 'c:\date\Mismatch_Log.ldf';
GO

-- P2 - Verificati lista de users din B.D. Notati ca numele TestUser
--      apare in lista de user database, chiar daca nu exista un asemenea login.

USE Mismatch;
GO

SELECT * FROM sys.database_principals;
GO

-- P3 - Creati login TestUser.

CREATE LOGIN TestUser WITH PASSWORD = 'Pa$$w0rd', CHECK_POLICY = OFF;
GO

-- P4 - Utilizati Database Engine Query toolbar icon, connectati-va
--      la B.D. Mismatch ca user TestUser si incercati sa interogati tabela TestTable.
--      Notati ca user-ul nu poate citi datele din tabela.
--      Inchideti new window.
--      (Click pe Database Engine Query, in fereastra Connect to Server,
--      tastati (local) ca server name, selectati SQL Authentication,
--      introduceti TestUser ca user name,'Pa$$w0rd' ca password
--      si click Connect. In  new window copiati si executati comenzile urmatoare.
--      Notati eroarea care spune ca user-ul nu poate accesa B.D. si apoi inchideti fereastra.)

USE Mismatch;
GO

SELECT * FROM dbo.TestTable;
GO

USE master;
GO

-- P5 -  Problema este ca, desi numele user si login sunt aceleasi, SID-urile sunt diferite.

-- P6 - Incercati sa creati un  user in B.D. pentru login. 
--      Notati esecul c-zii, pt. ca exista deja un user cu acel nume.

USE Mismatch;
GO

CREATE USER TestUser FOR LOGIN TestUser;
GO

-- P7 - Aceasta este o problema obisnuita la restaurarea unei B.D cu users existenti.

-- P8 - Interogare Security IDs la nivel server si  B.D.
--      Notati ca, desi numele sunt identice, SIDs  sunt diferite.

SELECT name, principal_id, sid [SID Server] 
FROM sys.server_principals 
WHERE name = 'TestUser';

SELECT name, principal_id, sid [SID BD]
FROM sys.database_principals 
WHERE name = 'TestUser';
GO

-- P9 - O optiune pt. a rezolva aceasta problema, este de-a corecta SID in B.D.
--      cu c-da ALTER USER:

ALTER USER TestUser WITH LOGIN = TestUser;
GO

-- P10 - Interogare Security IDs la nivel server si  B.D.
--       Notati ca sids au fost setate la valoarea SID login.

SELECT name, principal_id, sid [SID Server] FROM sys.server_principals WHERE name = 'TestUser';
SELECT name, principal_id, sid [SID BD] FROM sys.database_principals WHERE name = 'TestUser';
GO

-- P11 - Utilizati Database Engine Query toolbar icon, connectati-va
--      la B.D. Mismatch ca user TestUser si incercati din nou sa interogati tabela.
--      Notati ca user-ul poate citi datele din tabela.
--      Inchideti new window, dupa executia interogarii.
--      (Click pe Database Engine Query, in fereastra Connect to Server,
--      tastati (local) ca server name, selectati SQL Authentication,
--      introduceti TestUser ca user name,'Pa$$w0rd' ca password
--      si click Connect. In  new window copiati si executati comenzile urmatoare.
--      Ele vor fi executate fara erori. Inchideti fereastra dupa executie)


USE Mismatch;
GO

SELECT * FROM dbo.TestTable;
GO

USE master;
GO

-- P12 - Drop B.D. Mismatch

USE tempdb;
GO

DROP DATABASE Mismatch;
GO
