					--- The most popular routes with count & duration time (lower then 24h) 

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


				--- The most popular routes with count & duration time & customer

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



				--- The most popular routes with count & duration time & subscriber

SELECT t.start_station_name ,
		t.end_station_name ,
		t.subscription_type ,
		COUNT(*) as no_of_trips ,
		round(avg(t.duration)/60 :: numeric , 3) as duration_min
from trip t
where rtrim(ltrim(lower(t.subscription_type))) = 'subscriber' and t.duration in 
		(select t.duration
		from trip t 
		where t.duration < 86400)
group by
		t.start_station_name,
		t.end_station_name ,
		t.subscription_type 
order by no_of_trips desc
limit 10