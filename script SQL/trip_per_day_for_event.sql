		-------- city & events & subcriber type & trips per day z korelacj¹
		
create temp table trasy as 
			SELECT t.start_station_name,
				t.end_station_name,
				COUNT(*) as no_of_trips
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
						


with CTE as (
	select 
		zc.city , 
		w.events , 
		t.subscription_type ,
		count(distinct w."date") as events_days ,
		count (distinct t.id) as total_trips ,
		count (w.events)/count(distinct w."date") as trips_per_day
	from trip t 
	left join station s 
		on t.start_station_id = s.id 
	inner join zip_code zc 
		on s.city = zc.city 
	left join weather w 
		on t.start_date = w."date" and zc.zip_code = w.zip_code 
	group by zc.city , w.events , t.subscription_type
	) 						
select corr(events_days, trips_per_day)	
from CTE
--where start_station_name in (select trasy.start_station_name from trasy)	