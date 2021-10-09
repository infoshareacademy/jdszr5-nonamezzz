					--- obliczenie korelacji dla 10 najpolularniejszych tras - (korelacja dla wszystkich 10 tras lub dla pojedyñczej trasy)
	
create temp table trasy as 					--------- 10 najpopularniejszych tras ze wszystkich
		SELECT t.start_station_name,
			t.end_station_name,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400
		group by
			t.start_station_name,
			t.end_station_name 
		order by no_of_trips desc
		limit 10	
			
			
create temp table trasy_subscriber as 		--------- 10 najpopularniejszych tras dla subsciber
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			lower(t.subscription_type) = 'subscriber'
		group by
				t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10	
			
			
create temp table trasy_customer as 		--------- 10 najpopularniejszych tras dla customer
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			lower(t.subscription_type) = 'customer'
		group by
			t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10	
			
create temp table trasy_weekend as 		--------- 10 najpopularniejszych tras weekend
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			EXTRACT(ISODOW FROM t.start_date) BETWEEN 6 AND 7
		group by
			t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10			
		
			
create temp table trasy_weekdays as 		--------- 10 najpopularniejszych tras weekdays
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			EXTRACT(ISODOW FROM t.start_date) BETWEEN 1 AND 5
		group by
			t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10				
	
		
create temp table trasy_weekdend_customer as 		--------- 10 najpopularniejszych tras weekend & customer
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			lower(t.subscription_type) = 'customer' and
			EXTRACT(ISODOW FROM t.start_date) BETWEEN 6 AND 7
		group by
			t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10		
			
		
create temp table trasy_weekday_customer as 		--------- 10 najpopularniejszych tras weekdays & customer
		SELECT t.start_station_name,
			t.end_station_name,
			t.subscription_type ,
			COUNT(*) as no_of_trips
		from trip t
		where t.duration < 86400 and 
			lower(t.subscription_type) = 'customer' and
			EXTRACT(ISODOW FROM t.start_date) BETWEEN 1 AND 5
		group by
			t.start_station_name,
			t.end_station_name ,
			t.subscription_type 
		order by no_of_trips desc
		limit 10		
		
select *
from trasy_weekday_customer
					


---- korelacja dla 10 najpopularniejszych tras (ten sam skrypt dla wszystkich tras, subscriber type lub pojedyñczej trasy)
					
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
	where t.duration < 86400 and t.start_station_name in 
								(select start_station_name 
								from trasy_weekday_customer)	
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
	--having 	t.start_station_name = 'Steuart at Market' and 	t.end_station_name = '2nd at Townsend'
	order by w."date"
	)
select round((corr(total_trips, cloud_cover)):: numeric, 3) as total_trips_cloud_cover ,
	round((corr("duration_min", cloud_cover)):: numeric, 3) as duration_min_cloud_cover ,
	round((corr(total_trips, min_temperature_f)):: numeric, 3) as total_trips_min_temperature ,
	round((corr("duration_min", min_temperature_f)):: numeric, 3) as duration_min_min_temperature ,
	round((corr(total_trips, mean_temperature_f)):: numeric, 3) as total_trips_mean_temperature ,
	round((corr("duration_min", mean_temperature_f)):: numeric, 3) as duration_min_mean_temperature ,
	round((corr(total_trips, max_temperature_f)):: numeric, 3) as total_trips_max_temperature ,
	round((corr("duration_min", max_temperature_f)):: numeric, 3) as duration_max_min_temperature ,
	round((corr(total_trips, mean_wind_speed_mph)):: numeric, 3) as total_trips_mean_wind_speed_mph ,
	round((corr("duration_min", mean_wind_speed_mph)):: numeric, 3) as duration_min_mean_wind_speed_mph ,
	round((corr(total_trips, "max_wind_Speed_mph")):: numeric, 3) as total_trips_max_wind_speed_mph ,
	round((corr("duration_min", "max_wind_Speed_mph")):: numeric, 3) as duration_min_max_wind_speed_mph ,
	round((corr(total_trips, mean_visibility_miles)):: numeric, 3) as total_trips_mean_visibility_miles ,
	round((corr("duration_min", mean_visibility_miles)):: numeric, 3) as duration_min_mean_visibility_miles ,
	round((corr(total_trips, percipitation)):: numeric, 3) as total_trips_percipitation ,
	round((corr("duration_min", percipitation)):: numeric, 3) as duration_min_percipitation ,
	round((corr(total_trips, rain)):: numeric, 3) as total_trips_rain ,
	round((corr("duration_min", rain)):: numeric, 3) as duration_min_rain ,
	round((corr(total_trips, rain_thunderstorm)):: numeric, 3) as total_trips_rain_thunderstorm ,
	round((corr("duration_min", rain_thunderstorm)):: numeric, 3) as duration_min_rain_thunderstorm ,
	round((corr(total_trips, fog)):: numeric, 3) as total_trips_fog ,
	round((corr("duration_min", fog)):: numeric, 3) as duration_min_fog ,
	round((corr(total_trips, fog_rain)):: numeric, 3) as total_trips_fog_rain ,
	round((corr("duration_min", fog_rain)):: numeric, 3) as duration_min_fog_rain	
from corr_CTE
