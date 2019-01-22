-- Backup B.D. Northwind
-- Obs.: Scripturile vor fi executate de profesor sau de student (acasa),
--       pt. a nu avea prea multe fisiere de lucru pe server

-- P1: Deschideti un backup task pentru B.D. Northwind
--         (Expandati SQL Server, expandati Databases, right-click B.D. 
--          Northwind, click Tasks, click Back Up)

-- P2: Note: 
--         Numele B.D., recovery model si backup type  apar in backup dialog.
--         Un backup name implicit este creat de SQL Server.
--         Implicit backup va fi salvat in 
--         %installation dir%\Program Files\Microsoft SQL Server
--         \%SQL Version Number%.%InstanceID%\MSSQL\Backup\%Database Name%.BAK.

-- P3: Stergeti  backup device furnizat 
--         (Click Remove)

-- P4: Adaugati un backup device nou in  F:\Public\North.bak
--         (Click Add. In Backup Destination window, tastati  F:\Public\North.bak
--          si click OK) 

-- P5: Executie backup.
--         (Click buton OK pt. a executa backup. Observati cum se deruleaza backup-ul
--          si click OK cand  backup-ul se termina)

-- P6: Deschideti Windows Explorer, navigati la  F:\Public  si revedeti dimensiunea backup device.
--         (Aproximativ 4.824 MB)

-- P7: Faceti un backup in acelasi loc folosind T-SQL

BACKUP DATABASE Northwind
	TO DISK = 'F:\Public\North.bak';
GO

-- P8: Deschideti Windows Explorer, navigati la  F:\Public  si revedeti dimensiunea backup device.
--         (Approximately 9.646 MB)
--     De observat ca backup-ul a fost adaugat prin folosire optiuni implicite.

-- P9: Executati acelasi backup folosind optiunea INIT. De asemenea, notati timpul de executie.

BACKUP DATABASE Northwind
	TO DISK = 'F:\Public\North.bak'
	WITH INIT;
GO

-- P10: Deschideti Windows Explorer, navigati la  F:\Public  si revedeti dimensiunea backup device.
--         (Approximately 4.824 MB)
--      Notati ca backup-ul a fost suprascris folosind optiunea INIT.

-- P11: Incercati sa faceti un backup comprimat
--          (Notati: Backup va esua din cauza unui fisier cu format incompatibil existent)

BACKUP DATABASE Northwind
	TO DISK = 'F:\Public\North.bak'
WITH INIT, COMPRESSION;
GO

-- P12: Incercati sa faceti un backup comprimat din nou cu optiunea FORMAT. 
--          Observati timpul de executie --- va fi mai mic decat cel anterior.

BACKUP DATABASE Northwind
	TO DISK = 'F:\Public\North.bak'
WITH FORMAT, COMPRESSION;
GO

-- P13: Deschideti Windows Explorer, navigati la  F:\Public  si revedeti dimensiunea backup device.
--         (Approximately 828 KB)
--          Notati ca optiunea COMPRESSION a produs o imbunatatire substantiala
--          in timpul de executie si dimensiunea backup file size.

-- P14: Setati instanta sa foloseasca implicit backup compression

EXEC sp_configure 'backup compression default', 1;
GO
RECONFIGURE;
GO

-- P15: Interogati vederea sys.configurations pt. a vedea toate setarile de configuratie, inclusiv
--      setarea pt. 'backup compression default'. 

SELECT * FROM sys.configurations ORDER BY name;
GO