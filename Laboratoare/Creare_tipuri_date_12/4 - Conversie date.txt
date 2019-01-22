-- Demonstratie: Conversia tipurilor de date

-- P1: Se face B.D. tempdb implicita

USE tempdb;
GO

-- P2: Executati instructiunile urmatoare pt. a vedea 
--     diferitele formate de conversie a datelor
 
SELECT CAST(SYSDATETIME() as varchar(20)) as [Format implicit],
		   CONVERT(varchar(20), SYSDATETIME(), 110) as USA,
		   CONVERT(varchar(20), SYSDATETIME(), 104) as Germania,
		   CONVERT(varchar(20), SYSDATETIME(), 105) as Italia,
		   CONVERT(varchar(20), SYSDATETIME(), 112) as ISO,
		   CONVERT(varchar(20), SYSDATETIME(), 114) as [Timpul curent];
GO

-- P3: Executati interogari pt. a vedea setarile de limbaj
--     care afecteaza conversia de date

CREATE TABLE dbo.TestDate_xx --xx este nr. dvs. de user 
(
  id int NOT NULL IDENTITY,
  BirthDate date --YYYY-MM-DD 
);

sp_helplanguage --afiseaza formatele de date calend. functie de limbaj
SELECT @@LANGUAGE --afiseaza limbajul curent pt. sesiune
SET LANGUAGE US_ENGLISH;
INSERT INTO dbo.TestDate_xx (BirthDate)
VALUES('12.2.2018'), (CAST ('12.2.2018' as DATE));	

SET LANGUAGE GERMAN;
INSERT INTO dbo.TestDate_xx (BirthDate)
VALUES('12.2.2018'),(CAST ('12.2.2018' as DATE));

SELECT *, MONTH(BirthDate) AS [Luna] FROM dbo.TestDate_xx;
GO

-- P4: Executati  interogari independente de setari

TRUNCATE TABLE dbo.TestDate_xx;

SET LANGUAGE US_ENGLISH;
INSERT INTO dbo.TestDate_xx (BirthDate)
VALUES('19720201'), (CONVERT (DATE,'1.2.1972', 104)); --104:german, dd.mm.yy	

SET LANGUAGE GERMAN;
INSERT INTO dbo.TestDate_xx (BirthDate)
VALUES('19720201'),(CONVERT (DATE,'1.2.1972' ,104));

SELECT *, MONTH(BirthDate) AS [Luna],DAY (birthdate) [Zi] FROM dbo.TestDate_xx;
GO

-- P5: Executati o interogare care truncheaza un sir in timpul conversiei.

SELECT CAST('Acesta este un sir de caractere de max 12.' as VARCHAR(12));
GO

-- P6: Inaintea executiei urmatoarelor i-ni, calculati expresia
--     si verificati iesirea pt. confirmare.

DECLARE @int1 int = 1;
DECLARE @int2 int = 2;
DECLARE @caracter char(1) = '5';
DECLARE @numeric numeric(18,2) = 1.0;

SELECT @int1/@int2 [Impartire doi intregi];
SELECT @numeric/@int2 [Impartire numeric la intreg];
SELECT @int2 * @caracter [Inmultire intreg cu caracter];--converteste char la int
SELECT @caracter / @int2 [Impartire caracter la intreg];--converteste char la int
SELECT @caracter/CAST (@int2  as real) [Impartire caracter la intreg convertit];-- conversie explicita 
GO

-- P7: Executati o instructiune TRY_PARSE

SELECT 
  CASE WHEN TRY_PARSE('100.089' AS decimal USING 'sr-Latn-CS') IS NULL 
       THEN 'Nu este un numar zecimal!' 
       ELSE 'Este un numar zecimal!' 
  END AS Rezultat ;
