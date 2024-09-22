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
SELECT Movies.Title, SUM(Projections.Profit), (SELECT COUNT(*) FROM Movies, Projections, Theatres WHERE Movies.Id = Projections.IdMovie AND Projections.IdTheatre = Theatres.Id AND Movies.Director = 'Steven Spielberg' AND Theatres.City = 'Pisa')
FROM Movies, Projections, Theatres
WHERE Movies.Id = Projections.IdMovie
AND Projections.IdTheatre = Theatres.Id
AND Movies.Director = 'Steven Spielberg'
GROUP BY Movies.Title;

