-- Search for multiple Invoices on same Order
-- cannot re-print Invoices (Återutskrift Faktura) in [orderfu] except latest 
DECLARE @ordernr nvarchar(20)
DECLARE q_HPT_tempTable01  CURSOR LOCAL STATIC READ_ONLY FOR
SELECT DISTINCT orp.ordernr -- 291 rader 2018-07-06 11:15
-- , orp.faktnr, orp.ordfsnr, orp.ordradnr, orp.artnr, ar.artbeskr
FROM orp, ar
WHERE ar.foretagkod = 0 AND ar.foretagkod = orp.foretagkod
	-- AND orp.ftgnr = 'ALCopenhagen'
	-- AND orp.ordlevplats1 = 'Alfa Laval Aalborg'
    AND FaktDat >= '2018-04-01'
    AND FaktDat < '2018-06-01'
    AND orp.ordfsnr > 1 -- antalet fakturor på samma order
    AND orp.artnr = ar.artnr
	AND orp.artnr <> '850226' -- valuta-råvaru-justering
	AND orp.artnr <> '850221' -- valuta-råvaru-justering
	-- AND (orp.faktnr = 60977 OR orp.faktnr = 61080)

OPEN q_HPT_tempTable01
FETCH NEXT FROM q_HPT_tempTable01 INTO @ordernr
WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT ordernr 'Ordernummer', faktnr 'Fakturanummer', CONVERT(date,FaktDat,112) 'Faktureringsdatum', ftgnr 'Företag'
    FROM fh
    WHERE ordernr = @ordernr
	ORDER BY FaktDat

    FETCH NEXT FROM q_HPT_tempTable01 INTO @ordernr
END
CLOSE q_HPT_tempTable01
DEALLOCATE q_HPT_tempTable01