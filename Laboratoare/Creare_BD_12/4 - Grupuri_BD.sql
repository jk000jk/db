--B.D. - Lucrul cu grupuri in B.D.

-- P1: Adaugati un Filegroup si un data file la B.D. Branch_xx creata anterior.
--     (Right-click Databases in Object Explorer si click Refresh. Right-click B.D. Branch_xx 
--      si click Properties. Selectati Files tab si click Add. In linia noua adaugata
--      introduceti Branch_dat2 ca Logical Name,Branch_dat2_xx ca File Name , si alegeti <New Filegroup> pentru Filegroup.
--      In popup window, introduceti Data_FG ca nume al filegroup si click OK, apoi
--      click OK pentru a salva database properties)

-- P2: Creati o tabela noua.

USE Branch_xx;
GO

CREATE TABLE dbo.Produse
( ProdusID int IDENTITY(1,1) NOT NULL,
  Nume nvarchar(128) NOT NULL,
  CostStandard money NOT NULL,
  PretLista money NOT NULL
);
GO
	
-- P3: Verificati grupul  in care a fost creata tabela. 

SELECT i.data_space_id, 
       s.name AS Filegroup
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS s
ON i.data_space_id = s.data_space_id 
WHERE i.object_id = OBJECT_ID(N'dbo.Produse');
GO

-- Tabela a fost creata in the PRIMARY filegroup, care este default filegroup al B.D..
-- Notati ca este cea mai buna practica  ca grupul PRIMARY filegroup sa fie folosit numai de
-- obiectele sistem si nu pt. date user, cand exista mai multe filegroups in B.D.
 
-- P4: Stergeti tabela si recreati-o in Data_FG filegroup.

USE Branch_xx;
GO

DROP TABLE dbo.Produse; 
GO

CREATE TABLE dbo.Produse
( ProdusID int IDENTITY(1,1) NOT NULL,
  Nume nvarchar(128) NOT NULL,
  CostStandard money NOT NULL,
  PretLista money NOT NULL) ON Data_FG;
GO

-- P5: Verificati grupul  in care a fost creata tabela.

SELECT i.data_space_id, 
       s.name as Filegroup
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS s
ON i.data_space_id = s.data_space_id 
WHERE i.object_id = OBJECT_ID(N'dbo.Produse');
GO

-- P6: Schimbati default filegroup.

USE Branch_xx;
GO

ALTER DATABASE Branch_xx MODIFY FILEGROUP Data_FG DEFAULT;
GO

-- P7: Creati o tabela noua fara a specifica un filegroup si verificati unde a fost creata.
--     Notati ca tabela a fost creata in Data_FG, care este acum noul default filegroup.

USE Branch_xx;
GO

CREATE TABLE dbo.Contact 
( ContactID int  NOT NULL,
  Titlu nvarchar(8) NULL,
  Prenume nvarchar(128) NOT NULL,
  Nume nvarchar(128) NOT NULL,
  AdresaEmail nvarchar(50) NULL
);
GO
	
SELECT i.data_space_id, 
       s.name as Filegroup
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS s
ON i.data_space_id = s.data_space_id 
WHERE i.object_id = OBJECT_ID(N'dbo.Contact');
GO


-- P8: Se sterge B.D. cu care s-a lucrat
USE master
go

DROP database Branch_xx
go