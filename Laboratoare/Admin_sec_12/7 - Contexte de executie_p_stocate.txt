--Lucrul cu contexte de executie in procedurile stocate

use tempdb
go

--P1 se creaza sqllogin1 si sqllogin2 (logins autentificati SQL Server)
--   mapati pe B.D. curenta, cu numele: sqluser1 si sqluser2 ---> se vor crea automat doi users in tempdb:sqluser1 si sqluser2

--P2 se creaza schema x care-l are proprietar pe sqluser2

--P3 se creaza urmatoarele p.s. in tempdb

 create procedure x.afisare_context_sec
  as
  SET NOCOUNT ON
  select * from sys.login_token
  select * from sys.user_token
  return
  go

 create procedure dbo.afisare_context_sec
  as
  SET NOCOUNT ON
  select * from sys.login_token
  select * from sys.user_token
  return
  go

CREATE PROCEDURE dbo.usp_Demo
  WITH EXECUTE AS 'SqlUser1'
  AS
  SET NOCOUNT ON
  SELECT user_name() [Context executie initial p.s.]   ; -- contextul de executie este SqlUser1.
	exec dbo.afisare_context_sec ---sqlUser1 are permis. EXECUTE pe p.s.(aceeasi schema dbo)
  EXECUTE AS CALLER;
  SELECT user_name() [Context apelant p.s.]; -- contextul de executie este SqlUser2, apelantul p.s.
    exec dbo.afisare_context_sec
  REVERT; --revenire la contextul initial de exec.
  SELECT user_name() [Context dupa REVERT]; -- contextul de executie este SqlUser1.
  exec [x].afisare_context_sec --schema x are proprietar (schema owner) pe sqluser2
  GO

--P4 se da permisiunesa EXECUTE lui sqluser2 pe p.s. dbo.usp_demo

--P5 se schimba contextul de executie la user sqluser2
execute as user='sqluser2'
go 


--P6 se executa procedura stocata dbo.usp_demo
   exec dbo.usp_demo 

-- P7 se vizualizeaza rezultatul executiei de la P6
--Obs. Va esua executia x.afisare_context_sec (daca sqluser2 nu da perm. EXECUTE lui sqluser1)

--P8 revenire la contextul initial (dinainte de executie p.s. dbo.usp_demo)
REVERT 
go