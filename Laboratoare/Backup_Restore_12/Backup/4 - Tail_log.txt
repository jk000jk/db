--Backup de tail-log

-- P1:Creati B.D. dblog

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'dblog')
	DROP DATABASE dblog;
GO
	
CREATE DATABASE dblog ON  PRIMARY 
( NAME = N'dblog', 
  FILENAME = N'F:\Public\dblog.mdf' , 
  SIZE = 10240KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dblog_log', 
  FILENAME = N'F:\Public\dblog_log.ldf' , 
  SIZE = 5120KB , FILEGROWTH = 10%);
GO

-- P2: Setati modelul full pt. B.D.. De subliniat ca modelul full va 
--     avea efect dupa primul backup full B.D., ca baza pt. backups de log

ALTER DATABASE dblog SET RECOVERY FULL;
GO

-- P3: Faceti un backup full B.D.. 

BACKUP DATABASE dblog
	TO DISK = 'F:\Public\dblog_full.bak'
WITH INIT;
GO

-- P4: Creati o tabela si o populati cu date

USE dblog;
GO

SET NOCOUNT ON;
GO

CREATE TABLE LogData
( ID int IDENTITY(1,1) PRIMARY KEY,
  C2 nvarchar(600),
  C3 bigint
);
GO

INSERT INTO LogData (C2,C3)
  VALUES('Data de test',12345);
GO 5000

-- P5: shutdown SQL Server
--     (Right-click SQL Server ---> Stop)

-- P6: Deschideti Windows Explorer si navigati la F:\Public si stergeti dblog.mdf.

-- P7: Restartati serviciul SQL Server si va conectati la instanta implicita.
--     (Right-click SQL Server ---> Restart)
--     Obs.: Daca obtineti eroare, restartati serviciul din Sql Server Configuration Manager

-- P8: Examinati stare B.D. dblog
--       (Notati ca arata RECOVERY_PENDING care inseamna ca recovery nu a fost facut)

SELECT name, state_desc 
FROM sys.databases
WHERE name = 'dblog';
GO


-- P9: Incercati un  backup al transaction log.
--      (Obs: Veti obtine o eroare inaccessible files)

BACKUP LOG dblog
  TO DISK = 'F:\Public\dblog.trn'
  WITH INIT;
GO

-- P10: Faceti un tail-log backup
--          Notati ca un tail-log backup ar putea fi creat, desi fisierele sunt inacccesibile. 

BACKUP LOG dblog
  TO DISK = 'F:\Public\dblog.trn'
  WITH INIT, CONTINUE_AFTER_ERROR;
GO
