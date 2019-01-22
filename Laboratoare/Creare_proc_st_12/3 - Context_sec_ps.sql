
-- Contextul de securitate al unei proceduri stocate

-- P1: Se acceseaza buton New Query si se executa:
USE tempdb;
GO

-- P2: SE creaza o procedura st. care interogheaza sys.login_token 
--         si sys.user_token (pastreaza contextul de securitate )

CREATE PROC dbo.DisplayExecutionContext_xx --xx este nr. user conectat la server
AS
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
GO

-- P3: Se executa proc. st. si se analizeaza rezultatul

EXEC dbo.DisplayExecutionContext_xx; --se afiseaza contul de login server si rolurile/grupurile unde este membru
GO

-- P4: Se foloseste instructiunea EXECUTE AS pentru a schimba contextul
EXECUTE AS User = 'SecureUser'; --se creaza de profesor login SecureUser autentificat SQL Server
GO

-- P5: Se incearca executia procedurii. De ce obtineti un mesaj de eroare?

EXEC dbo.DisplayExecutionContext_xx;
GO

-- P6: Se revine la contextul de securitate anterior

REVERT;
GO

-- P7: Se acorda permisiunea EXECUTE pe procedura stocata utilizatorului SecureUser 

GRANT EXECUTE ON dbo.DisplayExecutionContext_xx TO SecureUser;
GO

-- P8: Schimbare context de securitate si Reexecutie procedura stocata

EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.DisplayExecutionContext_xx; --afisare i-tii cont login si user B.D.
GO

REVERT;
GO

-- P9: Modificare procedura pt. a fi executata ca owner

ALTER PROC dbo.DisplayExecutionContext_xx 
WITH EXECUTE AS OWNER
AS
  SELECT * FROM sys.login_token;
  SELECT * FROM sys.user_token;
GO
--vezi Properties---Execute as Owner (inainte era Caller)

-- P10: Execute procedura ca SecureUser (din nou) si observati diferenta

EXECUTE AS User = 'SecureUser';
GO

EXEC dbo.DisplayExecutionContext_xx;--proprietarul e contul login sa
GO

REVERT;
GO

-- P11: Drop (stergere) procedura

DROP PROC dbo.DisplayExecutionContext_xx;
GO
