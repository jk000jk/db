-- Demonstratie - Folosire triggers INSTEAD OF 

-- P1: Se stabileste contextul implicit in B.D. tempdb

USE tempdb;
GO

-- P2: Se creaza tabela PretActual_xx --xx se va inlocui cu nr. user conectat la serverul UTM 
-- apoi se populeaza (daca exista anterior, se va sterge)
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
	  DEFAULT (suser_sname()),
	  EValid bit NOT NULL
	  CONSTRAINT DF_PretCurent_EValid_xx
	  DEFAULT (1)
);
GO

INSERT INTO dbo.PretActual_xx 
  (PretVanzare)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.PretActual_xx;
GO

-- P3: Creare  trigger  INSTEAD OF DELETE

CREATE TRIGGER TR_PretCurent_Delete_xx
ON dbo.PretActual_xx
INSTEAD OF DELETE AS
BEGIN
  SET NOCOUNT ON;
  UPDATE pc
  SET pc.EValid = 0
  FROM dbo.PretActual_xx AS pc
  INNER JOIN deleted AS d
  ON pc.ID_PretActual = d.ID_PretActual;
END;
GO

-- P4: Incercare de-a sterge o linie. Linia cu ID_PretActual = 2 este
--     afectata(coloana EValid e facuta 0, fara a sterge efectiv linia)

DELETE dbo.PretActual_xx
WHERE ID_PretActual = 2;
GO

SELECT * FROM dbo.PretActual_xx WHERE ID_PretActual = 2;
GO

-- P5: Interogare vedere sys.triggers--de vazut ca valoarea coloanei
--     is_instead_of_trigger este 1 pt. trigger-ul TR_PretCurent_Delete

SELECT * FROM sys.triggers;
GO

-- P6: Stergere tabela (si, odata cu ea, trigger-ul)

DROP TABLE dbo.PretActual_xx;
GO

-- P7: Creare alt tabel cu doua coloane de tip string

CREATE TABLE dbo.CodPostal_xx
( IDClient int PRIMARY KEY,
  CodPostal nvarchar(5) NOT NULL,
  SubCodPostal nvarchar(5) NULL
);
GO

-- P8: Creare vedere pornind de la tabelul CodPostal 
--     care concateneaza coloanele de tip sir

CREATE VIEW dbo.RegiunePostala_xx
AS
SELECT IDClient,
       CodPostal + COALESCE('-' + SubCodPostal,'') AS [Regiune postala]
FROM dbo.CodPostal_xx;
GO

-- P9: Inserare date in tabela de baza

INSERT dbo.CodPostal_xx (IDClient ,CodPostal,SubCodPostal)
VALUES (1,'23422','234'),
       (2,'23523',NULL),
       (3,'08022','523');
GO
       
-- P10: Afisare continut tabela de baza

SELECT * FROM dbo.CodPostal_xx;
GO

-- P11: Incercare de-a insera date in vedere (va esua - vedeti eroare!)

INSERT INTO dbo.RegiunePostala_xx (IDClient,[Regiune postala])
VALUES (4,'09232-432');
GO

-- P12: Incercare de-a updata vederea (va esua - vedeti eroare!)

UPDATE dbo.RegiunePostala_xx SET [Regiune postala] = '23234-523' WHERE IDClient = 3;
GO

-- P13: Incercare de-a sterge o linie prin vedere 

DELETE FROM dbo.RegiunePostala_xx WHERE IDClient = 3;
GO

-- Intrebare: De ce DELETE s-a executat cu succes, iar INSERT si UPDATE au esuat?

-- P14: Creati un trigger INSTEAD OF INSERT 

CREATE TRIGGER TR_RegiunePostala_Insert_xx
ON dbo.RegiunePostala_xx
INSTEAD OF INSERT
AS
INSERT INTO dbo.CodPostal_xx 
SELECT IDClient, 
       SUBSTRING([Regiune postala],1,5),
       CASE WHEN SUBSTRING([Regiune postala],7,5) <> '' 
	     THEN SUBSTRING([Regiune postala],7,5) 
	   END
FROM inserted;
GO

-- P15: Reincercare de-a insera date in vedere(apoi afisam tabelul de baza)

INSERT INTO dbo.RegiunePostala_xx (IDClient,[Regiune postala])
VALUES (4,'09232-432');
GO

SELECT * FROM CodPostal_xx
GO

-- P16: Observam ca primim mesajul ca au fost afectate doua linii

-- P17: Modificam trigger-ul pt. a elimina un mesaj fals

ALTER TRIGGER TR_RegiunePostala_Insert_xx
ON dbo.RegiunePostala_xx
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
INSERT INTO dbo.CodPostal_xx 
SELECT IDClient, 
       SUBSTRING([Regiune postala],1,5),
       CASE WHEN SUBSTRING([Regiune postala],7,5) <> '' 
	     THEN SUBSTRING([Regiune postala],7,5) 
	   END
FROM inserted;
GO

-- P18: Inserare date in vedere, dupa modificare trigger

INSERT INTO dbo.RegiunePostala_xx(IDClient,[Regiune postala])
VALUES (5,'92232-142');
GO

-- P19: De notat ca se afiseaza ca doar o linie a fost afectata

-- P20: Asigurati-va ca trigger-ul lucreaza si pt. inserari multiple

INSERT INTO dbo.RegiunePostala_xx(IDClient,[Regiune postala])
VALUES (6,'11111-111'),
       (7,'99999-999');
GO

SELECT * FROM dbo.RegiunePostala_xx; --afisare date prin vedere
GO
--si

SELECT * FROM dbo.CodPostal_xx; --afisare date prin tabela de baza
GO

-- P21: Stergere vedere si tabela

DROP VIEW dbo.RegiunePostala_xx;
GO

DROP TABLE dbo.CodPostal_xx;
GO
