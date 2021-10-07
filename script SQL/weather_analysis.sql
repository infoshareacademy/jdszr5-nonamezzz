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

