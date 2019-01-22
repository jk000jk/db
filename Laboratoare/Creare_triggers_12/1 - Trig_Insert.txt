-- Demonstratie - Trigger AFTER INSERT 

-- P1: Deschideti o interogare noua si 
--         folositi B.D. tempdb

USE tempdb;
GO

-- P2 Creati o tabela numita temp_xx
Create table temp_xx(data_comenzii date,nr_cda int,suma real, id_client int)--xx este nr. user autentificat
go

-- P3: Creati un trigger INSERT 

CREATE TRIGGER TR_temp_Insert_xx
ON temp_xx
AFTER INSERT AS 
BEGIN
  IF EXISTS( SELECT 1 
             FROM inserted AS i
             WHERE i.Suma > 10000
             AND i.nr_cda IS NULL
           ) 
    BEGIN
     PRINT 'Comenzile mai mari de 10000 lei trebuie sa aiba Numar comanda!';
     ROLLBACK;           
    END;
END;
GO

-- P4: Testare trigger 
--         (se incearca inserarea unei valori pentru suma  > 10000,
--         dar cu nr. comanda introdus) (va insera)

INSERT INTO temp_xx 
  (data_comenzii ,nr_cda ,suma , id_client )
  VALUES (SYSDATETIME(),1,10502,100);
GO

SELECT * FROM temp_xx
GO

-- P5: Se incearca inserarea unei valori pentru suma  < 10000 
--         si fara nr. comanda introdus  (va insera)

INSERT INTO temp_xx 
  (data_comenzii ,nr_cda ,suma , id_client )
  VALUES (SYSDATETIME(),NULL,8000,100);
GO

SELECT * FROM temp_xx
GO

-- P6: SE incearca inserarea fara un nr. de comanda, 
--       dar cu o suma mai mare de 10000 (nu va insera)

INSERT INTO temp_xx 
  (data_comenzii ,nr_cda ,suma , id_client )
  VALUES (SYSDATETIME(),NULL,20000,100);
GO

SELECT * FROM temp_xx
GO

-- P7: Stergere trigger and remove the rows added

DROP TRIGGER TR_temp_Insert_xx;
GO



