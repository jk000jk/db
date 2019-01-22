-- Restaurare folosind tranzactii marcate

-- P1: Creare B.D. Rtest

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'RTest')
	DROP DATABASE RTest;
GO
	
CREATE DATABASE RTest ON  PRIMARY 
( NAME = N'RTest', 
  FILENAME = N'F:\Public\RTest.mdf' , -- adaptati directoarele la structura existenta
  SIZE = 10240KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RTest_log', 
  FILENAME = N'F:\Public\RTest_log.ldf' , 
  SIZE = 5120KB , FILEGROWTH = 10%);
GO

-- P2: Setati modelul de recovery full. Va avea efect cand se creaza primul backup full,
--     ca baza pt. restaurarile de logs sau diferentiale. 

ALTER DATABASE RTest SET RECOVERY FULL;
GO

-- P3: Faceti un  backup  full B.D. RTest. 

BACKUP DATABASE RTest
  TO DISK = 'F:\Public\RTest_full.bak'
  WITH INIT;
GO

-- P4: Creati o tabela si populati-o cu date

USE RTest;
GO

SET NOCOUNT ON;

CREATE TABLE RTable
( ID int IDENTITY(1,1) PRIMARY KEY,
  C2 nvarchar(600),
  C3 bigint
);
GO

INSERT INTO RTable (C2,C3)
VALUES('Aceasta este prima inregistrare!',12345);
GO

-- P5: Creati o tranzactie marcata. De notat ca tranzactia are un nume si ca marca are si o descriere.
--     Oricum, marcii i se da acelasi nume ca al tranzactiei, nu cel din descriere.

USE RTest;
GO

BEGIN TRAN InainteDeInsert WITH MARK 'Marca adaugata anterior activitatii inserarii de date'
  INSERT INTO RTable (C2,C3)
    VALUES('Inregistrare a tranzactiei marcate - a 2 a!',12345);
COMMIT TRAN InainteDeInsert;
GO

-- P6: Inserare alta inregistrare si afisare continut actual tabela

INSERT INTO RTable (C2,C3)
VALUES('Aceasta este a 3 a inregistrare !',12345);
GO

SELECT * FROM RTable;
GO
 
-- P7: Realizati un log backup

USE master;
GO

BACKUP LOG RTest
  TO DISK = 'F:\Public\RTest.trn'
  WITH INIT;
GO

-- P8: Restaurati backup full si de log si revedeti continutul tabelei dbo.RTable.
--      Obs.: Toate cele trei inregistrari ar trebui sa fie prezente. 

USE master;
GO

RESTORE DATABASE RTest --inainte se inchid toate conexiunile cu B.D.
  FROM DISK = 'F:\Public\RTest_full.bak'
  WITH REPLACE, NORECOVERY;
GO

RESTORE LOG RTest
  FROM DISK = 'F:\Public\RTest.trn'
  WITH RECOVERY;
GO

USE RTest;
GO

SELECT * FROM dbo.RTable;
GO
	
-- P9: Restaurati backup full si de log  folosind optiunea STOPATMARK si revedeti continutul tabelei dbo.RTable.
--     Obs.: Tranzactia marcata este inclusa, dar a 3 a inregistrare nu este recovered

USE master;
GO

RESTORE DATABASE RTest
  FROM DISK = 'F:\Public\RTest_full.bak'
  WITH REPLACE, NORECOVERY;
GO

RESTORE LOG RTest
  FROM DISK = 'F:\Public\RTest.trn'
  WITH RECOVERY, STOPATMARK = 'InainteDeInsert';
GO

USE RTest;
GO

SELECT * FROM dbo.RTable;
GO
	
-- P10: Restaurati backup full si de log  folosind optiunea STOPBEFOREMARK si revedeti continutul tabelei dbo.RTable.
--	Obs.: Cand se utilizeaza optiunea STOPBEFOREMARK, datele din tranzactia marcata nu sunt prezente. 

USE master;
GO

RESTORE DATABASE RTest
  FROM DISK = 'F:\Public\RTest_full.bak'
  WITH REPLACE, NORECOVERY;
GO

RESTORE LOG RTest
  FROM DISK = 'F:\Public\RTest.trn'
  WITH RECOVERY, STOPBEFOREMARK = 'InainteDeInsert';
GO

USE RTest;
GO

SELECT * FROM dbo.RTable;
GO

USE master;
GO
