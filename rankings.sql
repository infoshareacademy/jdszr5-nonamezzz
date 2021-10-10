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

/*Trochę statystyki powiązanej z pogodą - cloud cover/mean_temp, events */
/*cloud_cover ogólny*/
SELECT cloud_cover, zip_code, count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips FROM routes_distance_weather rdw
GROUP BY cloud_cover, zip_code
ORDER BY zip_code;

/*cloud_cover weekend*/
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
/*cloud_cover pon-ptk*/
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

/*events*/
SELECT 
	events,
	zip_code,
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips,
	count(DISTINCT start_date::date) 
FROM routes_distance_weather rdw 
GROUP BY 
	events, 
	zip_code
ORDER BY zip_code;

/*events weekend*/
SELECT 
	events,
	zip_code,
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips,
	count(DISTINCT start_date::date)  
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
GROUP BY 
	events, 
	zip_code
ORDER BY zip_code;
/*events pon-ptk*/
SELECT 
	events,
	zip_code,
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips,
	count(DISTINCT start_date::date) 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5
GROUP BY 
	events, 
	zip_code
ORDER BY zip_code;

/*mean_temperature_f*/

SELECT 
	mean_temperature_f,
	zip_code,
	count( start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips, count(start_station_id),
	count(DISTINCT start_date::date) 
FROM routes_distance_weather rdw 
GROUP BY 
	mean_temperature_f, 
	zip_code
ORDER BY zip_code;

/*mean_temperature_f weekend*/
SELECT 
	mean_temperature_f,
	zip_code,
	count( start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips, count(start_station_id),
	count(DISTINCT start_date::date)
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
GROUP BY 
	mean_temperature_f, 
	zip_code
ORDER BY zip_code;
/*mean_temperature_f pon-ptk*/
SELECT 
	mean_temperature_f,
	zip_code,
	count( start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips, count(start_station_id),
	count(DISTINCT start_date::date)
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5
GROUP BY 
	mean_temperature_f, 
	zip_code
ORDER BY zip_code;


/* Jak się najpopularniejsze trasy zmieniają z pogodą jako średnia wycieczek na event,
 *  najpierw potworzone rankingi a potem jak te trasy z rankingów zmieniają się z pogodą - rankigi różne - ogólny pon/ptk, weekend*/
CREATE TEMP TABLE top_routes as 
	(SELECT 
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
	LIMIT 10
		);
/* pon-ptk*/
CREATE TEMP TABLE top_routes_mon_fri as 
	(SELECT 
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
	LIMIT 10
		);
/* weekend*/
CREATE TEMP TABLE top_routes_weekend as 
	(SELECT 
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
		WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7
		GROUP BY
			rdw.start_station_id,
			rdw.start_station_name,
			rdw.end_station_id,
			rdw.end_station_name,
			distance
		ORDER BY total_trips DESC
		) AS tmp
	LIMIT 10
		);
where start_station_name in (select trasy.start_station_name from trasy);

/*cloud cover wszystkie dni - top 10 tras*/
SELECT DISTINCT
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code, 
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE (start_station_id, end_station_id) IN (SELECT start_station_id, end_station_id FROM top_routes)
GROUP BY 
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code
ORDER BY zip_code;

/*cloud cover weekend - trasy ranking ogólny */
SELECT DISTINCT
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code, 
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7 AND (start_station_id, end_station_id) IN (SELECT start_station_id, end_station_id FROM top_routes ORDER BY route_rank)
GROUP BY 
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code
ORDER BY zip_code;

/*cloud cover weekend - trasy weekendowe*/
SELECT DISTINCT
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code,
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 6 AND 7 AND (start_station_id, end_station_id) IN (SELECT start_station_id, end_station_id FROM top_routes_weekend ORDER BY route_rank)
GROUP BY 
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover,
	zip_code;

/*cloud cover pon_ptk stat - trasy ranking ogólny*/
SELECT DISTINCT
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code, 
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5 AND (start_station_id, end_station_id) IN (SELECT start_station_id, end_station_id FROM top_routes ORDER BY route_rank)
GROUP BY 
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code
ORDER BY zip_code;

/*cloud cover pon-ptk - trasy pon-ptk*/
SELECT DISTINCT
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover, 
	zip_code,
	count(start_station_id)/count(DISTINCT start_date::date) avg_no_of_trips 
FROM routes_distance_weather rdw
WHERE EXTRACT(ISODOW FROM rdw."start_date") BETWEEN 1 AND 5 AND (start_station_id, end_station_id) IN (SELECT start_station_id, end_station_id FROM top_routes_mon_fri ORDER BY route_rank)
GROUP BY 
	rdw.start_station_id,
	rdw.start_station_name,
	rdw.end_station_id,
	rdw.end_station_name,
	cloud_cover,
	zip_code;



