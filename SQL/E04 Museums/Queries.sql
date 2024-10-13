/* 1- Il codice ed il titolo delle opere di Tiziano conservate alla “National Gallery”. */
SELECT Works.Id, Works.Title
FROM Works, Museums
WHERE Works.IdMuseum = Museums.Id
AND Museums.[Name] = 'National Gallery';

/* 2- Il nome dell’artista ed il titolo delle opere conservate alla “Galleria degli Uffizi” o alla “National Gallery”. */
SELECT *
FROM Museums, Works, Artists
WHERE Works.IdMuseum = Museums.Id
AND Works.IdArtist = Artists.Id
AND Museums.[Name] = 'Galleria degli Uffizi'
OR Museums.[Name] = 'National Gallery';

/* 3- Il nome dell’artista ed il titolo delle opere conservate nei musei di Firenze */
SELECT Artists.[Name], Works.Title
FROM Artists, Works, Museums
WHERE Artists.Id = Works.IdArtist
AND Works.IdMuseum = Museums.Id
AND Museums.City = 'Florence';

/* 4- Le città in cui son conservate opere di Carabbaggio */
SELECT DISTINCT Museums.City
FROM Museums, Works, Artists
WHERE Museums.Id = Works.IdMuseum
AND Works.IdArtist = Artists.Id
AND Artists.[Name] = 'Carabbaggio';

/* 5- Il codice ed il titolo delle opere di Tiziano conservate nei musei di Londra */
SELECT Works.Id, Works.Title
FROM Artists, Works, Museums
WHERE Artists.Id = Works.IdArtist
AND Works.IdMuseum = Museums.Id
AND Artists.[Name] = 'Tiziano'
AND Museums.City = 'London';

/* 6- Il nome dell’artista ed il titolo delle opere di artisti spagnoli conservate nei musei di Firenze */
SELECT Artists.[Name], Works.Title
FROM Artists, Works, Museums
WHERE Artists.Id = Works.IdArtist
AND Works.IdMuseum = Museums.Id
AND Artists.Nation = 'Spain'
AND Museums.City = 'Florence';

/* 7- Il codice ed il titolo delle opere di artisti italiani conservate nei musei di Londra, in cui è rappresentata la Madonna */
SELECT Works.Id, Works.Title
FROM Characters, Artists, Works, Museums
WHERE Characters.IdWork = Works.Id
AND Artists.Id = Works.IdArtist
AND Works.IdMuseum = Museums.Id
AND Artists.Nation = 'Italy'
AND Museums.City = 'London'
AND Characters.[Name] = 'Madonna'

/* 8- Per ciascun museo di Londra, il numero di opere di artisti italiani ivi conservate */
SELECT Museums.a[Name], COUNT(*) AS 'Works count'
FROM Museums, Works, Artists
WHERE Museums.Id = Works.IdMuseum
AND Works.IdArtist = Artists.Id
AND Museums.City = 'London'
AND Artists.Nation = 'Italy'
GROUP BY Museums.Id, Museums.[Name];

/* 9- Il nome dei musei di Londra che non conservano opere di Tiziano */
SELECT Museums.[Name]
FROM Museums, Works, Artists
WHERE NOT EXISTS (SELECT *
				  FROM Artists, Works
				  WHERE Artists.Id = Works.IdArtist
				  AND Works.IdMuseum = Museums.Id
				  AND Artists.[Name] = 'Tiziano');

/* 10- Il nome dei musei di Londra che conservano solo opere di Tiziano */
SELECT Museums.[Name]
FROM Museums, Works, Artists
WHERE NOT EXISTS (SELECT *
				  FROM Artists, Works
				  WHERE Artists.Id = Works.IdArtist
				  AND Works.IdMuseum = Museums.Id
				  AND Artists.[Name] != 'Tiziano');

/* 11- Per ciascun artista, il nome dell’artista ed il numero di sue opere conservate alla “Galleria degli Uffizi” */
SELECT Artists.[Name], COUNT(*) AS 'Works count'
FROM Artists, Works, Museums
WHERE Artists.Id = Works.IdArtist
AND Museums.Id = Works.IdMuseum
AND Museums.[Name] = 'Galleria degli Uffizi'
GROUP BY Artists.Id, Artists.[Name];

/* 12- I musei che conservano almeno 20 opere di artisti italiani */
SELECT Museums.[Name]
FROM Museums, Works, Artists
WHERE Museums.Id = Works.IdMuseum
AND Artists.Id = Works.IdArtist
AND Artists.Nation = 'Italy'
GROUP BY Museums.Id, Museums.[Name]
HAVING COUNT(*) >= 20;

/* 13- Per le opere di artisti italiani che non hanno personaggi, il titolo dell’opera ed il nome dell’artista */
SELECT Works.Id, Artists.[Name]
FROM Artists, Works, Characters
WHERE Artists.Id = Works.IdArtist
AND Works.Id = Characters.IdWork
AND Artists.Nation = 'Italy'
GROUP BY Works.Id, Works.Title, Artists.Id, Artists.[Name]
HAVING COUNT(Characters.Id) = 0;

/* 14- Il nome dei musei di Londra che non conservano opere di artisti italiani, eccettuato Tiziano */
SELECT Museums.[Name]
FROM Museums, Works, Artists
WHERE Museums.Id = Works.IdMuseum
AND Artists.Id = Works.IdArtist
AND Museums.City = 'London'
AND Artists.[Name] != 'Tiziano'
GROUP BY Museums.Id, Museums.[Name]
HAVING COUNT(Artists.Id) = 0;

/* 15- Per ogni museo, il numero di opere divise per la nazionalità dell’artista */
SELECT Museums.[Name], COUNT(DISTINCT Artists.Nation) AS 'Works count'
FROM Museums, Works, Artists
WHERE Museums.Id = Works.IdMuseum
AND Artists.Id = Works.IdArtist
GROUP BY Museums.Id, Museums.[Name];

