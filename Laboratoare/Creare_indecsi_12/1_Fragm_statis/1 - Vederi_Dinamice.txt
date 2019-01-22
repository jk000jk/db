
USE [Northwind_test]   --sau northwind
GO

--afisare indecsi din B.D.

select t.name [Nume tabel],i.name [Nume index], i.* from [sys].[sysindexes] i join sys.sysobjects t
on i.id=t.id
where t.xtype ='u' --u = tabele user
order by t.name 

-- se creaza o tabela
-- Statistici despre indecsi folosind vederi dinamice

-- P1: Stabilire context de lucru

USE Northwind   --sau alta B.D.
GO

-- P2: Vizualizare statistici indecsi folosind DMV (Dynamic Management Views)
--         In interogarea urmatoare cele trei valori NULL sunt pentru:
--          Obiect, index si partitie (aici se vizualizeaza toate)


SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'LIMITED');
--select OBJECT_NAME(245575913)
--select object_id('Employees')
--go
--sp_spaceused 'employees'

-- P3: Observati valoarea returnata pentru campul avg_fragmentation_in_percent

-- P4: Exista posibilitatea de-a alege nivelul de detaliu al informatiilor returnate.
--         Apelul urmator foloseste parametrul  SAMPLED.

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'SAMPLED');

-- P5: Apel cu parametrul de detaliu DETAILED.
--         Avertisment: aceasta optiune poate dura mai mult pe B.D. mari.

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'DETAILED');



CREATE TABLE [dbo].[t1](
	[c1] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO

USE [Northwind_test]
GO

DELETE FROM t1 WITH (TABLOCK) --se goleste tabela

INSERT INTO [dbo].[t1] default values
GO 1000

select * from t1

create clustered index t1_Ind_cl on t1(c1)
sp_helpindex t1
sp_help 't1'
sp_spaceused t1

delete from t1
truncate table t1 --elibereaza tot spatiul

select * from t1
select * from sys.sysindexes where id=OBJECT_id('t1')
select i.* from sys.sysindexes i join sys.sysobjects t
on i.id=t.id 
where t.xtype='u' and t.id=object_id('t1') --u= tabela user

dbcc showcontig('t1')
drop index t1_Ind_cl on t1

alter table t1 drop constraint pk_t1 --daca s-ar fi creat pe constr. de cheie primara
--constr. primary key se crea cu:
--   alter table t1 add constraint pk_t1 primary key (c1)



















