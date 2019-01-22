--B.D. - Atasare/Detasare B.D.

-- P1: Inchideti toate tabs exceptandu-l pe acesta

-- P2: Creati o B.D. noua numita EvalValuta

USE master;
GO

CREATE DATABASE EvalValuta_xx --xx este nr. de user student 
ON 
( NAME = EvalValuta_dat, 
  FILENAME = 'F:\Public\EvalValuta_xx.mdf',   
  SIZE = 10MB, MAXSIZE = 500MB,  
  FILEGROWTH = 20% 
)
LOG ON
( NAME = EvalValuta_log,
  FILENAME = 'F:\Public\EvalValuta_xx.ldf',  
  SIZE = 2MB, 
  MAXSIZE = UNLIMITED,  
  FILEGROWTH = 10MB 
);
GO

-- P3: Detasati B.D. EvalValuta
--     (Expandati SQL Server in Object Explorer, right-click Databases, apoi click Refresh.
--      Expandati Databases, right-click EvalValuta, click Tasks, click Detach si click OK)

-- P4: In windows explorer, mutati urmatoarele fisiere astfel:
--         F:\Public\EvalValuta_xx.mdf --> F:\Public\B_Date\EvalValuta_xx.mdf
       

-- P5: Click SQL Server si expandati Databases
--     Notati ca B.D. EvalValuta nu este prezenta.

-- P6: Atasati B.D. EvalValuta la SQL Server.
--     (Right-click Databases in Object Explorer, si click Attach. Click Add, navigatati la
--      fisierul  F:\Public\B_Date\EvalValuta_xx.mdf si click OK). 

-- P7: Notati ca log file apare ca fiind lispa.

-- P8: Localizati fisierul log. (Click elipsa langa Current File Path pentru log entry
--     si navigatei la fisierul F:\Public\EvalValuta_xx.ldf si click OK) 
--     Notati ca mesajul despre fisierul de log lipsa dispare.

-- P9: Click OK pt. a atasa B.D. si notati ca EvalValuta apare acum 
--     in lista Databases(daca nu, se da Refresh in folder Databases) in Object Explorer .


          