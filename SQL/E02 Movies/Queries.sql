/* 1- Il nome di tutte le sale di Pisa */
SELECT [Name]
FROM Theatres
WHERE City = 'Pisa';

/* 2- Il titolo dei film di F. Fellini prodotti dopo il 1960 */
SELECT Title
FROM Movies
WHERE Director = 'Federico Fellini'
AND ProductionDate >= '1/1/1960';

/* 3- Il titolo e la durata dei film di fantascienza giapponesi o francesi prodotti dopo il 1990 */
SELECT Title
FROM Movies
WHERE (Country = 'France' OR (Country = 'Japan' AND Genre = 'Sci-Fi'))
AND ProductionDate > '1/1/1990';

/* 4- Il titolo dei film di fantascienza giapponesi prodotti dopo il 1990 oppure francesi */
SELECT Title
FROM Movies
WHERE ((Country = 'Japan' AND Genre = 'Sci-Fi' AND ProductionDate > '1/1/1990') OR Country = 'France');

/* 5- I titolo dei film dello stesso regista di “Casablanca” */
SELECT Title
FROM Movies
WHERE Director = (SELECT Director FROM Movies WHERE Title = 'Casablanca');

/* 6- Il titolo ed il genere dei film proiettati il giorno di Natale 2004 */
SELECT Title, Genre
FROM Movies, Projections
WHERE Movies.Id = Projections.IdMovie
AND Projections.[Date] = '2004/12/25';

/* 7- Il titolo ed il genere dei film proiettati a Napoli il giorno di Natale 2004 */
SELECT Movies.Title, Movies.Genre
FROM Movies, Projections, Theatres
WHERE Movies.Id = Projections.IdMovie
AND Projections.IdTheatre = Theatres.Id
AND Theatres.City = 'Naples'
AND Projections.[Date] = '2004/12/25';

/* 8- I nomi delle sale di Napoli in cui il giorno di Natale 2004 è stato proiettato un film con R.Williams */
SELECT Theatres.[Name]
FROM Theatres, Projections, Movies, Plays, Actors
WHERE Theatres.Id = Projections.IdTheatre
AND Projections.IdMovie = Movies.Id
AND Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
AND Theatres.City = 'Naples'
AND Projections.[Date] = '2004/12/25'
AND Actors.[Name] = 'Robin Williams' 

/* 9- Il titolo dei film in cui recita M. Mastroianni oppure S.Loren */
SELECT Movies.Title
FROM Movies, Plays, Actors
WHERE Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
AND (Actors.[Name] = 'Marcello Mastroianni' 
	 OR Actors.[Name] = 'Sophia Loren');

/* 10- Il titolo dei film in cui recitano M. Mastroianni e S.Loren */
SELECT Movies.Title
FROM Movies, Plays, Actors
WHERE Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
AND Movies.Id IN (SELECT Movies.Id 
				  FROM Movies, Plays, Actors 
				  WHERE Movies.Id = Plays.IdMovie 
				  AND Plays.IdActor = Actors.Id 
				  AND Actors.[Name] = 'Marcello Mastroianni')
AND Actors.[Name] = 'Sophia Loren';

/* 11- Per ogni film in cui recita un attore francese, il titolo del film e il nome dell’attore */
SELECT Movies.Title, Actors.[Name]
FROM Movies, Plays, Actors
WHERE Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
AND Actors.Country = 'France';

/* 12- Per ogni film che è stato proiettato a Pisa nel gennaio 2005, il titolo del film e il nome della sala. */
SELECT Movies.Title, Theatres.[Name]
FROM Movies, Projections, Theatres
WHERE Movies.Id = Projections.IdMovie
AND Projections.IdTheatre = Theatres.Id
AND Theatres.City = 'Los Angeles'
AND Projections.[Date] BETWEEN '2005/01/01' AND '2005/01/31';

/* 13- Il numero di sale di Pisa con più di 60 posti */
SELECT COUNT(*)
FROM Theatres
WHERE SeatNumber > 60;

