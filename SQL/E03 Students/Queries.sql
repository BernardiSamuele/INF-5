/* 1. Tutti i dati degli alunni di FOSSANO, BRA e MONDOVI */
SELECT *
FROM Students
WHERE City IN ('FOSSANO', 'BRA', 'MONDOVI');

/* 2. Cognome e nome degli alunni alti tra 180 e 190 in ordine decrescente di altezza e crescente cognome, nome */
SELECT LastName, FirstName
FROM Students
WHERE Height BETWEEN 180 AND 190;

/* 3. Cognome e nome degli alunni nati nel mese di dicembre */
SELECT LastName, FirstName
FROM Students
WHERE MONTH(BirthDate) = 12;

/* 4. Cognome e nome degli alunni che non hanno l’ecdl */
SELECT LastName, FirstName
FROM Students
WHERE HasEcdl = 0;

/* 5. Tutti i dati degli alunni senza data dinascita */
SELECT *
FROM Students
WHERE BirthDate IS NULL;

/* 6. Visualizzare gli alunni che hanno il cognome che inizia per Mo */
SELECT *
FROM Students
WHERE LastName LIKE('Mo%');

/* 7. Per ogni mese visualizzare quanti sono gli alunni */
SELECT Month(BirthDate), COUNT(*)
FROM Students
WHERE BirthDate IS NOT NULL
GROUP BY MONTH(BirthDate);

/* 8. Per ogni altezza visualizzare quanti sono gli alunni escludendo le altezze con un solo alunnno */
SELECT Height, COUNT(*)
FROM Students
GROUP BY Height
HAVING COUNT(*) > 1;

/* 9. Visualizzare Id, cognome, nome e ‘maggiorenne’ se ha già compiuto 18 anni, ‘quasi maggiorenne’ se nell’anno in corso compie 18 anni, ‘minorenne’ negli altri casi */
SELECT Id, LastName, FirstName, 
CASE
	WHEN CONVERT(DATETIME, DATEADD(YEAR, 18, BirthDate)) <= GETDATE() THEN 'Maggiorenne'
	WHEN YEAR(GETDATE()) - YEAR(BirthDate) = 18 THEN 'Quasi maggiorenne'
	ELSE 'Minorenne'
END AS Age
FROM Students
WHERE BirthDate IS NOT NULL;

/* 10. Visualizzare i dati dell’alunno più giovane */
SELECT TOP 1 *
FROM Students
WHERE BirthDate IS NOT NULL
ORDER BY BirthDate;