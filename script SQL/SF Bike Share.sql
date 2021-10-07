
--- opady 'T' (traces) zamiana na 0

	select * , 
		case
		when w.precipitation_inches = 'T' then 0 :: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation
	from weather w 



--- miesieczne parametry pogody dla danego zip_code

with new_weather_CTE as
	(
	select * , 
		case
		when w.precipitation_inches = 'T' then 0:: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation
	from weather w
	)	
select extract (month from "date") as "month" , 
	w.zip_code , 
	zc.city ,
	round(avg(max_temperature_f):: numeric , 3) as max_monthly_temperature ,
	round(avg(mean_temperature_f):: numeric , 3) as mean_monthly_temperature ,
	round(avg(min_temperature_f):: numeric , 3) as min_monthly_temperature ,
	round(avg(max_dew_point_f):: numeric , 3) as max_monthly_dew_point ,
	round(avg(mean_dew_point_f):: numeric , 3) as mean_monthly_dew_point ,
	round(avg(min_dew_point_f):: numeric , 3) as min_monthly_dew_point ,
	round(avg(max_humidity):: numeric , 3) as max_monthly_humidity ,
	round(avg(mean_humidity):: numeric , 3) as mean_monthly_humidity ,
	round(avg(min_humidity):: numeric , 3) as min_monthly_humidity ,
	round(avg(max_sea_level_pressure_inches):: numeric , 3) as max_monthly_sea_level_pressure_inches ,
	round(avg(mean_sea_level_pressure_inches):: numeric , 3) as mean_monthly_sea_level_pressure_inches ,
	round(avg(min_sea_level_pressure_inches):: numeric , 3) as min_monthly_sea_level_pressure_inches ,
	round(avg(max_visibility_miles):: numeric , 3) as max_monthly_visibility_miles ,
	round(avg(mean_visibility_miles):: numeric , 3) as mean_monthly_visibility_miles ,
	round(avg(min_visibility_miles):: numeric , 3) as min_monthly_visibility_miles ,
	round(avg("max_wind_Speed_mph"):: numeric , 3) as max_monthly_wind_Speed_mph ,
	round(avg("mean_wind_speed_mph"):: numeric , 3) as mean_monthly_wind_Speed_mph ,
	round(avg(max_gust_speed_mph):: numeric , 3) as max_monthly_gust_speed_mph ,
	round(avg(percipitation):: numeric , 3) as monthly_percipitation_inch ,
	round(avg(cloud_cover):: numeric , 3) as monthly_cloud_cover ,
	round(avg(wind_dir_degrees):: numeric , 3) as monthly_wind_dir_degrees 
from new_weather_CTE w
join zip_code zc
	on w.zip_code = zc.zip_code 
group by w.zip_code, zc.city, extract (month from "date")
order by date_part('month', "date") 

	
--- miesieczne parametry pogody z rokiem dla danego zip_code	
with new_weather_CTE as
	(
	select * , 
		case
		when w.precipitation_inches = 'T' then 0:: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation
	from weather w
	)		
select to_char("date", 'yyyy-mm') as "new_date" , 
	zip_code ,
	round(avg(max_temperature_f):: numeric , 3) as max_monthly_temperature ,
	round(avg(mean_temperature_f):: numeric , 3) as mean_monthly_temperature ,
	round(avg(min_temperature_f):: numeric , 3) as min_monthly_temperature ,
	round(avg(max_dew_point_f):: numeric , 3) as max_monthly_dew_point ,
	round(avg(mean_dew_point_f):: numeric , 3) as mean_monthly_dew_point ,
	round(avg(min_dew_point_f):: numeric , 3) as min_monthly_dew_point ,
	round(avg(max_humidity):: numeric , 3) as max_monthly_humidity ,
	round(avg(mean_humidity):: numeric , 3) as mean_monthly_humidity ,
	round(avg(min_humidity):: numeric , 3) as min_monthly_humidity ,
	round(avg(max_sea_level_pressure_inches):: numeric , 3) as max_monthly_sea_level_pressure_inches ,
	round(avg(mean_sea_level_pressure_inches):: numeric , 3) as mean_monthly_sea_level_pressure_inches ,
	round(avg(min_sea_level_pressure_inches):: numeric , 3) as min_monthly_sea_level_pressure_inches ,
	round(avg(max_visibility_miles):: numeric , 3) as max_monthly_visibility_miles ,
	round(avg(mean_visibility_miles):: numeric , 3) as mean_monthly_visibility_miles ,
	round(avg(min_visibility_miles):: numeric , 3) as min_monthly_visibility_miles ,
	round(avg("max_wind_Speed_mph"):: numeric , 3) as max_monthly_wind_Speed_mph ,
	round(avg("mean_wind_speed_mph"):: numeric , 3) as mean_monthly_wind_Speed_mph ,
	round(avg(max_gust_speed_mph):: numeric , 3) as max_monthly_gust_speed_mph ,
	round(avg(percipitation):: numeric , 3) as monthly_percipitation_inch ,
	round(avg(cloud_cover):: numeric , 3) as monthly_cloud_cover ,
	round(avg(wind_dir_degrees):: numeric , 3) as monthly_wind_dir_degrees 
	from new_weather_CTE 
	group by zip_code, to_char("date", 'yyyy-mm')
	order by "new_date"	

	
	
