-- Demonstratie - Trigger AFTER DELETE 

-- P1: Deschideti o interogare noua si 
--         folositi B.D. tempdb

USE tempdb;
GO

-- P2 Creati o tabela numita categorii_xx si alta produse_xx
SELECT * INTO categorii_xx FROM northwind.dbo.Categories
go

SELECT * INTO produse_xx FROM northwind.dbo.Products
go

-- P3: Creati un trigger DELETE pe tabela Categorii_xx 
-- Va sterge toate produsele din tabela produse_xx care apartin acelei categorii 
-- Mai intai verific daca trigger-ul exista deja; daca da, il sterg !

IF EXISTS(SELECT name FROM sys.sysobjects 
    WHERE type='TR' AND  name='TR_categ_Delete_xx')
	DROP TRIGGER TR_categ_Delete_xx
	GO

CREATE TRIGGER TR_categ_Delete_xx
ON categorii_xx
AFTER DELETE
AS 
BEGIN
   IF (SELECT COUNT(*)  FROM deleted) > 1
     BEGIN
         SELECT 'Nu se pot sterge mai multe categorii simultan!';
	 ROLLBACK;
     END
  ELSE
        BEGIN
        IF EXISTS( SELECT 1 FROM deleted AS d) 
		BEGIN
		 DELETE produse_xx  FROM Produse_xx p
		 JOIN deleted d  ON p.CategoryID=d.CategoryID
		 SELECT 'Produsele au fost sterse!'
		END
		ELSE
			BEGIN
			SELECT 'Nr. categorie gresit! Verificati tabela de categorii!';
			ROLLBACK;           
			END;
	END
END;
GO

-- P4: Testare trigger 
--4.1  Se incearca stergerea a doua categorii (va esua)
DELETE categorii_xx WHERE CategoryID=1 or CategoryID=2
GO

--4.2  Se incearca stergerea unei categorii existente (va lucra)
DELETE categorii_xx WHERE CategoryID=1 
GO
--Verificare stergere
SELECT * FROM produse_xx WHERE CategoryID=1 
GO

--4.3  Se incearca stergerea unei categorii inexistente (nu va lucra)
DELETE categorii_xx WHERE CategoryID=99 
GO

-- P5: Stergere trigger

DROP TRIGGER TR_categ_Delete_xx;
GO



