-- Folosirea inadecvata a tipurilor de date numerice poate genera erori de procesare.
-- Priviti codul urmator si spuneti de cate ori se va executa instr. PRINT:

DECLARE @Counter float;
SET @Counter = 0;
WHILE (@Counter <> 1.0) BEGIN
SET @Counter += 0.1;
PRINT @Counter;
END;

-- Veti fi surprins ca rularea este continua si trebuie stopata.
-- Dupa anularea interogarii, valorile tiparite sunt de forma:
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1
1.1
1.2
1.3
1.4
1.5
1.6
1.7
…

--Ce s-a intamplat?
-- Problema este ca valoarea 0.1 nu poate fi stocata exact intr-un tip de date float sau real.
-- Valoarea de terminare a ciclului nu va fi niciodata exacta.
-- Solutia: folositi o valoare zecimala!

DECLARE @Counter decimal(2,1);
SET @Counter = 0;
WHILE (@Counter <> 1.0) BEGIN
SET @Counter += 0.1;
PRINT @Counter;
END;