--- zjawiska pogodowe per m-c
select extract (month from w."date") as "month" , 
	zc.city ,
	initcap(rtrim(ltrim(w.events))) as "events",
	count(w.events)
from weather w 
join zip_code zc
	on w.zip_code = zc.zip_code 
group by extract (month from w."date"), w.zip_code , zc.city , w.events
order by date_part('month', w."date"), initcap(w.events)



--- zjawiska pogodowe per rok i m-c
select to_char(w."date", 'yyyy-mm') as "new_date" , 
	--zc.city ,
	initcap(rtrim(ltrim(w.events))) as "events",
	count(w.events)
from weather w 
join zip_code zc
	on w.zip_code = zc.zip_code 
group by to_char(w."date", 'yyyy-mm'), w.events
order by new_date, events
	

--- The most popular routes with count & duration time !!!!!!!!!!!!!!!!!!!
SELECT t.start_station_name,
		t.end_station_name,
		COUNT(*) as no_of_trips ,
		round(avg(t.duration)/60 :: numeric , 3) as duration_min
from trip t
where t.duration in 
		(select t.duration
		from trip t 
		where t.duration < 86400)
group by
		t.start_station_name,
		t.end_station_name 
order by no_of_trips desc
limit 10




--- The most popular routes with count & duration time & subscbtion_type !!!!!!!!!!!!!!!
SELECT t.start_station_name ,
		t.end_station_name ,
		t.subscription_type ,
		COUNT(*) as no_of_trips ,
		round(avg(t.duration)/60 :: numeric , 3) as duration_min
from trip t
where rtrim(ltrim(lower(t.subscription_type))) = 'customer' and t.duration in 
		(select t.duration
		from trip t 
		where t.duration < 86400)
group by
		t.start_station_name,
		t.end_station_name ,
		t.subscription_type 
order by no_of_trips desc
limit 10




---!!!!!!!!!!!!! TO JEST TO POLACZENIE ---> star, end, city, zip, data, cloud cover   ----> cloud cover dla danego dnia

select t.start_station_name , 
	t.start_station_id , 
	s.city , 
	zc.zip_code , 
	t.start_date ,
	w.cloud_cover 	 
from trip t 
left join station s 
	on t.start_station_id = s.id 
inner join zip_code zc 
	on s.city = zc.city 
left join weather w 
	on t.start_date = w."date" and zc.zip_code = w.zip_code 
order by t.start_station_name



											--- count trips & duration time & data dla 1 trasy z dolaczonymi parametrami pogody

select '1' as ranking,
	concat(t.start_station_name , '-->' , t.end_station_name) as trip_name, 
	w."date" ,
	cOUNT (t.id) as total_trips ,
	round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
	w.cloud_cover ,
	w.min_temperature_f ,
	w.mean_temperature_f ,
	w.max_temperature_f ,
	w.mean_wind_speed_mph ,
	w."max_wind_Speed_mph" ,
	case
		when w.precipitation_inches = 'T' then 0 :: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation ,
		case when lower(w.events) = 'rain' then 1 else 0  end as rain ,
		case when lower(w.events) = 'rain-thunderstorm' then 1 else 0  end as rain_thunderstorm ,
		case when lower(w.events) = 'fog' then 1 else 0  end as fog ,
		case when lower(w.events) = 'fog-rain' then 1 else 0  end as fog_rain	
from trip t 
left join station s 
	on t.start_station_id = s.id 
inner join zip_code zc 
	on s.city = zc.city 
left join weather w 
	on t.start_date = w."date" and zc.zip_code = w.zip_code
where t.duration < 86400 and trim(ltrim(lower(t.subscription_type))) = 'subscriber' 	 
group by t.start_station_name ,
		t.end_station_name , 
		w."date" ,
		w.cloud_cover ,
		w.min_temperature_f ,
		w.mean_temperature_f ,
		w.max_temperature_f ,
		w.mean_wind_speed_mph ,
		w."max_wind_Speed_mph" ,
		w.precipitation_inches ,
		w.events 
