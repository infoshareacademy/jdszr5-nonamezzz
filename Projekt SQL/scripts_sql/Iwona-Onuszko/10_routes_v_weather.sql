		---- utworzenie dodatkowej tabeli do polaczenia trip z weather

create table zip_code (
	zip_code VARCHAR(15),
	city VARCHAR(13)
	);

	
	
INSERT INTO zip_code (zip_code, city) 
VALUES 
	('95113', 'San Jose') ,
	('94041', 'Mountain View') ,
	('94107', 'San Francisco') ,
	('94301', 'Palo Alto') ,
	('94063', 'Redwood City');		
		

			---- POLACZENIE ---> star, end, city, zip, data, cloud cover   ----> cloud cover dla danego dnia

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




						--- count trips & duration time & data dla 1 trasy z dolaczonymi parametrami pogody -----> bardzo d³ugi czas zapytania

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