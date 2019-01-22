--Demonstratie: tip de date rowversion

-- P1: Stabilire tempdb ca B.D. implicita

USE tempdb;
GO

-- P2: Creati si populati o tabela care foloseste tipul de date rowversion

CREATE TABLE dbo.Comenzi_xx --xx este nr. dvs. de user 
( 
  IDCda int NOT NULL
    IDENTITY(1,1),
  DataCda date NOT NULL,
  SalespersonID int NULL,
  Potrivire rowversion NOT NULL
);
GO

-- P3: Adaugati 2 linii in to dbo.Comenzi_xx

INSERT dbo.Comenzi_xx (datacda)
VALUES (SYSDATETIME()),
       (SYSDATETIME());
GO
		   
-- P4: Observati ca s-a populat automat coloana Potrivire(rowversion)

SELECT * FROM dbo.Comenzi_xx ;		   
GO

-- P5: Incercati sa actualizati coloana rowversion.
--     Update va esua pt. ca nu se poate actualiza direct o col. rowversion.

UPDATE dbo.Comenzi_xx 
  SET Potrivire  = Potrivire  +1
  WHERE IDCda  =1;
GO

-- P6: Incercati sa inserati o valoare explicita pt. coloana rowversion.
--     Insert va esua pt. ca nu se poate insera direct intr-o col. rowversion.
 
INSERT dbo.Comenzi_xx (DataCda, Potrivire)
VALUES (SYSDATETIME(), 0x00000000000007E4);
GO

-- P7: Update alta coloana pentru IDCda 1

SELECT * FROM dbo.Comenzi_xx 		   
WHERE IDcda = 1;

UPDATE dbo.Comenzi_xx 
  SET SalespersonID = 50 
  WHERE IDCda  = 1;

SELECT * FROM dbo.Comenzi_xx  --a se vedea ca s-a schimbat si valoarea rowversion
WHERE IDCda  = 1;		   
GO

 