having 	t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and 	t.end_station_name = 'Townsend at 7th'
order by w."date"



										--- obliczenie korelacji
with corr_CTE as
	(
	select t.start_station_name , 
	t.end_station_name , 
	w."date" ,
	cOUNT (t.id) as total_trips ,
	round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
	w.cloud_cover ,
	w.min_temperature_f ,
	w.mean_temperature_f ,
	w.max_temperature_f ,
	w.mean_wind_speed_mph ,
	w."max_wind_Speed_mph" ,
	w.mean_visibility_miles ,
	case
		when w.precipitation_inches = 'T' then 0 :: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation ,
		case when lower(w.events) = 'rain' then 1 else 0  end as rain ,
		case when lower(w.events) = 'rain-thunderstorm' then 1 else 0  end as rain_thunderstorm ,
		case when lower(w.events) = 'fog' then 1 else 0  end as fog ,
		case when lower(w.events) = 'fog-rain' then 1 else 0  end as fog_rain		
	from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code
	where t.duration < 86400 --and trim(ltrim(lower(t.subscription_type))) = 'subscriber'	
	group by t.start_station_name ,
			t.end_station_name , 
			w."date" ,
			w.cloud_cover ,
			w.min_temperature_f ,
			w.mean_temperature_f ,
			w.max_temperature_f ,
			w.mean_wind_speed_mph ,
			w."max_wind_Speed_mph" ,
			w.mean_visibility_miles ,
			w.precipitation_inches ,
			w.events 
	having 	t.start_station_name = 'San Francisco Caltrain (Townsend at 4th)' and 	t.end_station_name = 'Harry Bridges Plaza (Ferry Buildin'
	order by w."date"
	)
select --round((corr(total_trips, cloud_cover)):: numeric, 3) as total_trips_cloud_cover ,
	--round((corr("duration_min", cloud_cover)):: numeric, 3) as duration_min_cloud_cover ,
	--round((corr(total_trips, min_temperature_f)):: numeric, 3) as total_trips_min_temperature ,
	--round((corr("duration_min", min_temperature_f)):: numeric, 3) as duration_min_min_temperature ,
	--round((corr(total_trips, mean_temperature_f)):: numeric, 3) as total_trips_mean_temperature ,
	--round((corr("duration_min", mean_temperature_f)):: numeric, 3) as duration_min_mean_temperature ,
	--round((corr(total_trips, max_temperature_f)):: numeric, 3) as total_trips_max_temperature ,
	--round((corr("duration_min", max_temperature_f)):: numeric, 3) as duration_max_min_temperature ,
	--round((corr(total_trips, mean_wind_speed_mph)):: numeric, 3) as total_trips_mean_wind_speed_mph ,
	--round((corr("duration_min", mean_wind_speed_mph)):: numeric, 3) as duration_min_mean_wind_speed_mph ,
	--round((corr(total_trips, "max_wind_Speed_mph")):: numeric, 3) as total_trips_max_wind_speed_mph ,
	--round((corr("duration_min", "max_wind_Speed_mph")):: numeric, 3) as duration_min_max_wind_speed_mph ,
	round((corr(total_trips, mean_visibility_miles)):: numeric, 3) as total_trips_mean_visibility_miles ,
	round((corr("duration_min", mean_visibility_miles)):: numeric, 3) as duration_min_mean_visibility_miles ,
	--round((corr(total_trips, percipitation)):: numeric, 3) as total_trips_percipitation ,
	--round((corr("duration_min", percipitation)):: numeric, 3) as duration_min_percipitation ,
	round((corr(total_trips, rain)):: numeric, 3) as total_trips_rain ,
	round((corr("duration_min", rain)):: numeric, 3) as duration_min_rain ,
	round((corr(total_trips, rain_thunderstorm)):: numeric, 3) as total_trips_rain_thunderstorm ,
	round((corr("duration_min", rain_thunderstorm)):: numeric, 3) as duration_min_rain_thunderstorm ,
	round((corr(total_trips, fog)):: numeric, 3) as total_trips_fog ,
	round((corr("duration_min", fog)):: numeric, 3) as duration_min_fog ,
	round((corr(total_trips, fog_rain)):: numeric, 3) as total_trips_fog_rain ,
	round((corr("duration_min", fog_rain)):: numeric, 3) as duration_min_fog_rain	
from corr_CTE


