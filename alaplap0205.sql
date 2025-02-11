//1.feladat
SELECT COUNT(*) AS darabszam
FROM tipus
JOIN chip ON tipus.c_id = chip.id
JOIN ram ON tipus.r_id = ram.id
WHERE ram.tip = 'DDR3'
AND chip.Chip LIKE 'Intel%'
AND tipus.raktar > 0;

//2.feladat
SELECT SUM(br_ar) AS ossz_ertek
FROM tipus
JOIN chip ON tipus.c_id = chip.id
WHERE chip.Chip LIKE 'Intel%';

//3.feladat

SELECT g.nev AS gy, t.nev AS tip,t.br_ar AS ar, ABS((SELECT AVG(br_ar) FROM tipus WHERE raktar>0) - t.br_ar) AS elteres
FROM tipus t JOIN gyarto g ON t.gy_id = g.id
WHERE t.br_ar = (SELECT MIN(br_ar) FROM tipus WHERE raktar > 0) AND raktar >0
AND raktar>0

SELECT g.nev AS gy, t.nev AS tip,t.br_ar AS ar, ABS((SELECT AVG(br_ar) FROM tipus WHERE raktar>0) - t.br_ar) AS elteres
FROM tipus t JOIN gyarto g ON t.gy_id = g.id
WHERE t.br_ar = (SELECT MAX(br_ar) FROM tipus WHERE raktar > 0) AND raktar >0
AND raktar>0

--NAGYON FONTOS, hogy mindkét lekérdezésben ugyanazok az aliaszok

SELECT u.gy, u.tip, u.ar, u.elteres
FROM (
    (SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar,
        ABS((SELECT AVG(br_ar) FROM tipus WHERE raktar > 0) - t.br_ar) AS elteres
     FROM tipus t
     JOIN gyarto g ON t.gy_id = g.id
     WHERE t.br_ar = (SELECT MIN(br_ar) FROM tipus WHERE raktar > 0 AND raktar > 0)
    )
    UNION
    (SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar,
        ABS((SELECT AVG(br_ar) FROM tipus WHERE raktar > 0) - t.br_ar) AS elteres
     FROM tipus t
     JOIN gyarto g ON t.gy_id = g.id
     WHERE t.br_ar = (SELECT MAX(br_ar) FROM tipus WHERE raktar > 0 AND raktar > 0)
    )


) AS u
ORDER BY 4 DESC
LIMIT 1;



//4.feladat
INSERT INTO audio VALUES (NULL, 'SoundBlaster 1024');
INSERT INTO chip VALUES (NULL, 'Intel X99');
INSERT INTO foglalat VALUES (NULL, 'LGA 2111');
INSERT INTO gyarto VALUES (NULL, 'Soltek');
INSERT INTO lan VALUES (NULL, 'Realtek 1211AT');
INSERT INTO meret VALUES (NULL, 'Extended ATX');
INSERT INTO tipus (id, gy_id, a_id, c_id, f_id, l_id, m_id, r_id, nev, dimm, mhz, gb, s3, s2, m2, u2, raid, pci416, pci316, pci34, pci31, pci216, pci21, pci, u_c2, u_c1, u_31_2, u_31_1, u_3, u_2, d_p, hdmi, dvi, dsub, ps2)
VALUES (NULL, (SELECT id FROM gyarto WHERE nev = 'Soltek' LIMIT 1), 
(SELECT id FROM audio WHERE nev ='SoundBlaster 1024' LIMIT 1),
(SELECT id FROM chip WHERE Chip = 'Intel X99' LIMIT 1),
(SELECT id FROM foglalat WHERE nev = 'LGA 2111' LIMIT 1),
(SELECT id FROM lan WHERE nev = 'Realtek 1211AT' LIMIT 1),
(SELECT id FROM meret WHERE nev = 'Extended ATX' LIMIT 1),
(SELECT id FROM ram WHERE tip = 'DDR3' AND arch = 'Dual Chanel'), 'ST21HD', 4, 1800, 64, 2, 2, 0, 0, 1, 0, 1, 1, 2, 0, 0, 1, 0, 0, 0, 6, 0, 2, 0, 1, 1, 1, 2);


//5.feladat
SELECT *
FROM tipus t
JOIN audio a ON t.a_id = a.id
JOIN chip c ON t.c_id = c.id
JOIN foglalat f ON t.f_id = f.id
JOIN gyarto g ON t.gy_id = g.id
JOIN lan l ON t.l_id = l.id
JOIN meret m ON t.m_id = m.id
JOIN ram r ON t.r_id = r.id
WHERE r.tip = 'DDR4' AND t.mhz <= 3200 AND f.nev = 'LGA 1151';

//5. a
SELECT 
    t.id, 
    g.nev AS gyarto, 
    t.nev AS tipus, 
    f.nev AS foglalat, 
    c.Chip AS chipset, 
    r.tip AS ram_tipus, 
    t.mhz, 
    t.gb, 
    t.br_ar AS brutto_ar
FROM 
    tipus t
JOIN 
    gyarto g ON t.gy_id = g.id
JOIN 
    foglalat f ON t.f_id = f.id
JOIN 
    chip c ON t.c_id = c.id
JOIN 
    ram r ON t.r_id = r.id
