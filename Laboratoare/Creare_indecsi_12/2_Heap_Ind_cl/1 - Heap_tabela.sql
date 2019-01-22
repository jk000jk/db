-- Lucrul cu heap-ul unei tabele

-- P1: Deschideti o fereastra de interogare noua si stabiliti
--     contextul de lucru la B.D tempdb

USE tempdb;
GO

-- P2: Creati a tabela ca un heap

CREATE TABLE dbo.Inreg_tel_xx --xx este nr. dvs. de user
( ID_tel int IDENTITY(1,1) NOT NULL,
  Data_inreg datetime2 NOT NULL,
  Nr_tel nvarchar(100) NOT NULL,
  Durata_apel_Ms int NOT NULL
);
GO

-- P3: Interogati vederea sys.indexes pentru a vedea structura de indecsi ai tabelei

SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'Inreg_tel_xx';
GO

-- P4: Vizualizare spatiu ocupat de tabela

sp_spaceused 'Inreg_tel_xx'

-- P5: Inserare date in tabela

SET NOCOUNT ON;

DECLARE @Contor int = 0;

WHILE @Contor < 10000 BEGIN
  INSERT dbo.Inreg_tel_xx (Data_inreg, Nr_tel, Durata_apel_Ms)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int));
  SET @Contor += 1;
END;
GO

-- P6: Vizualizare spatiu ocupat de tabela

sp_spaceused 'Inreg_tel_xx'
select * from sys .sysindexes  where id=OBJECT_ID ('Inreg_tel_xx')

-- P7: Modificati datele din tabela 
-- (dureaza ceva timp)

SET NOCOUNT ON;

DECLARE @Contor int = 0;

WHILE @Contor < 10000 BEGIN
  UPDATE dbo.Inreg_tel_xx SET Nr_tel = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE ID_tel = @Contor;
  IF @Contor % 100 = 0 PRINT @Contor;
  SET @Contor += 1;
END;
GO

-- P8: Verificati nivelul de fragmentare cu vederea sys.dm_db_index_physical_stats

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.Inreg_tel_xx'),NULL,NULL,'DETAILED');
GO

-- P9: Notati valoarea cp. forwarded_record_count 

-- P10: Reconstruiti tabela

ALTER TABLE dbo.Inreg_tel_xx REBUILD;
GO

-- P11: Verificati nivelul de fragmentare cu vederea via sys.dm_db_index_physical_stats

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.Inreg_tel_xx'),NULL,NULL,'DETAILED');
GO

-- P12: Notati valoarea cp. forwarded_record_count 

-- P13: Stergeti tabela

DROP TABLE dbo.Inreg_tel_xx;
GO

