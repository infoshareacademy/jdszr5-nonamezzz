			--- iloœæ wypo¿yczeñ w zale¿noœci od dnia tygodnia i subscr_type
			
select extract (isodow from t.start_date) , 
		t.subscription_type ,
		COUNT(t.subscription_type) as ilosc , 					
		round(avg(t.duration)/60 :: numeric , 3) as "duration_min" 
from trip t
group by extract (isodow from t.start_date) ,
	t.subscription_type 
order by extract (isodow from t.start_date), ilosc desc;




			---- subscriber v consumer	per month
	
select extract (month from t.start_date) as "month" ,
	t.subscription_type ,
	COUNT(t.id) as Count  						
from trip t 
group by 1 , t.subscription_type
order by "month", t.subscription_type 





			--- analiza czasu trwania wypo¿yczenia


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