/* 14- Il numero totale di posti nelle sale di Pisa */
SELECT SUM(SeatNumber)
FROM Theatres;

/* 15- Per ogni città, il numero di sale */
SELECT City, COUNT(*)
FROM Theatres 
GROUP BY City;

/* 16- Per ogni città, il numero di sale con più di 60 posti */
SELECT City, COUNT(*)
FROM Theatres 
WHERE SeatNumber > 60
GROUP BY City; 

/* 17- Per ogni regista, il numero di film diretti dopo il 1990 */
SELECT Director, COUNT(*)
FROM Movies
WHERE ProductionDate >= '1990/01/01'
GROUP BY Director;

/* 18- Per ogni regista, l’incasso totale di tutte le proiezioni dei suoi film */
SELECT Movies.Director, SUM(Projections.Profit)
FROM Movies, Projections
WHERE Movies.Id = Projections.Id
GROUP BY Movies.Director;

/* 19- Per ogni film di S.Spielberg, il titolo del film, il numero totale di proiezioni a Pisa e l’incasso totale */
SELECT Movies.Title, COUNT(*) AS Projections, SUM(Projections.Profit) AS Profit
FROM Movies, Projections, Theatres
WHERE Movies.Id = Projections.IdMovie
AND Projections.IdTheatre = Theatres.Id
AND Movies.Director = 'Steven Spielberg'
AND Theatres.City = 'Pisa'
GROUP BY Movies.Id, Movies.Title;

/* 20- Per ogni regista e per ogni attore, il numero di film del regista con l’attore */
SELECT Movies.Director, Actors.Name AS Actor, COUNT(*) AS Movie_count
FROM Movies, Plays, Actors
WHERE Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
GROUP BY Movies.Director, Actors.Id, Actors.Name;

/* 21- Il regista ed il titolo dei film in cui recitano meno di 6 attori */
SELECT Movies.Director, Movies.Title
FROM Movies, Plays
WHERE Movies.Id = Plays.IdMovie
GROUP BY Movies.Id, Movies.Director, Movies.Title
HAVING COUNT(*) < 6;

/* 21 ********* */
SELECT Movies.Director, Movies.Title
FROM Movies
WHERE 6 > (SELECT COUNT(*) FROM Plays WHERE Plays.IdMovie = Movies.Id);

/* 22- Per ogni film prodotto dopo il 2000, il codice, il titolo e l’incasso totale di tutte le sue proiezioni */
SELECT Movies.Id, Movies.Title, SUM(Projections.Profit) AS Profit
FROM Movies, Projections
WHERE Movies.Id = Projections.IdMovie
AND Movies.ProductionDate >= '2000/1/1'
GROUP BY Movies.Id, Movies.Title;

/* 23 - Il numero di attori dei film in cui appaiono solo attori nati prima del 1970 */
SELECT Movies.Title, COUNT(Plays.IdActor) AS Actors_count
FROM Movies, Plays, Actors
WHERE Movies.Id = Plays.IdMovie
AND Plays.IdActor = Actors.Id
GROUP BY Movies.Id, Movies.Title
HAVING MAX(Actors.BirthDate) < '1970/1/1';

/* 24- Per ogni film di fantascienza, il titolo e l’incasso totale di tutte le sue proiezioni */
SELECT Movies.Title, SUM(Projections.Profit) AS Profit
FROM Movies, Projections
WHERE Movies.Id = Projections.IdMovie
AND Movies.Genre = 'Sci-Fi'
GROUP BY Movies.Id, Movies.Title;

/* 25- Per ogni film di fantascienza il titolo e l’incasso totale di tutte le sue proiezioni successive al 1/1/01 */
SELECT Movies.Title, SUM(Projections.Profit)
FROM Movies, Projections
WHERE Movies.Id = Projections.IdMovie
AND Projections.[Date] > '2001/1/1'
GROUP BY Movies.Id, Movies.Title;

