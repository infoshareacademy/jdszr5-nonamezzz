/*podstawowy ranking*/
SELECT 
	*,
	RANK () OVER (ORDER BY total_trips DESC) AS route_rank,
	round(total_trips::numeric / (SUM(total_trips) OVER())::numeric,4) AS ratio
FROM
	(SELECT
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance, 
		COUNT(*) AS total_trips,
		round(avg(rdw.duration_min)) duration_min
	FROM routes_distance_weather rdw
	GROUP BY
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance
	ORDER BY total_trips DESC
	) AS tmp
LIMIT 10;

/* ranking dni powszednie*/
SELECT 
	*,
	RANK () OVER (ORDER BY total_trips DESC) AS route_rank,
	round(total_trips::numeric / (SUM(total_trips) OVER())::numeric,4) AS ratio
FROM
	(SELECT
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance,
		COUNT(*) AS total_trips,
		round(avg(rdw.duration_min)) duration_min
	FROM routes_distance_weather rdw
	WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5
	GROUP BY
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance
	ORDER BY total_trips DESC
	) AS tmp
LIMIT 10;

/*ranking  weekend*/
SELECT 
	*,
	RANK () OVER (ORDER BY total_trips DESC) AS route_rank,
	round(total_trips::numeric / (SUM(total_trips) OVER())::numeric,4) AS ratio
FROM
	(
	SELECT
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance,
		COUNT(*) AS total_trips,
		round(avg(rdw.duration_min)) duration_min
	FROM routes_distance_weather rdw
	WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
	GROUP BY
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance
	ORDER BY total_trips DESC
	) AS tmp
LIMIT 10;

SELECT events, count(events) FROM weather w WHERE zip_code='94107' GROUP BY events ;
/* rain ogólny - mam ich całe mnóstwo, ale ciężko to się obrazuje, więc tutaj wrzucam przykładowy*/ 
SELECT 
	*,
	RANK () OVER (ORDER BY total_trips DESC) AS route_rank,
	round(total_trips::numeric / (SUM(total_trips) OVER())::numeric,4) AS ratio
FROM
	(
	SELECT
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance,
		COUNT(*) AS total_trips,
		round(avg(rdw.duration_min)) duration_min
	FROM routes_distance_weather rdw
	WHERE lower(events) = 'rain' AND zip_code='94107'
	GROUP BY
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance
	ORDER BY total_trips DESC
	) AS tmp
LIMIT 10;
/*rain weekend - jak wyżej*/
SELECT 
	*,
	RANK () OVER (ORDER BY total_trips DESC) AS route_rank,
	round(total_trips::numeric / (SUM(total_trips) OVER())::numeric,4) AS ratio
FROM
	(
	SELECT
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance,
		COUNT(*) AS total_trips,
		round(avg(rdw.duration_min)) duration_min
	FROM routes_distance_weather rdw
	WHERE lower(events) = 'rain' AND zip_code='94107' AND EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
	GROUP BY
		rdw.start_station_id,
		rdw.start_station_name,
		rdw.end_station_id,
		rdw.end_station_name,
		distance
	ORDER BY total_trips DESC
	) AS tmp
LIMIT 10;

/*Trochę statystyki powiązanej z pogodą - tutaj też wrzucam przykładowy parametr - będzi ich trochę więcej prawdopodobnie*/
/*cloud_cover ogólny*/
SELECT cloud_cover, zip_code, count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips FROM routes_distance_weather rdw
GROUP BY cloud_cover, zip_code
ORDER BY zip_code;

/*cloud_cover pon-ptk*/
SELECT 
	cloud_cover, 
	zip_code, 
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
GROUP BY 
	cloud_cover,
	zip_code
ORDER BY zip_code;

/*cloud_cover w tygodniu*/
SELECT 
	cloud_cover, 
	zip_code, 
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5
GROUP BY 
	cloud_cover, 
	zip_code
ORDER BY zip_code;