select w."date" , w.mean_visibility_miles 
from weather w 
where w.mean_visibility_miles is null

--------------------test Micha³a


SELECT start_station_name, end_station_name, cloud_cover, total_trips, corr(total_trips, cloud_cover) OVER(PARTITION BY  start_station_name, end_station_name) cloud_cover_corr
FROM	
	(select t.start_station_name , 
	t.end_station_name , 
	w."date" ,
	cOUNT (t.id) as total_trips ,
	round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
	w.cloud_cover ,
	w.min_temperature_f ,
	w.mean_temperature_f ,
	w.max_temperature_f ,
	w.mean_wind_speed_mph ,
	w."max_wind_Speed_mph" ,
	case
		when w.precipitation_inches = 'T' then 0 :: numeric
		else w.precipitation_inches :: numeric 
		end as percipitation ,
		case when lower(w.events) = 'rain' then 1 else 0  end as rain ,
		case when lower(w.events) = 'rain-thunderstorm' then 1 else 0  end as rain_thunderstorm ,
		case when lower(w.events) = 'fog' then 1 else 0  end as fog ,
		case when lower(w.events) = 'fog-rain' then 1 else 0  end as fog_rain		
	from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code
	where t.duration < 86400 --and trim(ltrim(lower(t.subscription_type))) = 'subscriber'	
	group by t.start_station_name ,
			t.end_station_name , 
			w."date" ,
			w.cloud_cover ,
			w.min_temperature_f ,
			w.mean_temperature_f ,
			w.max_temperature_f ,
			w.mean_wind_speed_mph ,
			w."max_wind_Speed_mph" ,
			w.precipitation_inches ,
			w.events 
	--having 	t.start_station_name = 'San Francisco Caltrain (Townsend at 4th)' and 	t.end_station_name = 'Harry Bridges Plaza (Ferry Building)'
	order by w."date"
	) total_trips_route
WHERE total_trips>200
GROUP BY start_station_name, end_station_name, total_trips, cloud_cover
ORDER BY  total_trips desc

		------------------------------------TEST KORELACJI DLA WSZYTSKICH TRAS --- TRZEBA TO LEPIEJ SPRAWDZIC



with corr_CTE as
	(
	select concat(t.start_station_name , ' --> ' , t.end_station_name ) as trip_name, 
		cOUNT (t.id) as total_trips ,
		w.mean_visibility_miles 
		--t.subscription_type ,
		--round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
		--w.cloud_cover 
		--w.min_temperature_f ,
		--w.mean_temperature_f 
		/*w.max_temperature_f ,
		w.mean_wind_speed_mph ,
		w."max_wind_Speed_mph" ,
		case
			when w.precipitation_inches = 'T' then 0 :: numeric
			else w.precipitation_inches :: numeric 
			end as percipitation ,*/
			--case when lower(w.events) = 'rain' then 1 else 0  end as rain 
			/*case when lower(w.events) = 'rain-thunderstorm' then 1 else 0  end  as rain_thunderstorm ,
			case when lower(w.events) = 'fog' then 1 else 0  end as fog ,
			case when lower(w.events) = 'fog-rain' then 1 else 0  end as fog_rain*/	
	from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code
	where t.duration < 86400 
	group by
			t.start_station_name,
			t.end_station_name ,
			w.mean_visibility_miles
			--w.cloud_cover ,
			--t.subscription_type 
			--w.min_temperature_f ,
			--w.mean_temperature_f 
			/*w.max_temperature_f ,
			w.mean_wind_speed_mph ,
			w."max_wind_Speed_mph" ,
			w.precipitation_inches ,*/
			--w.events 
	order by total_trips desc
	)
