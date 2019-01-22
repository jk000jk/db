-- Restaurare fisier dintr-un backup full

-- P1 Creare B.D. BTest cu doua fisiere de date(.mdf si .ndf)

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'BTest')
	DROP DATABASE BTest;
GO
	
CREATE DATABASE BTest ON  PRIMARY 
( NAME = N'BTest1', 
  FILENAME = N'F:\Public\BTest1.mdf' , 
  SIZE = 10240KB , FILEGROWTH = 1024KB ),
( NAME = N'BTest2', 
  FILENAME = N'F:\Public\BTest2.ndf' , 
  SIZE = 10240KB , FILEGROWTH = 1024KB )
LOG ON 
( NAME = N'FTest_log', 
  FILENAME = N'F:\Public\BTest_log.ldf' , 
  SIZE = 5120KB , FILEGROWTH = 10%);
GO

-- P2: Setati recovery model pt. B.D. BTest la full.  

ALTER DATABASE BTest SET RECOVERY FULL;
GO

-- P3: Efectuati un 'full database backup'. 

BACKUP DATABASE BTest
  TO DISK = 'F:\Public\BTest_full.bak'
  WITH INIT;
GO

-- P4: Creati o tabela si populati-o cu date

USE BTest;
GO

SET NOCOUNT ON;

CREATE TABLE BTable
( ID int IDENTITY(1,1) PRIMARY KEY,
  C2 nvarchar(600),
  C3 bigint
);

DECLARE @Counter int = 0;

WHILE @Counter < 5000
BEGIN
  INSERT INTO BTable (C2,C3)
    VALUES('Date de test !',12345);
  SET @Counter += 1;
END;
GO

-- P5: Shutdown the server:
--     Right-clik pe SQL Server ---> Stop

-- P6: Folosind Windows Explorer, stergeti fisierul F:\Public\BTest1.mdf
--         apoi startati SQL Server folosind SQL Server Configuration Manager
--         (In SQL Server Services right-click SQL Server(nume instanta) si click Start sau Restart)

-- P7: Executati interogarea urmatoare pt. a vedea starea B.D. BTest.
--     Obs.: starea ar trebui sa fie RECOVERY_PENDING

SELECT name, state_desc 
FROM sys.databases
WHERE name = 'BTest';
GO

-- P8: Executati un tail-log backup

BACKUP LOG BTest
  TO DISK = 'F:\Public\BTest.trn'
  WITH INIT, CONTINUE_AFTER_ERROR
GO
	
-- P9: Nota: Acum tail log a fost salvat si putem restaura B.D. BTest.
--     Obs.: Vom restaura numai fisierul lipsa din backup-ul full al B.D., ca start
--           al secventei de restaurare.
 
RESTORE DATABASE BTest
  FILE = 'BTest1'
  FROM DISK = 'F:\Public\BTest_full.bak'
  WITH NORECOVERY;
GO

-- P10: Right-click Databases in Object Explorer si click Refresh. 
--      Observati starea B.D. BTest ( Restoring )

-- P11: Restaurati tail-log backup

RESTORE LOG BTest
  FROM DISK = 'F:\Public\BTest.trn'
  WITH RECOVERY;
GO

-- P12: Verificati starea B.D. BTest
--      (ar trebui sa fie ONLINE)

SELECT name, state_desc 
FROM sys.databases
WHERE name = 'BTest';
GO

-- P13: Verificati ca toate datele au fost restaurate.
--      Ar trebui sa fie 5000 de linii in tabela bo.FTable.

USE BTest;
GO

SELECT * FROM dbo.BTable;
GO
