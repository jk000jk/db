-- Creare statistici user pe o coloana a unui tabel

-- P1: Stabilire context de lucru

USE Northwind   --sau alta B.D.
GO



-- P2: Explorati statisticile existente pe tabela Employees (pot/nu pot sa existe statistici disponibile).
--         Daca exista si au prefixul _WA, ele sunt autostatistici.

SELECT * FROM sys.stats WHERE object_id = OBJECT_ID('Employees');
GO

-- P3: Creati statistici pe coloana FirstName din tabela Employees

CREATE STATISTICS Ang_Jobs_Stats_xx ON Employees (Title) -- xx este nr. dvs. de user
WITH FULLSCAN;
GO

-- P4: Verificati lista de statistici din nou 

SELECT * FROM sys.stats WHERE object_id = OBJECT_ID('Employees');
GO

-- P5: Folositi DBCC SHOW_STATISTICS pentru a obtine detalii despre statistici

DBCC SHOW_STATISTICS('Employees',Ang_Jobs_Stats_xx);
GO

-- P6: Notati cate linii exista pentru job-ul Sales Representative

-- P7: Executati urmatoarea interogare pentru a vedea daca statistica e corecta

SELECT COUNT(1) [Nr. job-uri] FROM Employees WHERE Title = 'Sales Representative';
GO

-- P8: Stergere statistica Ang_Jobs_Stats_xx din tabela Employees

DROP STATISTICS Employees.Ang_Jobs_Stats_xx