select distinct trip_name , --subscription_type ,
	total_trips ,
	round((corr(total_trips, mean_visibility_miles)):: numeric, 3) as total_trips_mean_visibility_miles
	--cloud_cover ,
	--round(corr(total_trips, cloud_cover) over (partition by trip_name)::numeric, 3) as total_trips_cloud_cover 
	/*--round((corr("duration_min", cloud_cover)):: numeric, 3) as duration_min_cloud_cover ,
	round((corr(total_trips, min_temperature_f)):: numeric, 3) as total_trips_min_temperature ,
	--round((corr("duration_min", min_temperature_f)):: numeric, 3) as duration_min_min_temperature ,*/
	--round((corr(total_trips, mean_temperature_f)):: numeric, 3) as total_trips_mean_temperature 
	--round((corr("duration_min", mean_temperature_f)):: numeric, 3) as duration_min_mean_temperature ,
	/*round((corr(total_trips, max_temperature_f)):: numeric, 3) as total_trips_max_temperature ,
	--round((corr("duration_min", max_temperature_f)):: numeric, 3) as duration_max_min_temperature ,
	round((corr(total_trips, mean_wind_speed_mph)):: numeric, 3) as total_trips_mean_wind_speed_mph ,
	--round((corr("duration_min", mean_wind_speed_mph)):: numeric, 3) as duration_min_mean_wind_speed_mph ,
	round((corr(total_trips, "max_wind_Speed_mph")):: numeric, 3) as total_trips_max_wind_speed_mph ,
	--round((corr("duration_min", "max_wind_Speed_mph")):: numeric, 3) as duration_min_max_wind_speed_mph , 
	round((corr(total_trips, percipitation)):: numeric, 3) as total_trips_percipitation ,
	--round((corr("duration_min", percipitation)):: numeric, 3) as duration_min_percipitation ,*/
	--round((corr(total_trips, rain)):: numeric, 3) as total_trips_rain 
	/*--round((corr("duration_min", rain)):: numeric, 3) as duration_min_rain ,
	round((corr(total_trips, rain_thunderstorm)):: numeric, 3) as total_trips_rain_thunderstorm ,
	--round((corr("duration_min", rain_thunderstorm)):: numeric, 3) as duration_min_rain_thunderstorm ,
	round((corr(total_trips, fog)):: numeric, 3) as total_trips_fog ,
	--round((corr("duration_min", fog)):: numeric, 3) as duration_min_fog ,
	round((corr(total_trips, fog_rain)):: numeric, 3) as total_trips_fog_rain 
	--round((corr("duration_min", fog_rain)):: numeric, 3) as duration_min_fog_rain*/
from corr_CTE
group by trip_name ,
	total_trips ,
	mean_visibility_miles
	--subscription_type ,
	--cloud_cover 
	/*min_temperature_f ,*/
	--mean_temperature_f 
	--max_temperature_f ,
	--mean_wind_speed_mph 
	/*"max_wind_Speed_mph" ,
	percipitation ,*/
	--rain 
	/*rain_thunderstorm ,
	fog ,
	fog-rain*/
order by total_trips desc



--- zapytanie dla 10 najpopularniejszych j.w.


with popular_trips_CTE as (
			SELECT t.start_station_name,
				t.start_station_id ,
				t.end_station_name ,
				t.end_station_id ,
				COUNT(*) as no_of_trips ,
				round(avg(t.duration)/60 :: numeric , 3) as duration_min
			from trip t
			where t.duration in 
					(select t.duration
					from trip t 
					where t.duration < 86400)
			group by
					t.start_station_name,
					t.start_station_id ,
					t.end_station_name ,
					t.end_station_id
			order by no_of_trips desc
			limit 10
				)
select t.start_station_name , 
	t.end_station_name ,
	s.city , 
	zc.zip_code , 
	w.cloud_cover ,  
	t.start_date
from trip t 
left join station s 
	on t.start_station_id = s.id 
inner join zip_code zc 
	on s.city = zc.city 
left join weather w 
	on t.start_date = w."date" and zc.zip_code = w.zip_code 
where t.start_station_name in 	
		(SELECT t.start_station_name
		from popular_trips_CTE)
order by t.start_station_name	







with popular_trips_CTE as (
			SELECT t.start_station_name,
				t.start_station_id ,
				t.end_station_name ,
				t.end_station_id ,
				COUNT(*) as no_of_trips ,
				round(avg(t.duration)/60 :: numeric , 3) as duration_min
			from trip t
			where t.duration in 
					(select t.duration
					from trip t 
					where t.duration < 86400)
			group by
					t.start_station_name,
					t.start_station_id ,
					t.end_station_name ,
					t.end_station_id
			order by no_of_trips desc
			limit 10
				)
select t.start_station_name , t.end_station_name , t.start_date ,
		count (t.id) as total_trips , 
		round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
		w.cloud_cover 
from trip t 
left join station s 
	on t.start_station_id = s.id 
inner join zip_code zc 
	on s.city = zc.city 
left join weather w 
	on t.start_date = w."date" and zc.zip_code = w.zip_code 
where t.start_station_name in 	
		(SELECT t.start_station_name
		from popular_trips_CTE)	
group by t.start_station_name ,
		t.end_station_name , t.start_date, w.cloud_cover
--having 	t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and 	t.end_station_name = 'Townsend at 7th'
order by t.start_date , total_trips desc







---------------------------------------------------------------


select * , 
	rank () over (order by total_trips desc) as pos
