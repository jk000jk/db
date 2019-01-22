-- Tratare erori in procedura stocata

--P1 Se creaza eroarea user, cu nr. 50001, in B.D. master, tabela sys.sysmessages
EXEC sp_addmessage  50001,16,'Actualizarea a fost facuta de %s','us_english','true','replace'

--P2 Se vizualizeaza mesajul de eroare creat la P1
SELECT * FROM sys.sysmessages
WHERE error = 50001

--P3 Se creaza procedura stocata urmatoare , care va folosi mesajul de eroare de la P1
-- in B.D. Northwind (sau alta existenta)
USE northwind
go

CREATE PROCEDURE [dbo].[act_angajat_xx] --xx este nr. dvs. de user autentificat la server
@id_ang int=NULL,
@telef nvarchar(24)=NULL
AS
BEGIN
	SET IMPLICIT_TRANSACTIONS OFF
	
	IF @id_ang IS NULL OR @telef IS NULL
		BEGIN
		PRINT 'Trebuie sa dati ID angajat si' +
		      ' nr. de telefon pe care-l modificati la executia procedurii!!!'
		RETURN
		END
	BEGIN  TRANSACTION
	UPDATE [dbo] .[Employees] -- B.D. din instanta dvs. sa contina tabela Employees
	     SET HomePhone = @telef WHERE EmployeeID =@id_ang   
	
	IF @@ROWCOUNT = 0
		BEGIN
		PRINT 'Nu s-a facut actualizarea!!'
		PRINT 'Angajatul cu codul '+STR(ltrim(@id_ang),4)+ ' nu exista!!'
		ROLLBACK TRANSACTION
		RETURN
		END
	ELSE
		BEGIN
		DECLARE @Nume_user nvarchar(60)
		SET @Nume_user = SUSER_SNAME ()
		SELECT 'Noul continut inregistrare: ' [Inregistrarea dupa UPDATE]
		SELECT EmployeeID  [ID angajat],LastName +' '+ 
				FirstName  [Nume si prenume],HomePhone [Telefon]
		        FROM Employees WHERE EmployeeID = @id_ang 
		RAISERROR (50001,16,1,@Nume_user)
		COMMIT TRAN
		END
END

--P4 Testare functionare procedura stocata creata la pasul P3 (apel corect)
--Inainte se va executa SELECT * FROM Employees WHERE EmployeeID = 1; Vezi care era valoarea pt. HomePhone

EXEC [dbo].[act_angajat_xx] @id_ang=1, @telef='(222)111-1111'
-- Se va reface vechea valoare a Cp. HomePhone
EXEC [dbo].[act_angajat_xx] @id_ang=1, @telef='(206)555-9857'

--P5 Testare functionare procedura stocata creata la pasul P3 (apel gresit)
EXEC [dbo].[act_angajat_xx] @id_ang=1111, @telef='(206)555-9857'
--sau
EXEC [dbo].[act_angajat_xx]  @telef='(206)555-9857'

--P6 Generare script pt. procedura stocata creata la P3
Selectare p.s.---> click dreapta pe ea ---> Script stored procedure ------> Create to ----------> Clipboard

--P7 Stergere procedura stocata creata la P3
DROP PROCEDURE [dbo].[act_angajat_xx]