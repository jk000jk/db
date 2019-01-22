-- Apel de proceduri stocate sistem si extinse

-- P1: Deschide o fereastra noua de interogare si executa instr. urmatoare

USE tempdb; --Stabilire context implicit de lucru
GO

-- P2: Cautare lista de proceduri stocate sistem 
--         din baza de date master folosind object browser.
--         Observati ca majoritatea au prefixul sp_, dar sunt si cu prefixul xp_
--         (In Object Explorer, expandati  SQL server, 
--          expandati Databases, expandati System Databases, expandati
--          master, expandati Programmability, expandati Stored 
--          Procedures, expandati System Stored Procedures)

-- P3: Executati cateva proceduri stocate sistem 

EXEC sys.sp_configure; --afiseaza/modifica configurarile globale SQL server
GO
EXEC sys.sp_helpdb; --afiseaza i-tii B.D. user din instanta respectiva
GO
EXEC sys.sp_helpsort;--afiseaza ordinea de sortare si setul de caractere pt. instanta respectiva
GO

-- P4: Anumite valori returnate de procedurile stocate sistem pot fi obtinute
--     cu functii 

SELECT SERVERPROPERTY('collation');--returneaza ordinea de sortare si setul de caractere pt. instanta respectiva
GO
SELECT SERVERPROPERTY('edition'); --returneaza editia SQL server instalata
GO

-- P5: Cautare lista de proceduri stocate extinse
--         din baza de date master folosind object browser.
--         De notat ca exista o mixtura de prefixe xp_ si sp_
--         (In Object Explorer, expandati  SQL server, 
--          expandati Databases, expandati System Databases, expandati
--          master, expand Programmability, expandati Extended Stored Procedures, 
--          expandati System Extended Stored Procedures)

-- P6: Interogare proceduri stocate extinse

EXEC sys.xp_fixeddrives; --afiseaza partitiile sistem si sp. liber existent
GO
EXEC sys.xp_dirtree 'f:\public';--afis. structura de dir. si fisiere din calea respectiva
GO