from
	(	
	SELECT t.start_station_name , t.start_station_id, s.city as start_city, zc.zip_code as start_zip_code ,
		t.end_station_name , t.end_station_id, s.city as end_city , zc.zip_code as end_zip_code ,
		COUNT(*) as total_trips ,
		round(avg(t.duration)/60 :: numeric , 0) as "duration_min"
	from trip t 
	join station s on t.start_station_id = s.id 
	join zip_code zc on s.city = zc.city
	where t.id <> 568474
	group by t.start_station_name ,t.start_station_id, s.city, zc.zip_code,
		t.end_station_name , t.end_station_id 
	order by total_trips desc
	limit 10
	) as tmp	
	

	
select w."date" , w.cloud_cover , w.zip_code 
from weather w 
where w.zip_code = '94107'
	

select * , 
	rank () over (order by total_trips desc) as pos
from
	(	
	SELECT t.start_station_name , t.start_station_id, s.city as start_city, zc.zip_code as start_zip_code ,
		t.end_station_name , t.end_station_id, s.city as end_city , zc.zip_code as end_zip_code ,
		COUNT(*) as total_trips ,
		round(avg(t.duration)/60 :: numeric , 0) as "duration_min",
		pogoda.cloud_cover
	from trip t 
	join station s on t.start_station_id = s.id 
	join zip_code zc on s.city = zc.city
	join (
		select w."date" , w.cloud_cover , w.zip_code 
		from weather w 
		where w.zip_code = '94107'	
		) pogoda
		on t.start_date = pogoda."date"
	where t.id <> 568474
	group by t.start_station_name ,t.start_station_id, s.city, zc.zip_code,
		t.end_station_name , t.end_station_id , pogoda.cloud_cover
	order by total_trips desc
	limit 10
	) as tmp





----- !!!!!!! analiza trasy dla podanego kodu pocztowego i parametru pogody ---> iloœæ tras za duza ???
with popular_trips_CTE as (
			SELECT t.start_station_name,
				t.start_station_id ,
				t.end_station_name ,
				t.end_station_id ,
				COUNT(*) as no_of_trips ,
				round(avg(t.duration)/60 :: numeric , 3) as duration_min
			from trip t
			where t.duration in 
					(select t.duration
					from trip t 
					where t.duration < 86400)
			group by
					t.start_station_name,
					t.start_station_id ,
					t.end_station_name ,
					t.end_station_id
			order by no_of_trips desc
			limit 10
				)
	SELECT t.start_station_name,
			t.end_station_name, 
			w.events , 
			count(distinct w."date") events_days ,
			COUNT(*) as total_trips ,
			round(avg(t.duration)/60 :: numeric , 0) as "avg_duration_min" 
			--COUNT(*) / count(distinct w."date") as trips_per_day
	from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code
	where t.duration < 86400 and t.start_station_name in 	
									(SELECT t.start_station_name
									from popular_trips_CTE)	
	group by t.start_station_name,
		t.end_station_name,
		t.subscription_type , w.events 
	order by total_trips desc
	
	
select count(*)
from trip t 
where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and t.end_station_name = 'Townsend at 7th'
		

-------------- 
select * 
from (
	select w.events ,
	count(w.events) over (partition by w.events) as events_days 
	from weather w 
	) tmp
group by events , events_days

---- jak dodac kody zip, miesiac???




-------- dziwne wyniki, za du¿o trip -----------> dzielone przez 0
select 
	w.zip_code , 
	w.events , 
	t.subscription_type , 
	count(distinct w."date") as events_days ,
	round(avg(t.duration):: numeric/60, 0) as duration_min ,
	count (distinct t.id) as total_trips ,    ------ 5 razy za duzo trip
	count (w.events)/count(distinct w."date") as trips_per_day
from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code
where t.duration < 86400 
group by w.zip_code , w.events , t.subscription_type



select distinct zip_code
from weather w 


select distinct zip_code
from trip t 
where zip_code in ('94041' ,'95113' ,'94063' ,'94107', '94301')


								--------------- iloœæ wypo¿yczeñ w zale¿noœci od dnia tygodnia i subscr_type
select extract (isodow from t.start_date) , 
		t.subscription_type ,
		COUNT(t.subscription_type) as ilosc , 					
		round(avg(t.duration)/60 :: numeric , 3) as "duration_min" ,
		mode() within group (order by t.duration) ----- sprawdzic skladnie
from trip t
group by extract (isodow from t.start_date) ,
	t.subscription_type 
order by extract (isodow from t.start_date), ilosc desc;




