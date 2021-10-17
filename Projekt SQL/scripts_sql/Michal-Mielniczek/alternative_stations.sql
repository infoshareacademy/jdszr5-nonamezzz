/* shows no of minutes for station in a day of the week in specific month and year with no bikes avaiable! */
SELECT 
	station_id,
	date_part('month', "time") "month",
	date_part('year', "time") "year",
	EXTRACT(ISODOW FROM s.time) AS day_of_the_week,
	count(bikes_available) AS count_of_no_bikes
FROM status s 
WHERE bikes_available = 0
GROUP BY 
	date_part('month', "time"),
	date_part('year', "time"),
	day_of_the_week,
	s.station_id 
ORDER BY count_of_no_bikes DESC;
/* shows no of minutes for station in a day of the week in specific month and year with no bikes avaiable! */
SELECT 
	station_id,
	date_part('month', "time") "month",
	date_part('year', "time") "year",
	date_part('day', "time") AS "day",
	count(bikes_available) AS count_of_no_bikes
FROM status s 
WHERE bikes_available = 0
GROUP BY 
	date_part('month', "time"),
	date_part('year', "time"),
	date_part('day', "time"),
	s.station_id 
ORDER BY count_of_no_bikes DESC;

/*Very time-consuming query - Alternative_stations table find all alternative stations, in the case if some stations there are no bikes avaiable 
 * (with the information about distance between station with no bikes and alternative_station*/
CREATE TABLE alternative_stations as
SELECT 
	s1.station_id id_station_with_no_bikes_available,
	s1.bikes_available, 
	s1."time",
	s2.station_id alternative_station,
	s2.bikes_available amount_of_bikes_at_alternative_station,
	round(earth_distance(ll_to_earth(s3.lat, s3.long),ll_to_earth(s4.lat, s4.long))::NUMERIC, 2) distance
FROM status s1
INNER JOIN status s2 
ON s1."time"=s2."time" AND s1.bikes_available=0 AND s2.bikes_available>0
INNER JOIN station s3 
ON s1.station_id=s3.id
INNER JOIN station s4 
ON s2.station_id=s4.id
ORDER BY 
	s1.time, 
	id_station_with_no_bikes_available,
	distance asc;

/* Example use of this solution for specifc time - it can be used by stations with no bikes 
what will allow to find for current time another alternative stations*/
SELECT
	s1.station_id id_station_with_no_bikes_available,
	s1.bikes_available, 
	to_char(s1."time",'yyyy-mm-dd HH:mm'),
	s2.station_id alternative_station,
	s2.bikes_available,
	to_char(s2."time",'yyyy-mm-dd HH:mm'),
	round(earth_distance(ll_to_earth(s3.lat, s3.long), ll_to_earth(s4.lat, s4.long))::NUMERIC, 2) distance
FROM status s1
INNER JOIN status s2 
ON s1."time"=s2."time" AND s1.bikes_available=0 AND s2.bikes_available>0 AND s1."time"='2013-08-29 12:09:01'
INNER JOIN station s3 
ON s1.station_id=s3.id
INNER JOIN station s4 
ON s2.station_id=s4.id
WHERE round(earth_distance(ll_to_earth(s3.lat, s3.long), ll_to_earth(s4.lat, s4.long))::NUMERIC, 2)<500
ORDER BY 
	id_station_with_no_bikes_available,
	distance ASC;

 




