/* Trovare le città da cui partono voli diretti a Roma, ordinate alfabeticamente */
SELECT DepartureCity
FROM Flights
WHERE ArrivalCity = 'Rome'
ORDER BY DepartureCity;

/* Trovare le città con un aeroporto di cui non è noto il numero di piste */
SELECT City
FROM Airports
WHERE TrackCount IS NULL;

/* Di ogni volo misto (merci e passeggeri) estrarre il codice e i dati relativi al trasporto */
SELECT Flights.*
FROM Flights, Airplanes
WHERE Flights.AirplaneType = Airplanes.AirplaneType
AND Airplanes.PassengersCount IS NOT NULL
AND Airplanes.CargoQuantity IS NOT NULL;