
-- P1: Stabilire context de lucru B.D. tempdb

USE tempdb;
GO

-- P2: Creare tabela Oportunitate

CREATE TABLE dbo.Oportunitate_xx --xx este nr. dvs. de user(pe site utm-vac-ts1)
( 
  OpportunitateID int NOT NULL,
  Cerinte nvarchar(50) NOT NULL,
  DataPrimire date NOT NULL,
  DataFinal date NULL,
  SalespersonID int NULL,
  Rating int NOT NULL
);

-- P3: Populare tabela cu doua linii

INSERT INTO dbo.Oportunitate_xx
  (OpportunitateID, Cerinte, DataPrimire , DataFinal ,
   SalespersonID,Rating)
VALUES (1,'Participare la curs!', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9),
       (2,'Primire documentatie gratis!', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 37,2);

-- P4: Incercati sa omiteti valoarea pt. cp. OportunitateID.
-- Va aparea o eroare pt. ca o coloana NOT NULL cere o valoare.


INSERT dbo.Oportunitate_xx 
  (Cerinte, DataPrimire , DataFinal,SalespersonID ,Rating )
VALUES ('O noua oportunitate', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9);

-- P5: Creati o tabela cu un tip de data  uniqueidentifier 

CREATE TABLE dbo.TestareGuid_xx
(
  id INT NOT NULL IDENTITY(1,1),
  [Guid] UNIQUEIDENTIFIER NOT NULL
);

-- P6: Adaugati 3 linii la tabela TestareGuid_xx folosind functia NEWID().				

INSERT INTO dbo.TestareGuid_xx ([Guid]) 
VALUES (NEWID()),(NEWID()),(NEWID());

-- P7: Examinati continutul tabelei TestareGuid_xx

SELECT * FROM dbo.TestareGuid_xx;

-- P8: Stergeti tabelele create anterior

DROP TABLE dbo.Oportunitate_xx ;
DROP TABLE dbo.TestareGuid_xx ;
