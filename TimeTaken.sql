SELECT cast(ti.entrydate AS date) AS datum,
       ti.timetaken AS 'bestede tijd',
       ag.naam AS behandelaarsgroep,
       ab.ref_aanhefinformeel AS behandelaar,
       c.number+' - '+c.briefdescription AS nummer,
       c.briefdescription AS 'korte omschrijving'
FROM time_registration_change ti
LEFT JOIN CHANGE c ON c.unid = ti.cardid
LEFT JOIN actiedoor ag ON ag.unid = ti.operatorgroupid
LEFT JOIN actiedoor ab ON ab.unid = ti.operatorid
WHERE ag.naam IN ('Joost-IT')
  AND ti.entrydate &gt;

(DATEADD(MONTH,-1, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND ti.entrydate &lt;

(DATEADD(MONTH,0, DATEADD(MONTH,DATEDIFF(MONTH,0,SYSDATETIME()),0)))
AND c.typeid =
  (SELECT unid
   FROM wbaanvraagtype
   WHERE naam = 'Niet Standaard Change')