--- TO JESZCZE MO¯NA DODAC
----- popularne trasy w zaleznosci od dnia tygodnie  -- do tego trzeba znaleŸæ lepsze rozwi¹zanie --- OVER PARTITION BY Z LIMITEM????
select extract (isodow from t.start_date) ,
		t.start_station_name ,
		t.end_station_name,
		COUNT(t.start_station_name) as Count , 			-- iloœæ trips OK
		round(avg(t.duration)/60 :: numeric , 0) as "duration_min"
	from trip t 
	group by extract (isodow from t.start_date) ,
		t.start_station_name ,
		t.end_station_name
	having COUNT(t.start_station_name) >500
	order by extract (isodow from t.start_date), Count desc;


--- wykorzystac wyzej
/*select
  * 
FROM (
  SELECT
    ROW_NUMBER() OVER (PARTITION BY extract (isodow from t.start_date) ORDER BY t.start_station_name ,
		t.end_station_name) AS r,
    t.*
  FROM
    trip t) x
WHERE
  x.r <= 2;*/




--- The most popular routes with count & duration time & subscbtion_type _CUSTOMER --------------------> to robi Michal

SELECT t.start_station_name,
		t.end_station_name,
		t.subscription_type ,
		w.events ,
		COUNT(t.subscription_type) as Count ,
		round(avg(t.duration)/60 :: numeric , 3) as "duration_min"
	from trip t
	join weather w on t.start_date = w."date" 
	where w.zip_code = '94107' and t.id <> 568474
	group by
		t.start_station_name,
		t.end_station_name ,
		t.subscription_type ,
		w.events 
	having lower(t.subscription_type) ilike 'cust%' and rtrim(ltrim(lower(w.events))) = 'fog' 
	order by Count desc
	limit 40;


------------zip_code klienta

SELECT t.start_station_name,
		t.end_station_name,
		t.subscription_type ,
		t.zip_code ,
		COUNT(t.subscription_type) as Count ,
		round(avg(t.duration)/60 :: numeric , 0) as "duration_min"
	from trip t
	group by
		t.start_station_name,
		t.end_station_name ,
		t.subscription_type ,
		t.zip_code 
	order by Count desc
	limit 40;

select t.zip_code ,
count(t.zip_code)
from trip t 
group by t.zip_code
order by count(t.zip_code) desc 


--- The most popular routes with count > 400 & duration time & month 

SELECT extract (month from t.start_date) as "month" ,
		t.start_station_name,
		t.end_station_name,
		COUNT(t.start_station_name) as Count ,
		round(avg(t.duration)/60 :: numeric , 3) as "duration_min"
	from trip t
	group by extract (month from t.start_date) ,
		t.start_station_name,
		t.end_station_name 
	having COUNT(t.subscription_type) > 400
	order by extract (month from t.start_date), Count desc
	
	

--- The most popular routes with count > 400 & duration time & subscription_type & month --- to trzeba znaleŸæ inaczej

SELECT extract (month from t.start_date) as "month" ,
		t.start_station_name,
		t.end_station_name,
		t.subscription_type ,
		COUNT(t.subscription_type) as Count ,
		round(avg(t.duration)/60 :: numeric , 3) as "duration_min"
	from trip t
	group by extract (month from t.start_date) ,
		t.start_station_name,
		t.end_station_name ,
		t.subscription_type
	having COUNT(t.subscription_type) > 400
	order by extract (month from t.start_date), Count desc 
	

	
	
		
	
	
	
	
	
---- subscriber v consumer	per month
	
select extract (month from t.start_date) as "month" ,
	t.subscription_type ,
	COUNT(t.id) as Count  						
from trip t 
group by 1 , t.subscription_type
order by "month", t.subscription_type 







---to JESZCZE MOZNA DODAC
--- count with month, events, subcriber_type & duration
select extract (month from w."date") as "month" ,
	w.events,
	t.subscription_type ,
	round((avg(t.duration))/60 :: numeric, 3) as duration_min, 
	count(t.subscription_type) 						-- liczy trips razy 5 
	from weather w
	join trip t on w."date" = t.start_date 
	group by extract (month from w."date") , w.events , t.subscription_type
	order by "month"



--- Max duration of a trip (6 months???)
SELECT *
FROM trip
ORDER BY duration desc 
LIMIT 10

/*
id    |duration|start_date
------+--------+----------
568474|17270400|2014-12-06
825850| 2137000|2015-06-28
750192| 1852590|2015-05-02
841176| 1133540|2015-07-10
*/

