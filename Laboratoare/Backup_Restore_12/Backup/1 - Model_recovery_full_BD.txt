--Modele de Recovery ale unei B.D.

-- P1: Creati o  B.D. noua (Nota: Modelul de recovery va fi setat la cel avut de B.D. model)

USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'LogTest_xx') -- xx este nr. dvs. de user
	DROP DATABASE LogTest_xx;
GO

CREATE DATABASE LogTest_xx ON  PRIMARY 
(  NAME = N'LogTest', 
   FILENAME = N'F:\Public\LogTest_xx.mdf' , 
   SIZE = 10240KB, 
   FILEGROWTH = 1024KB 
)
 LOG ON 
( NAME = N'LogTest_log', 
  FILENAME = N'F:\Public\LogTest_log_xx.ldf' , 
  SIZE = 5120KB, 
  FILEGROWTH = 10%
);
GO

-- P2: Setati modelul de recovery pe full. De subliniat ca modelul de recovery full va avea efect dupa
--     ce se va face primul backup full B.D. si va servi ca baza pt. log backups.

ALTER DATABASE LogTest_xx SET RECOVERY FULL;
GO

-- P3: Faceti un backup full B.D. 

BACKUP DATABASE LogTest_xx
  TO DISK = 'F:\Public\LogTest_Full_xx.bak'
WITH INIT;
GO

-- P4: Creati o tabela in B.D.

USE LogTest_xx;
GO

CREATE TABLE Tabel_xx
( Id int IDENTITY(1,1) PRIMARY KEY,
  C1 nvarchar(600),
  C2 bigint
);
GO
	
-- P5: Examinati proprietatile fisierelor B.D.
--     (Notati ca log file are type 1 in sys.databases)

SELECT name AS Nume,type,
       size * 8 /1024. as [Dim. in MB],  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as [Spatiu folosit in MB],
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as [Procent de folosire spatiu]	
FROM sys.database_files;
GO

--  P6: Inserati  date in tabela (5000 linii)

SET NOCOUNT ON;

INSERT INTO Tabel_xx (C1, C2)
  VALUES('Aceasta e data de test ',12345);
GO 5000

-- P7: Examinati proprietatile 'database log file' din nou
--         (Notati ca log file este mult mai plin decat inainte)

SELECT name AS Nume,
       size * 8 /1024. as [Dim. in MB],  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as [Spatiu folosit in MB],
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as [Procent de folosire spatiu]	
FROM sys.database_files
WHERE type = 1;	
GO	

-- P8: Declansati un checkpoint 
--     Notati ca CHECKPOINT (comanda) poate fi folosita pt. a cere
--     SQL Server un checkpoint imediat, fara sa astepte urmatorul automat.

CHECKPOINT;
GO

-- P9: Examinati proprietatile 'database log file' din nou
--         (Notati ca checkpoint nu a schimbat dimensiunea -> nimic nu a fost trunchiat)

SELECT name AS Nume,
       size * 8 /1024. as [Dim. in MB],  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as [Spatiu folosit in MB],
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as [Procent de folosire spatiu]	
FROM sys.database_files
WHERE type = 1;	
GO	

--P10: Verificati ca este prevenita trunchierea log.
--     Vedeti log_reuse_wait_desc pt. B.D. LogTest_xx .
--     Va arata LOG_BACKUP ca motiv.)

SELECT name, log_reuse_wait_desc FROM sys.databases;
GO


--P11: Faceti un 'log backup'.

BACKUP LOG LogTest_xx
  TO DISK = 'F:\Public\LogTest_tr_xx.bak'
WITH INIT;
GO

-- P12: Examinati folosirea log file. Log file trebuie sa fi fost trunchiat 
--      si spatiul eliberat. 

SELECT name AS Name,
       size * 8 /1024. as [Dim. in MB],  
       FILEPROPERTY(name,'SpaceUsed') * 8 /1024. as [Spatiu folosit in MB],
       CAST(FILEPROPERTY(name,'SpaceUsed') as decimal(10,4))
         / CAST(size as decimal(10,4)) * 100 as [Procent de folosire spatiu]	
FROM sys.database_files
WHERE type = 1;	
GO	

-- P13: Stergere B.D. 

USE master
GO
DROP DATABASE LogTest_xx;