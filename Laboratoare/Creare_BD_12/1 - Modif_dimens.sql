--B.D. ---- modificare dimensiune si populare cu date

-- P1: Deschideti Object Explorer, expandati SQL Server, expandati Databases, expandati System Databases,
--     right-click tempdb si click properties. Selectati Files tab si revedeti dimensiunea 
--     initiala a B.D. tempdb si afisierului de log. De asemenea revedeti setarile Autogrowth.  

-- P2: Modificati valoarea initiala a fisierului de date al B.D. tempdb la 20MB si click OK pt. 
--     a creste dimensiunea acestuia.

-- Step 3: Right-click tempdb in Object Explorer si apoi selectati Reports -> Standard Reports -> Disk Usage 
--         si notati ca dimensiunea B.D. tempdb s-a modificat si ca fisierul de date tempdb a fost modificat
--         si este aproape gol.
--         (In graficul de tip placinta, apare ca "Unallocated")

-- P4: Selectati si executati codul urmator in B.D. tempdb.

USE tempdb;
GO

CREATE TABLE #TempTable_xx --xx este nr. dvs. de user, cu care v-ati autentificat la server-ul UTM 
( id int IDENTITY(1,1), 
  col1 char(4000)
);
GO

SET NOCOUNT ON;
DECLARE @i int = 0;

WHILE @i < 10000
	BEGIN 
	INSERT INTO #TempTable_xx (col1) VALUES('Date de test');
	SET @i += 1;	
	END; 
GO

-- P5: Right click B.D. tempdb in Object Explorer si selectati Reports -> Standard Reports -> Disk Usage 
--     si notati ca dimensiunea B.D. tempdb s-a modificat si ca fisierul de date este full.
--     Expandati Data/Log File Autogrow/Autoshrink Events pt. a vedea evenimentele autogrow petrecute.

-- P6: Restart SQL server
--     (In Object Explorer right-click SQL server, si click Restart. In fereastra de dialog Microsoft 
--     SQL Server Management Studio, click Yes. In fereastra de dialog Next Microsoft SQL Server 
--     Management Studio, click Yes).

-- P7: Right click tempdb in Object Explorer si selectati Reports -> Standard Reports -> Disk Usage. 
--     De notat ca dimensiunea B.D. tempdb a revenit la valoarea anterior configurata de 20MB. 

