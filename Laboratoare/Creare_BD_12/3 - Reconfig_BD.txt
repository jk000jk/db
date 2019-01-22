--B.D.--Reconfigurare B.D.

-- P1: Adaugati un fisier nou la B.D. NewDB creata anterior.

USE master;
GO

ALTER DATABASE NewDB_xx --xx este nr. dvs. de user server UTM 
  ADD FILE ( NAME = N'NewDB2', 
             FILENAME = N'f:\public\NewDB2_xx.ndf' , 
             SIZE = 3072KB , 
             FILEGROWTH = 1024KB 
            ); 
GO

-- P2: Creati o tabela si inserati date in ea din B.D. Northwind.

USE NewDB_xx;
GO


SELECT * INTO dbo.Tabela_noua_xx FROM Northwind.dbo.Products WHERE 1=2; --cream tabela_noua_xx cu  structura tabelei products, fara inreg.;
ALTER TABLE tabela_noua_xx DROP column productid  --se sterge col. IDENTITY
ALTER TABLE tabela_noua_xx ADD productid int  --se recreaza coloana fara IDENTITY
INSERT INTO Tabela_noua_xx
      SELECT  
	     [ProductID] 
	    ,[ProductName]
	  ,[SupplierID]
	  ,[CategoryID]
	  ,[QuantityPerUnit]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[UnitsOnOrder]
      ,[ReorderLevel]
      ,[Discontinued]
	  
	  FROM Northwind.dbo.Products;
GO 1000

 
-- P3: Right-click NewDB_xx in Object Explorer si selectati Reports -> Standard Reports -> Disk Usage 
--     si expandati Disk Space Used by Data Files. Notati ca datele sunt distribuite in cele doua fisiere.
--     Expandati Data/Log File Autogrow/Autoshrink Events si notati cate autocresteri au aparut deja, pt. ca
--     dim. initiala a acestor fisiere a fost prea mica.

-- P4: Expandati data files 

USE master;
GO

ALTER DATABASE NewDB_xx MODIFY FILE ( NAME = N'NewDB_xx', SIZE = 102400KB );
GO

ALTER DATABASE NewDB_xx MODIFY FILE ( NAME = N'NewDB2', SIZE = 102400KB );
GO

ALTER DATABASE NewDB_xx MODIFY FILE ( NAME = N'NewDB_xx_log', SIZE = 50960KB );
GO


-- P5: Right click NewDB_xx in Object Explorer, selectati Reports -> Standard Reports -> Disk Usage 
--     si vedeti noua dimensiune a fisierelor.

-- P6: Incercati sa reduceti(shrink) fisierele de date la dim. de 30 MB

USE NewDB_xx;
GO

DBCC SHRINKFILE (N'NewDB_xx' , 30);
GO

DBCC SHRINKFILE (N'NewDB2' , 30);
GO

-- P7: Right click NewDB in Object Explorer , select Reports -> Standard Reports -> Disk Usage 
--     si observati noua dimensiune a fisierelor. 

-- P8: Incercati sa stergeti fis. de date adaugat mai devreme. Veti primi un mesaj de eroare care 
--     spune ca fis. nu poate fi sters deoarece nu este "empty".

USE NewDB_xx;
GO

ALTER DATABASE NewDB_xx REMOVE FILE NewDB2;
GO

-- P9: Executati instr. DBCC SHRINKFILE pt. a goli fisierul, apoi incercati din nou sa-l stergeti.

DBCC SHRINKFILE (N'NewDB2' , EMPTYFILE);
GO

ALTER DATABASE NewDB_xx REMOVE FILE NewDB2;
GO

-- P10: Verificati ca fisierul a fost sters


SELECT file_id,
	   name [Nume fisier], 
	   size as  [Nr. de pagini alocate], 8*size/1024. [Spatiu alocat(MB)],
	   FILEPROPERTY(name, 'SpaceUsed') as [Nr. pagini folosite],8*FILEPROPERTY(name, 'SpaceUsed')/1024. [Spatiu folosit(MB)],
	   physical_name [Nume fisier S.O.]
FROM sys.database_files;
GO

-- P11: Se sterge B.D. cu care s-a lucrat
USE master
go

DROP database NewDB_xx
go