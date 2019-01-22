-- Informatii despre backups


-- P1: Deschideti Backup si Restore Events pentru B.D. Northwind
--         (Expandati SQL Server, expandati Databases, right-click B.D. Northwind 
--          , click Reports, click Standard Reports, Click Backup and Restore Events)

-- P2: Vizualizati inregistrarea backups B.D., apoi inchideti fereastra.
--         (Expandati si revedeti Successful Backup Operations. 
--          Expandati si revedeti Average Time Taken for Backup Operations. Inchideti report window)

-- P3: Interogati istoria backup cu T-SQL
--     De mentionat ca backup type D inseamna full database backup, I inseamna differential, L inseamna 
--     transaction log backup. 
--         (Ar trebui sa apara o linie pt. fiecare backup efectuat cu succes)

USE msdb;
GO

SELECT 
	bs.media_set_id,
	bs.backup_finish_date,
	bs.type,
	bs.backup_size,
	bs.compressed_backup_size,
	mf.physical_device_name
FROM dbo.backupset AS bs
INNER JOIN dbo.backupmediafamily AS mf
ON bs.media_set_id = mf.media_set_id	
WHERE database_name = 'Northwind'
ORDER BY backup_finish_date DESC;
GO


-- P4: Folositi RESTORE HEADERONLY pt. a obtine i-tii dintr-un backup device

RESTORE HEADERONLY 
FROM DISK = 'F:\Public\North.bak';
GO

-- P5: Folositi RESTORE FILELISTONLY pt. a obtine lista de fisiere care compun un backup.
--     De mentionat ca S inseamna filestream backup si ca filestream este un topic avansat, in afara cursului.

RESTORE FILELISTONLY 
FROM DISK = 'F:\Public\North.bak';
GO

-- P6: Folositi RESTORE VERIFYONLY pt. a verifica un backup.

RESTORE VERIFYONLY 
FROM DISK = 'F:\Public\North.bak';
GO
