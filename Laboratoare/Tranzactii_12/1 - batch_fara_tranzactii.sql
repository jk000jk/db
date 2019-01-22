-- Lucrul netranzactional intr-un batch

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
-- se creaza trei tabele care vor fi referite mai departe(prin copiere din b.d. northwind sau northwind_test)

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

-- P3: Executati un batch multi-instructiune cu erori
-- NOTA: ACEST PAS VA CAUZA EROARE

BEGIN TRY
	INSERT INTO dbo.Czi_xx (custid, empid, orderdate) VALUES ('ALFKI',9,'2018-07-12');
	INSERT INTO dbo.Czi_xx(custid, empid, orderdate) VALUES ('ALFKI',3,'2018-07-15');
	INSERT INTO dbo.DetaliiCzi_xx (orderid,productid,unitprice,qty) VALUES (1, 2,15.20,20);
	INSERT INTO dbo.DetaliiCzi_xx (orderid,productid,unitprice,qty) VALUES (999,77,26.20,15); --nu ex. comanda cu orderid=999
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrNum, ERROR_MESSAGE() AS ErrMsg;
END CATCH;

-- P4: Aratati ca chiar cu tratarea erorii
-- executia s-a facut partial cu succes si unele linii au fost inserate

SELECT  orderid, custid, empid, orderdate
FROM dbo.Czi_xx ;

SELECT  orderid, productid, unitprice, qty
FROM dbo.DetaliiCzi_xx;


-- P5: Stergeti cele doua tabele care au sustinut demonstratiile: Czi_xx si DetaliiCzi_xx


IF OBJECT_ID('dbo.DetaliiCzi_xx','U') IS NOT NULL --xx este nr. de user utm-vac-ts1
	DROP TABLE dbo.DetaliiCzi_xx;

IF OBJECT_ID('dbo.Czi_xx','U') IS NOT NULL
	DROP TABLE dbo.Czi_xx;
GO