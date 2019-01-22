-- Demonstratie - Trigger AFTER UPDATE

-- P1: Se stabileste contextul implicit la B.D. tempdb

USE tempdb;
GO

-- P2: Se creaza tabela PretActual_xx --xx se va inlocui cu nr. user conectat la serverul UTM 

CREATE TABLE dbo.PretActual_xx
(
	ID_PretActual int IDENTITY(1,1) 
	  CONSTRAINT PK_ID_PretActual_xx PRIMARY KEY,
	PretVanzare decimal(18,2) NOT NULL,
	DataModificare datetime2 NOT NULL
	  CONSTRAINT DF_Data_Modificare_Pret_xx
	  DEFAULT (SYSDATETIME()),
	ModificatDe sysname NOT NULL
	  CONSTRAINT DF_Pret_ModificatDe_xx
	  DEFAULT (suser_sname())
);
GO

-- P3: Populare tabela

INSERT INTO dbo.PretActual_xx 
  (PretVanzare)
  VALUES (2.3), (4.3), (5);
GO

-- P4: Afisare continut curent actual tabela PretActual_xx

SELECT * FROM dbo.PretActual_xx;
GO
  
-- P5: Actualizare articol cu ID_PretActual = 2

UPDATE dbo.PretActual_xx 
SET PretVanzare = 10 
WHERE ID_PretActual = 2;
GO

-- P6: Afisare linii tabel. Observam ca nu s-a actualizat coloana  
--         DataModificare

SELECT * FROM dbo.PretActual_xx;
GO

-- P7: Creare trigger pt. a face update pe coloanele DataModificare si ModificatDe

CREATE TRIGGER TR_PretCurent_Update_xx
ON dbo.PretActual_xx
AFTER UPDATE 
AS 
BEGIN
  SET NOCOUNT ON;
  UPDATE pa
  SET pa.DataModificare = SYSDATETIME(),
      pa.ModificatDe = suser_sname()
  FROM dbo.PretActual_xx AS pa
  INNER JOIN inserted AS i
  ON pa.ID_PretActual = i.ID_PretActual;
END;
GO

-- P8: Testare instructiune UPDATE din nou, apoi se reafiseaza tabela.
--         Coloanele DataModificare si ModificatDedbo sunt updatate.

UPDATE dbo.PretActual_xx 
SET PretVanzare = 20 
WHERE ID_PretActual = 2;
GO

SELECT * FROM dbo.PretActual_xx ;
GO

-- P9: Interogare vedere sys.triggers pt. afisare triggers din B.D. tempdb

SELECT * FROM sys.triggers;
GO

-- P10: Stergere tabela PretActual_xx 

DROP TABLE dbo.PretActual_xx ;
GO

-- P11: Reinterogam vederea  sys.triggers si observam ca trigger-ul
--  e sters odata cu tabela

SELECT * FROM sys.triggers;
GO
