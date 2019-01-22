--B.D.-----Creare BD cu T-SQL si cu SSMS(Sql Server Management Studio)

-- P1: Open Object Explorer, expandati SQL Server, right-click Databases si click New Database.

-- P2: In new database dialog introduceti NewDB_xx, unde xx este nr. dvs. de user, ca nume de baza de date. Revedeti dimensiunile initiale implicite
--     pt.data si log file care vor fi create, pastrati aceste valori si click OK

-- P3: Right-click NewDB_xx in Object Explorer, selectati Properties si revedeti baza de date  creata.
--     (In general tab, notati dimensiunea si spatiul disponibil, precum si cum se relationeaza cu dimensiunile din
--      Files tab. Close  Database Properties - NewDB_xx window)

-- P4: Creati o B.D. folosind T-SQL 

USE master;
GO

CREATE DATABASE Branch_xx -- xx va fi inlocuit cu nr. de user cu care v-ati logat la server (utm-vac-ts1)
ON 
( NAME = Branch_dat, 
  FILENAME = 'f:\Public\Branch_xx.mdf',   
  SIZE = 100MB, MAXSIZE = 500MB,  
  FILEGROWTH = 20% 
)
LOG ON
( NAME = Branch_log,
  FILENAME = 'f:\Public\Branch_xx.ldf',  
  SIZE = 20MB, 
  MAXSIZE = UNLIMITED,  
  FILEGROWTH = 10MB 
);
GO

-- P5: Revedeti bazele de date si starea lor folosind T-SQL

SELECT database_id, name, state_desc  FROM sys.databases;		
GO

-- P6: Revedeti fisierele folosite de B.D. Branch_xx

USE Branch_xx;
GO

SELECT file_id,
	   name [Nume fisier], 
	   size as  [Nr. de pagini alocate], 8*size/1024. [Spatiu alocat(MB)],
	   FILEPROPERTY(name, 'SpaceUsed') as [Nr. pagini folosite],8*FILEPROPERTY(name, 'SpaceUsed')/1024. [Spatiu folosit(MB)],
	   physical_name [Nume fisier S.O.]
FROM sys.database_files;
GO