select count (*),
	round((avg(t.duration):: numeric)/60 , 2) as avg_min,
	round((min(t.duration):: numeric)/60 , 2) as minim_min,
	round((max(t.duration):: numeric)/60 , 2) as maxim_min,
	round((stddev(t.duration):: numeric)/60 , 2) as stddev_min
	from trip t
	where t.id <> 568474

/*
count |avg_min|minim_min|maxim_min|stddev_min
------+-------+---------+---------+----------
669958|  18.04|     1.00| 35616.67|    118.04
*/




SELECT COUNT(*) AS num_count,
           ROUND(AVG(duration/60), 2) AS avg_duration_mins,
           trip.start_station_name,
           trip.end_station_name
    FROM trip
    INNER JOIN station
    ON station.id = start_station_id
    WHERE station.city = 'San Francisco' AND duration/60/60 <= 15
    GROUP BY 3, 4
    ORDER BY 1 DESC
    LIMIT 15;
   
   
   
   /*WITH t1 AS (SELECT DATE(CASE
                -- m/d/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 8 AND substr(start_date,2,1) = '/') 
               THEN substr(start_date,5,4)||'-0'||substr(start_date,1,1)||'-0'||substr(start_date,3,1)
               -- m/dd/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 9 AND substr(start_date,2,1) = '/') 
               THEN substr(start_date,6,4)||'-0'||substr(start_date,1,1)||'-'||substr(start_date,3,2)
               -- mm/d/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 9 AND substr(start_date,3,1) = '/') 
               THEN substr(start_date,6,4)||'-0'||substr(start_date,1,2)||'-'||substr(start_date,4,1)
               -- mm/dd/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 10 AND substr(start_date,3,1) = '/') 
               THEN substr(start_date,7,4)||'-'||substr(start_date,1,2)||'-'||substr(start_date,4,2)
               ELSE start_date
               END) AS trip_date,
               subscription_type, 
               (duration / 60) AS duration_min
        FROM trip
        INNER JOIN station
        ON station.id = start_station_id
        WHERE city='San Francisco' AND duration/60/60 <= 15)
    SELECT CASE 
           WHEN (trip_date IN (DATE(trip_date, 'weekday 6'), DATE(trip_date, 'weekday 0')))
           THEN 'weekends'
           ELSE 'weekdays'
           END AS weekday,
           subscription_type,
           ROUND(AVG(duration_min), 2) AS avg_dur_min         
    FROM t1
    GROUP BY 1,2;*/

   
   
    /*WITH t1 AS (SELECT DATE(CASE
                -- m/d/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 8 AND substr(start_date,2,1) = '/') 
               THEN substr(start_date,5,4)||'-0'||substr(start_date,1,1)||'-0'||substr(start_date,3,1)
               -- m/dd/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 9 AND substr(start_date,2,1) = '/') 
               THEN substr(start_date,6,4)||'-0'||substr(start_date,1,1)||'-'||substr(start_date,3,2)
               -- mm/d/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 9 AND substr(start_date,3,1) = '/') 
               THEN substr(start_date,6,4)||'-0'||substr(start_date,1,2)||'-'||substr(start_date,4,1)
               -- mm/dd/yyyy
               WHEN ((INSTR(start_date, ' ')-1) = 10 AND substr(start_date,3,1) = '/') 
               THEN substr(start_date,7,4)||'-'||substr(start_date,1,2)||'-'||substr(start_date,4,2)
               ELSE start_date
               END) AS trip_date,
               subscription_type, 
               (duration / 60) AS duration_min
        FROM trip
        INNER JOIN station
        ON station.id = start_station_id
        WHERE city='San Francisco' AND duration/60/60 <= 15)
    SELECT CASE 
           WHEN trip_date = (DATE(trip_date, 'weekday 1'))
           THEN '1 - Monday'
           WHEN trip_date = (DATE(trip_date, 'weekday 2'))
           THEN '2 - Tuesday'
           WHEN trip_date = (DATE(trip_date, 'weekday 3'))
           THEN '3 - Wednesday'
           WHEN trip_date = (DATE(trip_date, 'weekday 4'))
           THEN '4 - Thursday'
           WHEN trip_date = (DATE(trip_date, 'weekday 5'))
           THEN '5 - Friday'
           WHEN trip_date = (DATE(trip_date, 'weekday 6'))
           THEN '6 - Saturday'
           ELSE '7 - Sunday'
           END AS weekday,
           subscription_type,
           ROUND(AVG(duration_min), 2) AS avg_dur_min    
    FROM t1
    GROUP BY 1,2
    ORDER BY 2,1;*/
   
   

