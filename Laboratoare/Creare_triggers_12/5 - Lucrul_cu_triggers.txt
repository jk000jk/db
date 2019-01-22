-- SE creaza un trigger pentru actualizare date derivate

-- p1: Se stabileste contextul implicit in B.D. tempdb

USE tempdb;
GO

-- P2: Vom crea doua tabele noi Categorii_noi_xx si Produse_noi_xx,
--     unde xx este nr. de user cu care v-ati autentificat la server.
--     Ele vor fi populate cu inregistrari din B.D. Northwind, tabelele Categories respectiv Products.
--     A se retine ca nu se mostenesc constrangerile PK si FK din tabelele Categories si Products.

SELECT * INTO Categorii_noi_xx FROM [Northwind].dbo.Categories
GO

SELECT * INTO Produse_noi_xx FROM [Northwind].dbo.Products
GO


--P3: Se creaza un trigger pe tabela Categorii_noi_xx care atribuie coloanei Discontinued 
--    a tabelei Produse_noi_xx valoarea 1, cand categoria careia ii apartin produsele este stearsa.

CREATE TRIGGER CAT_Sterg_xx
ON Categorii_noi_xx
AFTER DELETE
AS
	SET NOCOUNT ON
	UPDATE P SET DISCONTINUED = 1
	FROM Produse_noi_xx P INNER JOIN Deleted d
	ON p.CategoryID = d.CategoryID

-- P4: Se afiseaza triggers din B.D. tempdb

SELECT name [Nume trigger], parent_obj [ID parinte trigger]
FROM sys.sysobjects
WHERE type='TR'
ORDER BY name

-- Se afiseaza numele unui parinte de trigger (vedere sau tabel)
SELECT OBJECT_NAME(373576369) [Nume parinte] -- Vezi instructiunea anterioara

-- Se afiseaza informatiile despre triggers dintr-o tabela

sp_helptrigger Categorii_noi_xx

-- P5: Se testeaza trigger creat anterior
--    Se vizualizeaza valoarea coloanei Discontinued pentru produsele din categoria 7

SELECT ProductID, CategoryID, Discontinued
FROM Produse_noi_xx
WHERE CategoryID = 7 --Sunt 5 produse, unul are Discontinued 1

--         Se sterge categoria 7 din tabela Categorii_noi_xx
DELETE Categorii_noi_xx WHERE CategoryID = 7

-- Se verifica tabela Produse_noi_xx si se va observa ca triggerul Cat_Sterg_xx s-a declansat.
-- Toate cele 5 produse au coloana Discontinued cu valoarea 1.

SELECT ProductID, CategoryID, Discontinued
FROM Produse_noi_xx
WHERE CategoryID = 7

-- P6: Creare trigger mai complex
-- Se creaza un trigger pe tabela Produse_noi_xx care-si propune, atunci cand se sterge un produs,
-- sa verifice daca sunt comenzi in curs care-l solicita; daca sunt se face rollback tranzactie
-- (nu se permite stergerea unui produs care are istoric de comenzi)

CREATE trigger [dbo].[Prod_Sterg_xx]
ON [dbo].[Produse_noi_xx]
FOR DELETE
AS
  IF(SELECT Count(*) FROM Deleted) > 1
  BEGIN
  RAISERROR('Tranzactia nu se accepta. Nu se poate sterge decat un produs !!',16,1)
  ROLLBACK TRANSACTION
  RETURN
  END
  
  IF(SELECT Count(*) FROM Northwind.dbo.[Order Details] OD INNER JOIN Deleted D
    ON OD.ProductID=D.ProductID) > 0
  BEGIN
  RAISERROR('Tranzactia nu se accepta. Produsul are istoric de comenzi !!',16,1)
  ROLLBACK TRANSACTION
  RETURN
  END
  
  IF (SELECT COUNT(*) FROM Deleted) > 0
   SELECT 'Produsul cu codul '+ ltrim(str(deleted.productid))+' a fost sters !!' from deleted 
   ELSE
   SELECT 'Produsul nu exista!' 

--P7: Se testeaza triggerul creat la P6
--7.1 Se sterge un produs care are istoric de comenzi
delete dbo.produse_noi_xx where productid=6

-- Se obtine mesajul:
--Msg 50000, Level 16, State 1, Procedure Prod_Sterg_xx, Line 15
--Tranzactia nu se accepta. Produsul are istoric de comenzi !!
--Msg 3609, Level 16, State 1, Line 1
--The transaction ended in the trigger. The batch has been aborted.

--7.2 Se incearca stergerea mai multor produse simultan
  delete dbo.produse_noi_xx where productid=6 or productid=7

-- Se obtine mesajul:
--Msg 50000, Level 16, State 1, Procedure Prod_Sterg_xx, Line 7
--Tranzactia nu se accepta. Nu se poate sterge decat un produs !!
--Msg 3609, Level 16, State 1, Line 1
--The transaction ended in the trigger. The batch has been aborted.

--7.3 Se insereaza un produs nou cu comanda:
INSERT INTO [dbo].[Produse_noi_xx](ProductName,Discontinued)  VALUES  ('Produs nou',0)
GO

-- se vizualizeaza noul produs cu c-da:
SELECT * FROM Produse_noi_xx WHERE ProductName LIKE 'Produs%' -- vezi valoarea ProductID 

-- se sterge acest produs cu c-da:
delete dbo.produse_noi_xx where productid=valoare_productid -- vezi instructiune anterioara

-- se obtine mesajul:
--Produsul cu codul 79 a fost sters !! (79 era valoarea presupusa anterior pentru valoare_productid)

--7.4 Se incearca stergerea unui produs inexistent din tabela Produse_noi_xx

 delete dbo.produse_noi_xx where productid=799

-- se obtine mesajul:
-- Produsul nu exista!
