SELECT i.status,
       pr.naam AS prio,
       CASE
           WHEN i.status = 3 THEN '0'
           ELSE [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi.datwijzig)
       END AS reactietijd,
       CASE
           WHEN CONVERT(char(6), cast((DATEADD(MONTH,-1, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0))) AS datetime), 112) = CONVERT(char(6), cast(datumgereed AS datetime), 112) THEN '1'
           ELSE '0'
       END AS huidigemaand,
       i.naam AS nummer,
       i.korteomschrijving AS korteomschrijving,
       cl.naam AS subcategorie,
       i.adjusteddurationresolved AS oplostijd,
       sm.naam AS soortkaart,
       datepart(yyyy,datumgereed) AS YEAR,
       CONVERT(char(2), cast(datumgereed AS datetime), 101) AS MONTH,
       CONVERT(char(6), cast(datumgereed AS datetime), 112) AS monthyear,
       CONVERT(VARCHAR(3),DATENAME(MONTH, datumgereed)) +' '+ CONVERT(VARCHAR(4),datepart(yyyy, datumgereed)) AS 'monthname',
       CASE
           WHEN pr.naam = '1. Prio 1 (Hoog)' THEN '60'
           WHEN pr.naam = '2. Prio 2 (Middel)' THEN '120'
           WHEN pr.naam = '3. Prio 3 (Laag)' THEN '240'
           WHEN pr.naam = '4. Prio 4 (geen oplostijd)' THEN '1000000'
           ELSE '1000000'
       END AS normreactietijd,
       CASE
           WHEN pr.naam = '1. Prio 1 (Hoog)' THEN '240'
           WHEN pr.naam = '2. Prio 2 (Middel)' THEN '540'
           WHEN pr.naam = '3. Prio 3 (Laag)' THEN '1090'
           WHEN pr.naam = '4. Prio 4 (geen oplostijd)' THEN '1000000'
           ELSE '1000000'
       END AS normoplostijd,
       CASE
           WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi3.datwijzig) IS NULL THEN '0'
           ELSE [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi3.datwijzig)
       END AS 'Andere Behandelaarsgroep',
       CASE WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi3.datwijzig) IS NULL THEN [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi.datwijzig) WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi.datwijzig) - [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi3.datwijzig) <

0 THEN '0' ELSE [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi.datwijzig) - [p_topdesk_iv].[dbo].[GetWorkingMin] (i.dataanmk, mi3.datwijzig) END AS 'Joost IT'
FROM incident i
LEFT JOIN actiedoor ad ON ad.unid = i.operatorgroupid
LEFT JOIN mutatie_incident mi ON i.unid = mi.parentid
AND mi.unid =
  (SELECT TOP 1 mi2.unid
   FROM mutatie_incident mi2
   WHERE mi2.parentid = i.unid
     AND mi2.mut_afhandelingstatusid_act = 1
     AND mi2.mut_afhandelingstatusid IS NOT NULL
   ORDER BY mi2.datwijzig ASC)
LEFT JOIN mutatie_incident mi3 ON i.unid = mi3.parentid
AND mi3.unid =
  (SELECT TOP 1 mi4.unid
   FROM mutatie_incident mi4
   WHERE mi4.parentid = i.unid
     AND mi4.mut_operatorgroupid_act = 1
     AND mi4.mut_operatorgroupid IS NOT NULL
   ORDER BY mi4.datwijzig ASC)
LEFT JOIN soortmelding sm ON sm.unid = i.soortmeldingid
LEFT JOIN classificatie cl ON cl.unid = i.incident_specid
LEFT JOIN impact pr ON i.impactid = pr.unid
WHERE i.gereed = 1
  AND ad.naam = 'Joost-IT'
  AND i.datumgereed >

(DATEADD(MONTH,-6, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND i.datumgereed <

(DATEADD(MONTH,0, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND i.status <

>

1
UNION ALL
SELECT c.status,
       NULL AS prio,
       [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk,mc.datwijzig) AS reactietijd,
       CASE
           WHEN CONVERT(char(6), cast((DATEADD(MONTH,-1, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0))) AS datetime), 112) = CONVERT(char(6), cast(closeddate AS datetime), 112) THEN '1'
           ELSE '0'
       END AS huidigemaand,
       c.number AS nummer,
       c.briefdescription AS korteomschrijving,
       cl.naam AS subcategorie,
       [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk,c.closeddate) AS oplostijd,
       'Standaard Change' AS soortkaart,
       datepart(yyyy,c.closeddate) AS YEAR,
       CONVERT(char(2), cast(c.closeddate AS datetime), 101) AS MONTH,
       CONVERT(char(6), cast(c.closeddate AS datetime), 112) AS monthyear,
       CONVERT(VARCHAR(3),DATENAME(MONTH, c.closeddate)) +' '+ CONVERT(VARCHAR(4),datepart(yyyy, c.closeddate)) AS 'Month Name',
       '1080' AS normreactietijd,
       '1000000' AS normoplostijd,
       CASE
           WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc3.datwijzig) IS NULL THEN '0'
           ELSE [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc3.datwijzig)
       END AS 'Andere Behandelaarsgroep',
       CASE WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc3.datwijzig) IS NULL THEN [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc.datwijzig) WHEN [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc.datwijzig) - [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc3.datwijzig) <

0 THEN '0' ELSE [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc.datwijzig) - [p_topdesk_iv].[dbo].[GetWorkingMin] (c.dataanmk, mc3.datwijzig) END AS 'Joost IT'
FROM CHANGE c
LEFT JOIN mutatie_change mc ON c.unid = mc.parentid
AND mc.unid =
  (SELECT TOP 1 mc2.unid
   FROM mutatie_change mc2
   WHERE mc2.parentid = c.unid
     AND mc2.mut_statusid_act = 1
     AND mc2.mut_statusid IS NOT NULL
   ORDER BY mc2.datwijzig ASC)
LEFT JOIN mutatie_change mc3 ON c.unid = mc3.parentid
AND mc3.unid =
  (SELECT TOP 1 mc4.unid
   FROM mutatie_change mc4
   WHERE mc4.parentid = c.unid
     AND mc4.mut_operatorid_act = 1
     AND mc4.mut_operatorid IS NOT NULL
   ORDER BY mc4.datwijzig ASC)
LEFT JOIN classificatie cl ON cl.unid = c.subcategoryid
WHERE c.status = 2
  AND c.operatorgroupid =
    (SELECT unid
     FROM actiedoor
     WHERE naam = 'Joost-IT')
  AND typeid =
    (SELECT unid
     FROM wbaanvraagtype
     WHERE naam = 'Standaard Change')
  AND c.closed = 1
  AND c.closeddate >

(DATEADD(MONTH,-6, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND c.closeddate <

(DATEADD(MONTH,0, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