/* 26- Per ogni film di fantascienza che non è mai stato proiettato prima del 1/1/01 il titolo e l’incasso totale di tutte le sue proiezioni */
SELECT Movies.Title, SUM(Projections.Profit) AS Profit
FROM Movies, Projections
WHERE Movies.Id = Projections.IdMovie
GROUP BY Movies.Id, Movies.Title
HAVING MIN(Projections.[Date]) >= '2001/1/1';

/* 27- Per ogni sala di Pisa, che nel mese di gennaio 2005 ha incassato più di 20000 €, il nome della sala e l’incasso totale (sempre del mese di gennaio 2005) */
SELECT Theatres.[Name], SUM(Projections.Profit) AS Profit
FROM Theatres, Projections
WHERE Theatres.Id = Projections.IdTheatre
AND Projections.[Date] BETWEEN '2005/1/1' AND '2005/1/31'
GROUP BY Theatres.Id, Theatres.[Name]
HAVING SUM(Projections.Profit) > 20000;

/* 28- I titoli dei film che non sono mai stati proiettati a Pisa */
SELECT *
FROM Movies
WHERE NOT EXISTS (SELECT *
				  FROM Projections, Theatres
				  WHERE Projections.IdTheatre = Theatres.Id
				  AND Movies.Id = Projections.IdMovie
				  AND Theatres.City = 'Pisa');

/* 28 ********* */
SELECT *
FROM Movies
WHERE 'Pisa' NOT IN (SELECT Theatres.City
					 FROM Projections, Theatres
					 WHERE Projections.IdTheatre = Theatres.Id
					 AND Projections.IdMovie = Movies.Id);

/* 29- I titoli dei film che sono stati proiettati solo a Pisa */
SELECT *
FROM Movies
WHERE 'Pisa' = ALL (SELECT Theatres.City
					 FROM Projections, Theatres
					 WHERE Projections.IdTheatre = Theatres.Id
					 AND Projections.IdMovie = Movies.Id);

/* 32- Il nome degli attori italiani che non hanno mai recitato in film di Fellini */
SELECT *
FROM Actors AS A1
WHERE A1.Country = 'Italy'
AND A1.Id NOT IN (SELECT A2.Id
				  FROM Actors AS A2, Plays, Movies
				  WHERE A2.Id = Plays.IdActor
				  AND Plays.IdMovie = Movies.Id
				  AND Movies.Director = 'Federico Fellini'
				  AND A1.Id = A2.Id);

/* 33- Il titolo dei film di Fellini in cui non recitano attori italiani */
SELECT *
FROM Movies
WHERE Movies.Director = 'Federico Fellini'
AND NOT EXISTS(SELECT *
				 FROM Plays, Actors
				 WHERE Plays.IdActor = Actors.Id
				 AND Actors.Country = 'Italy'
				 AND Movies.Id = Plays.IdMovie);

/* 34- Il titolo dei film senza attori */
SELECT Movies.Title
FROM Movies LEFT JOIN Plays ON Movies.Id = Plays.IdMovie
GROUP BY Movies.Id, Movies.Title
HAVING Plays.IdMovie IS NULL;

/* 35- Gli attori che prima del 1960 hanno recitato solo nei film di Fellini */
SELECT *
FROM Actors
WHERE NOT EXISTS (SELECT *
				  FROM Movies, Plays
				  WHERE Movies.Id = Plays.IdMovie
				  AND Movies.ProductionDate <= '1960/1/1'
				  AND Movies.Director <> 'Federico Fellini'
				  AND Actors.Id = Plays.IdMovie);

/* 36- Gli attori che hanno recitato in film di Fellini solo prima del 1960 */
SELECT *
FROM Actors
WHERE NOT EXISTS (SELECT *
				  FROM Movies, Plays
				  WHERE Movies.Id = Plays.IdMovie
				  AND Movies.ProductionDate > '1960/1/1'
				  AND Movies.Director = 'Federico Fellini'
				  AND Actors.Id = Plays.IdMovie);