WHERE 
    f.nev = 'LGA 1151 V2' 
    AND t.mhz >= 2666
    AND r.tip = 'DDR4';


SELECT 
    AVG(t.br_ar) AS atlag_ar
FROM 
    tipus t
JOIN 
    foglalat f ON t.f_id = f.id
WHERE 
    f.nev = 'LGA 1151 V2' 
    AND t.mhz >= 2666;


SELECT 
    t.id, 
    g.nev AS gyarto, 
    t.nev AS tipus, 
    t.br_ar AS brutto_ar
FROM 
    tipus t
JOIN 
    gyarto g ON t.gy_id = g.id
JOIN 
    foglalat f ON t.f_id = f.id
WHERE 
    f.nev = 'LGA 1151 V2' 
    AND t.mhz >= 2666
ORDER BY 
    ABS(t.br_ar - (SELECT AVG(t2.br_ar)
                   FROM tipus t2
                   JOIN foglalat f2 ON t2.f_id = f2.id
                   WHERE f2.nev = 'LGA 1151 V2' 
                   AND t2.mhz >= 2666)) ASC
LIMIT 1;

//6.feladat
SHOW TABLES

//7.feladat 
SELECT B.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLES AS A, INFORMATION_SCHEMA.COLUMNS AS B
WHERE A.TABLE_SCHEMA = 'alaplap' AND A.TABLE_NAME = 'tipus' AND B.TABLE_NAME = A.TABLE_NAME
AND B.COLUMN_NAME LIKE '%1%';

//8. feladat
SELECT g.nev AS gyarto_neve, COUNT(*) AS alaplapok_szama
FROM tipus t
JOIN gyarto g ON t.gy_id = g.id
JOIN foglalat f ON t.f_id = f.id
WHERE f.nev = 'LGA 1151'
GROUP BY g.nev
ORDER BY alaplapok_szama DESC
LIMIT 1;

//9. feladat
SELECT 
    t.nev AS alaplap_nev,
    t.br_ar AS eredeti_ar,
    t.br_ar * 0.9 AS kedvezmenyes_ar
FROM 
    tipus t
WHERE 
    t.raktar > 5;
//9. feladat a)
SELECT 
    t.nev AS alaplap_nev,
    t.br_ar - (t.br_ar * 0.9) AS veszteseg
FROM 
    tipus t
WHERE 
    t.raktar > 5;


//10. feladat
SELECT 
    gyarto.nev AS gyarto,
    tipus.nev AS tipus,
    tipus.br_ar AS ar
FROM 
    tipus
JOIN 
    gyarto ON tipus.gy_id = gyarto.id
ORDER BY 
    tipus.br_ar DESC
LIMIT 3;


//11 feladat
SELECT g.nev, t.nev, t.br_ar
FROM tipus t JOIN gyarto g ON t.gy_id = g.id
WHERE t.br_ar = (SELECT MAX(br_ar) FROM tipus) OR t.br_ar = (SELECT MIN(br_ar) FROM tipus)
ORDER BY 3 DESC

//11 feladat
SELECT g1.nev, t1.nev, t1.br_ar,g2.nev,t2.br_ar
FROM tipus t1 JOIN gyarto g1 ON t1.gy_id = g1.id,
	tipus t2 JOIN gyarto g2 ON t2.gy_id = g2.id
WHERE t1.br_ar = (SELECT MAX(br_ar) FROM tipus) AND t2.br_ar =(SELECT MIN(br_ar) FROM tipus)

//12.feladat
SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar
FROM tipus t JOIN gyarto g ON t.gy_id = g.id
WHERE t.br_ar is NOT NULL
ORDER BY 3
-- adjunk hozzá egy számitott mezőt egy változó segítségével. Ezt rendeljük hozzá minden rekordhoz.
--Észre kell venni, hogy az elsődleges kulcsok sajnem nem egyesével követik egymást, az AUTOINCREMENT tulajdonság miatt. Ezt ki kell küszöbölni, és újra kell sorszámozni a lekérdezés eredmnényét.
SET @sor = 0;
SELECT (@sor := @sor + 1) AS s, h.gy, h.tip, h.ar
FROM (SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar 
FROM tipus t JOIN gyarto g ON t.gy_id = g.id 
WHERE t.br_ar IS NOT NULL 
ORDER BY t.br_ar ASC) AS h;

SET @sor = 0;
SET @sor2= 0;
SELECT T2.gyrt AS gyártó, T2.tps AS típus, (T2.r -T1.r) AS különbség
FROM (SELECT (@sor := @sor + 1) AS s, h.gy AS gyrt, h.tip AS tps, h.ar AS raid
		FROM (SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar
			FROM tipus t JOIN gyarto g ON t.gy_id = g.id
			WHERE t.br_ar IS NOT NULL
			ORDER BY 3) AS h) AS T1 JOIN
	 (SELECT (@sor2 := @sor2 + 1) AS s, h.gy AS gyrt, h.tip AS tps, h.ar AS r
		FROM (SELECT g.nev AS gy, t.nev AS tip, t.br_ar AS ar
			FROM tipus t JOIN gyarto g ON t.gy_id = g.id
			WHERE t.br_ar IS NOT NULL
			ORDER BY 3) AS h) AS T2 ON T1.s + 1 = T2.s
