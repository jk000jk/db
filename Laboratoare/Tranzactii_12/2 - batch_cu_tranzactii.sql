-- Lucrul tranzactional intr-un batch

-- P1: Stabiliti contextul de lucru la B.D. tempdb
USE tempdb;
GO

-- P2: Creati doua tabele pt. a sustine demonstratiile: Czi_xx si DetaliiCzi_xx
-- Stergeti tabelele daca exista deja

IF OBJECT_ID('dbo.DetaliiCzi_xx','U') IS NOT NULL --xx este nr. de user utm-vac-ts1
	DROP TABLE dbo.DetaliiCzi_xx;
IF OBJECT_ID('dbo.Czi_xx','U') IS NOT NULL
	DROP TABLE dbo.Czi_xx;
GO
-- se creaza trei tabele(daca nu exista) care vor fi referite 
-- mai departe(prin copiere din b.d. northwind sau northwind_test)

SELECT * into clienti_xx from northwind.dbo.customers
ALTER TABLE clienti_xx  ADD constraint alfa_xx PRIMARY key( customerid) -- definire primary key

SELECT * into angajati_xx from northwind.dbo.Employees  
ALTER TABLE angajati_xx  ADD constraint beta_xx PRIMARY key( employeeid) -- definire primary key

SELECT * INTO produse_xx FROM northwind.dbo.Products 
ALTER TABLE produse_xx ADD constraint gama_xx PRIMARY key( productid) -- definire primary key

-- se creaza tabelele detaliiczi_xx si  czi_xx
CREATE TABLE dbo.Czi_xx(
	orderid int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	custid nchar(5) collate SQL_Latin1_General_CP1_CI_AS FOREIGN KEY REFERENCES clienti_xx(customerid) NOT NULL  ,
	empid int NOT NULL FOREIGN KEY REFERENCES angajati_xx(employeeid),
	orderdate datetime NOT NULL
);
GO

CREATE TABLE dbo.DetaliiCzi_xx(
	orderid int NOT NULL FOREIGN KEY REFERENCES dbo.Czi_xx(orderid),
	productid int NOT NULL FOREIGN KEY REFERENCES produse_xx(productid),
	unitprice money NOT NULL,
	qty smallint NOT NULL,
 CONSTRAINT PK_OrderDetails_xx PRIMARY KEY (orderid, productid)
);
GO


-- P3: Crea?i o tranzac?ie pentru a împacheta instruc?iunile de inserare

BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO dbo.Czi_xx (custid, empid, orderdate) VALUES ('ALFKI',9,'2018-07-12');
		INSERT INTO dbo.DetaliiCzi_xx (orderid,productid,unitprice,qty) VALUES (1, 2,15.20,20);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrNum, ERROR_MESSAGE() AS ErrMsg;
	ROLLBACK TRANSACTION
END CATCH;

 -- P4: Verificati executia cu success
SELECT  orderid, custid, empid, orderdate
FROM dbo.Czi_xx;
SELECT  orderid, productid, unitprice, qty
FROM dbo.DetaliiCzi_xx ;

-- P5: Stergeti liniile anterioare
DELETE FROM dbo.DetaliiCzi_xx ;
GO
DELETE FROM dbo.Czi_xx 
GO

--P6: Executati cu erori in date pt. a testa tratarea tranzactiei
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO dbo.Czi_xx(custid, empid, orderdate) VALUES ('ALFKI',3,'2018-07-15');
		INSERT INTO dbo.DetaliiCzi_xx (orderid,productid,unitprice,qty) VALUES (999,77,26.20,15); --nu ex. comanda cu orderid=999
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrNum, ERROR_MESSAGE() AS ErrMsg;
	ROLLBACK TRANSACTION
END CATCH;

-- P7: Verificati ca nu exista rezultate partiale
SELECT  orderid, custid, empid, orderdate
FROM dbo.Czi_xx ;
SELECT  orderid, productid, unitprice, qty
FROM dbo.DetaliiCzi_xx ;


-- P8: Clean up demonstration tables
IF OBJECT_ID('dbo.Czi_xx','U') IS NOT NULL
	DROP TABLE dbo.Czi_xx ;
IF OBJECT_ID('dbo.detaliiczi_xx','U') IS NOT NULL
	DROP TABLE dbo.DetaliiCzi_xx ;
