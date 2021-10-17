/* Instalacja rozszerzenia nr 1*/
CREATE EXTENSION IF NOT EXISTS CUBE;

/* Instalacja rozszerzenia nr 2*/
CREATE EXTENSION IF NOT EXISTS earthdistance;

/* odległości wszystkich stacji od jednej poszczególnej stacji  - myślę, żę nie będzie to użyteczne */
SELECT
	name,
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(id2.lat, id2.long))::NUMERIC, 2) AS distance_from_in_m_from_San_Jose_Diridon_Station
FROM station s,
	LATERAL (
	SELECT
		id,
		lat,
		long
	FROM station s
	WHERE
		id = 2) AS id2
WHERE
	s.id <> id2.id
ORDER BY
	distance_from_in_m_from_San_Jose_Diridon_Station;

/* wszystkie możliwe kombinajce wliczając zerowe odległości A od A i powtórzenia np. A od B i B od A*/
SELECT
	DISTINCT s.id,
	s2.id,
	s.name,
	s2.name,
	s.lat AS lat1,
	s.long AS long1,
	s2.lat AS lat2,
	s2.long AS long2,
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2) AS distance
FROM station s
CROSS JOIN station s2
ORDER BY
	distance;

/* odległości - wszystkie kombinacje oprócz zerowych odległości (stacja A od stacji A) i bez powtórzeń - jak mamy A od B, nie ma już odległości B od A*/
SELECT
	DISTINCT s.id,
	s2.id,
	s.name,
	s2.name,
	s.lat AS lat1,
	s.long AS long1,
	s2.lat AS lat2,
	s2.long AS long2,
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2) AS distance
FROM station s
INNER JOIN station s2
ON
	s.id>s2.id
ORDER BY
	distance;

/* odległości - wszystkie kombinacje oprócz zerowych odległości (stacja A od stacji A) posortowane po id 
 * - to się pewnie da zrobić lepiej, można też dodać jescze do where bliżej niż jakaś odległość tak jak w następnym zapytaniu*/
SELECT
	DISTINCT s.id,
	s2.id,
	s.name,
	s2.name,
	s.lat AS lat1,
	s.long AS long1,
	s2.lat AS lat2,
	s2.long AS long2,
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2) AS distance
FROM station s
CROSS JOIN station s2
WHERE
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2)>0
ORDER BY
	s.id,
	distance ASC;

/* jak wyżej, ale zliczamy ilość pobliskich stacji, tutaj ustawione do 2500 m i grupujemy po id*/
SELECT
	DISTINCT s.id AS station_id,
	count(s2.id) AS no_of_nearby_stations
FROM station s
CROSS JOIN station s2
WHERE
	round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2)>0
	AND round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2)<2500
GROUP BY
	s.id
ORDER BY
	no_of_nearby_stations ASC;
