
-- P1: Stabiliti tempdb ca B.D. implicita

USE tempdb;
GO

-- P2: Afisati collation pt. instanta si B.D. tempdb

SELECT SERVERPROPERTY('Collation') as [Collation Instanta],
       DATABASEPROPERTYEX('tempdb','Collation') as [Collation B.D. tempdb];

-- P3: Creati si polulati o tabela fara a specifica collations

CREATE TABLE dbo.TestCharacter_xx --xx este nr. dvs. de user (cu care v-ati conectat la serv. utm)
(
  id int NOT NULL IDENTITY(1,1),
  NonUnicodeData varchar(10),
  UnicodeData nvarchar(10)
);
	
INSERT dbo.TestCharacter_xx (NonUnicodeData,UnicodeData)
VALUES ('Hello',N'Hello'),
       ('??',N'??'),
       ('?????',N'?????');

-- P4: Afisati datele care au fost inserate

SELECT * FROM dbo.TestCharacter_xx;

-- P5: Creati si populati o tabela cu diferite collations pt. coloane

CREATE TABLE dbo.TestCharacter2_xx
(
  id int NOT NULL IDENTITY(1,1),
  CIData varchar(10) COLLATE Latin1_General_CI_AS,
  CSData varchar(10) COLLATE Latin1_General_CS_AS
);

INSERT INTO dbo.TestCharacter2_xx (CIData,CSData)
VALUES ('Test Data','Test Data');

-- P6: Executati interogari care incearca sa compare aceleasi valori din fiecare coloana cu 'test data'
--         values from each column with all lower case

SELECT * FROM dbo.TestCharacter2_xx 
WHERE CIData = 'test data';

SELECT * FROM dbo.TestCharacter2_xx
WHERE CSData = 'test data';

-- P7: Executati o interogare care face o cautare case-insensitive pe date case-sensitive

SELECT * FROM dbo.TestCharacter2_xx
WHERE CSData = 'test data' COLLATE Latin1_General_CI_AS;

-- P8: Incercati sa executati o interogare care compara doua coloane cu collations diferite.
-- Va esua daca nu se rezolva collation conflict.

SELECT * FROM dbo.TestCharacter2_xx 
WHERE CIData = CSData;

-- P9: Executati interogarea de la P8 specificand un collation

SELECT * FROM dbo.TestCharacter2_xx
WHERE CIData = CSData COLLATE Latin1_General_CI_AS;