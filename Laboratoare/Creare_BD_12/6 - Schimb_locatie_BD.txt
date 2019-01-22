--B.D.--- Modificare loc de stocare a unei B.D. 


-- P1: Vom modifica locatia de stocare a fisierelor B.D. EvalValuta, creata anterior(vezi lab. 5):

-- P1.1  ALTER DATABASE database_name SET OFFLINE; 
--       Exemplu:
 ALTER DATABASE EvalValuta_xx SET OFFLINE;--xx este nr. dvs. de user

-- P1.2: Se muta fisierul sau fisierele in noua locatie

-- P1.3 Pt. fiecare fisier mutat se executa i-nea:

--        ALTER DATABASE database_name 

--        MODIFY FILE ( NAME = logical_name, FILENAME = 'new_path\os_file_name' );  
--        Exemplu:

USE master;
GO

ALTER DATABASE EvalValuta_xx 
MODIFY FILE (NAME = EvalValuta_dat, FILENAME = 'F:\Public\B_date\EvalValuta_xx.mdf'); --fis. date
GO
ALTER DATABASE EvalValuta_xx 
MODIFY FILE (NAME = EvalValuta_log, FILENAME = 'F:\Public\B_date\EvalValuta_xx.ldf');--fis. log
GO
-- ........ 

  
-- P2: Rulati i-nea urmatoare:
--     ALTER DATABASE database_name SET ONLINE; 
--     Exemplu:

ALTER DATABASE EvalValuta_xx SET ONLINE;

--P3: Verificati ca fisierele si-au schimbat locatia ruland interogarea:

--SELECT name [Nume fisier:], physical_name AS [Locatia curenta:], state_desc  
--FROM sys.master_files  
--WHERE database_id = DB_ID(N'<database_name>');  
--    Exemplu:


SELECT name [Nume fisier:], physical_name AS [Locatia curenta:], state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'EvalValuta_xx');  

--P4: Stergere B.D.

Use master
go

DROP DATABASE evalvaluta_xx

