-- Restaurare B.D. dblog, ramasa in starea Recovery Pending (vezi lab. 4 - Tail_log.sql)

-- P1: Verificare stare B.D. dblog (trebuie sa fie RECOVERY_PENDING, altfel executa lab. 4 - Tail_log.sql)

SELECT name, state_desc 
FROM sys.databases
WHERE name = 'dblog';
GO

-- P2: Restaurare full database backup pt. a starta secventa de restaurare. 
 
RESTORE DATABASE dblog
  FROM DISK = 'F:\Public\dblog_full.bak'
  WITH NORECOVERY;
GO

-- P3: In acest moment B.D. dblog este restaurata la momentul full backup si nu s-a facut, inca, recovery.
--     B.D. dblog este in starea recovering.

-- P4: Restaurati backup-ul de log si faceti recovery pe B.D.

RESTORE LOG dblog
  FROM DISK = 'F:\Public\dblog.trn'
  WITH RECOVERY;
GO

-- P5: Reverificare stare B.D. dblog (este ONLINE)

SELECT name, state_desc 
FROM sys.databases
WHERE name = 'dblog';
GO

-- P6: Verificati daca s-au restaurat toate datele. 
--         (Ar trebui sa fie 5000 linii returnate din tabela dbo.LogData)

USE dblog;
GO

SELECT * FROM dbo.LogData;
GO
