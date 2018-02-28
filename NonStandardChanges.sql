SELECT c.number AS nummer,
       c.briefdescription AS korteomschrijving,
       cl.naam AS subcategorie,
       'Niet Standaard Change' AS soortkaart,
       v.briefdescription AS versie,
       aanmeldernaam,
       c.closeddate AS 'datum afronding',
       currentplantimetaken/60 AS currentplantimetaken,
       timetaken/60 AS timetaken,
       datepart(yyyy,c.closeddate) AS YEAR,
       CONVERT(char(2), cast(c.closeddate AS datetime), 101) AS MONTH,
       CONVERT(char(6), cast(c.closeddate AS datetime), 112) AS monthyear,
       CONVERT(VARCHAR(3),DATENAME(MONTH, c.closeddate)) AS 'Month Name'
FROM CHANGE c
LEFT JOIN mutatie_change mc ON c.unid = mc.parentid
AND mc.unid =
  (SELECT TOP 1 mc2.unid
   FROM mutatie_change mc2
   WHERE mc2.parentid = c.unid
     AND mc2.mut_statusid_act = 1
     AND mc2.mut_statusid IS NOT NULL
   ORDER BY mc2.datwijzig ASC)
LEFT JOIN classificatie cl ON cl.unid = c.subcategoryid
LEFT JOIN changeversion v ON v.unid = c.versionid
WHERE c.status = 2
  AND c.operatorgroupid =
    (SELECT unid
     FROM actiedoor
     WHERE naam = 'Joost-IT')
  AND c.closed = 1
  AND c.closeddate &gt;

(DATEADD(MONTH,-1, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND c.closeddate &lt;

(DATEADD(MONTH,0, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND c.typeid =
  (SELECT unid
   FROM wbaanvraagtype
   WHERE naam = 'Niet Standaard Change')
