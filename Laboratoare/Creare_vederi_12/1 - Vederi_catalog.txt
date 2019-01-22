-- Interogare vederi sistem

-- P1  Stabilire context de lucru
USE Northwind -- sau B.D. pe care o aveti pe SQL  Server

-- P2  Afisare vederi user create in B.D.

SELECT * FROM sys.views;
GO

-- P3 Afisare tabele user create in B.D.

SELECT * FROM sys.tables;
GO

-- P4  Browse lista de vederi sistem in Object Explorer
--          (In Object Explorer click Connect, click Database Engine. In
--           fereastra Connect to Server, tastati (local) in  Server name si click Connect.
--           Expandati SQL server, expandati Databases, expandati B.D. dorita, expandati Views,
--           expandati System Views)

-- P5     SELECT * FROM INFORMATION_SCHEMA.TABLES (afiseaza tabele si vederi user)
--        pt. a compara rezultatele cu sys.tables 

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- P6 - Scroll down Object Explorer pt. a vedea lista DMS (dynamic management views)
--          (In Object Explorer in lista System Views pe care ati expandat-o
--           in P4, notati Views cu numele incepand cu sys.dm)

-- P7 Vizualizare i-tii conexiune curenta 

SELECT * FROM sys.dm_exec_connections;
GO

-- P8 Localizare sesiune curenta

SELECT * FROM sys.dm_exec_sessions order by session_id;
GO

-- P9 Localizare cerere de executie curenta. Copiati:
--     sql_handle (Hash map a textului SQL al cererii. Este nullable.) si 
--     plan_handle (Hash map a planului pt. executia SQL. Este nullable.) 
--     din SELECT-ul curent (din sesiunea dvs.)

SELECT * FROM sys.dm_exec_requests;
GO

-- P10  Vizualizare detalii i-ne SQL executata

SELECT * FROM sys.dm_exec_sql_text(sql_handle);
GO

-- P11 Vizualizare detalii planuri de executie din cache

SELECT * FROM sys.dm_exec_query_plan(plan_handle);
GO

-- P12 - Click pe planul XML returnat pt. a deschide graphical query plan

-- P13 - Vizualizare statistici despre planurile de executie din cache

SELECT * FROM sys.dm_exec_query_stats;
GO

--Vizualizare query:
select * from sys.dm_exec_sql_text (sql_handle/plan_handle)

--ex. de verificare ca sql_handle anterior e in cache
declare @var varbinary(64)
set @var =0x020000005097B03AC054C5C0E9C91CEE079B942A54BBDA7D00000000000000000000000000000000--sql_handle

SELECT * FROM sys.dm_exec_query_stats where sql_handle= @var


