/* routes - trips with distance - first join */

CREATE TABLE routes AS
SELECT 
	t.start_station_id,
	t.start_station_name,
	t.end_station_id,
	t.end_station_name,
	bike_id,
	t.subscription_type,
	t.zip_code,
	COUNT(*) as total_trips,
	round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
	distance, t.start_date
FROM trip t
JOIN station s on t.start_station_id = s.id
JOIN zip_code zc on s.city = zc.city
JOIN 
	(SELECT DISTINCT 
		s.id start_id,
		s2.id end_id,
		s.name,
		s2.name,
		s.lat AS lat1,
		s.long AS long1,
		s2.lat AS lat2,
		s2.long AS long2,
		round(earth_distance(ll_to_earth(s.lat, s.long), ll_to_earth(s2.lat, s2.long))::NUMERIC, 2) AS distance
	FROM station s
	CROSS JOIN station s2
	) distance 
ON distance.start_id=t.start_station_id AND distance.end_id=t.end_station_id
WHERE t.id <> 568474
GROUP BY 
	t.start_station_id,
	t.start_station_name,
	t.end_station_id,
	t.end_station_name,
	bike_id,
	t.subscription_type,
	t.zip_code,
	distance.distance,
	t.start_date
ORDER BY total_trips DESC;

/* table routes_distance_weather - to routes table added weather conditions */


CREATE TABLE routes_distance_weather AS
SELECT 
	r.start_station_id,
	r.start_station_name,
	r.end_station_id,
	r.end_station_name,
	r.bike_id,
	r.subscription_type,
	r.duration_min,
	r.distance,
	r.start_date,
	w.*
FROM routes r
LEFT JOIN station s
ON r.start_station_id = s.id
INNER JOIN zip_code zc
ON s.city = zc.city
LEFT JOIN weather w
ON r.start_date::date = w."date" AND zc.zip_code = w.zip_code;

	
