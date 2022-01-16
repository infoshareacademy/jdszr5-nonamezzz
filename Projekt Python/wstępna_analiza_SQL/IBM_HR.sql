select 
	"JobSatisfaction" ,
	--"Attrition" ,
	--"JobLevel" ,
	--"JobRole" ,
	--"Education" ,
	--"EducationField" ,
	count(1) as ilosc,
	max("MonthlyIncome") as maximum ,
	min("MonthlyIncome") as minimum ,
	round(avg("MonthlyIncome"):: numeric, 3) as œrednia , 
	round(stddev("MonthlyIncome"):: numeric, 3) as odchylenie_std ,
	percentile_cont(0.5) within group (order by "MonthlyIncome") as mediana ,
	percentile_cont(0.9) within group (order by "MonthlyIncome") as Q90 ,
	percentile_cont(0.1) within group (order by "MonthlyIncome") as Q10 
from ibm_hr ih 
where "Attrition" not like 'Yes' 
group by "JobSatisfaction" --,"Attrition" --, "JobLevel" --, "JobRole" , "Education" , "EducationField" 


select 
	"JobSatisfaction" ,
	--"Attrition" ,
	--"JobLevel" ,
	--"JobRole" ,
	--"Education" ,
	--"EducationField" ,
	"MonthlyIncome" ,
	count(1) as ilosc
from ibm_hr ih 
group by "JobSatisfaction" , "MonthlyIncome" --,"Attrition" --, "JobLevel" --, "JobRole" , "Education" , "EducationField"
	




select
	corr("JobSatisfaction" , "MonthlyIncome") as korelacja_job_sat_v_monthly_income
from ibm_hr ih 


select * 
from ibm_hr ih 

						------------	Satisfaction

select 
	"JobSatisfaction" ,
	count(1)
from ibm_hr ih 
where "Attrition" ilike 'no'
group by "JobSatisfaction" 


select 
	"EnvironmentSatisfaction" ,
	count(1)
from ibm_hr ih 
where "Attrition" ilike 'no'
group by "EnvironmentSatisfaction" 


select 
	"RelationshipSatisfaction" ,
	count(1)
from ibm_hr ih
where "Attrition" ilike 'no'
group by "RelationshipSatisfaction" 


						------------	Satisfaction v. Gender

select 
	/*"JobSatisfaction" ,
	"EnvironmentSatisfaction" ,*/
	"RelationshipSatisfaction" ,
	--"Attrition" ,
	sum(case when "Gender" ilike 'female' then count("Gender") end) over (partition by "RelationshipSatisfaction" order by "RelationshipSatisfaction" asc) kobiety ,
	sum(case when "Gender" ilike 'male' then count("Gender") end) over (partition by "RelationshipSatisfaction" order by "RelationshipSatisfaction" asc) mê¿czyŸni
	--count("Attrition") 
	/*max("MonthlyIncome") as maximum ,
	min("MonthlyIncome") as minimum ,
	round(avg("MonthlyIncome"):: numeric, 3) as œrednia , 
	round(stddev("MonthlyIncome"):: numeric, 3) as odchylenie_std ,
	percentile_cont(0.5) within group (order by "MonthlyIncome") as mediana ,
	percentile_cont(0.9) within group (order by "MonthlyIncome") as Q90 ,
	percentile_cont(0.1) within group (order by "MonthlyIncome") as Q10 */
from ibm_hr ih 
--where "Attrition" ilike 'yes'
group by /*"JobSatisfaction" , "EnvironmentSatisfaction" ,*/ "RelationshipSatisfaction" , "Gender" 
order by /*"JobSatisfaction" , "EnvironmentSatisfaction" ,*/ "RelationshipSatisfaction" 


select 	
	/*"JobSatisfaction" ,
	EnvironmentSatisfaction ,*/
	"RelationshipSatisfaction" ,
	--"Attrition" ,
	"Gender" ,
	count("Attrition") 
from ibm_hr ih 	
where "Attrition" ilike 'yes'	
group by /*"JobSatisfaction" , "EnvironmentSatisfaction" ,*/ "RelationshipSatisfaction" , "Attrition" , "Gender" 	
order by /*"JobSatisfaction" , "EnvironmentSatisfaction" ,*/ "RelationshipSatisfaction" , "Gender" 	



					------------------ Satisfaction v. Department

select 
	"JobSatisfaction" ,
	"Department" , 
	count("Department")
from ibm_hr ih 
group by "JobSatisfaction" , "Department" 
order by "Department" , "JobSatisfaction" 



					------------------ Satisfaction v. Education

select 
	"RelationshipSatisfaction" ,
	"Education" , 
	count("Education")
from ibm_hr ih 
group by "RelationshipSatisfaction" , "Education" 
order by "Education" , "RelationshipSatisfaction" 


					------------------ Satisfaction v. Education Field

select 
	"JobSatisfaction" ,
	"EducationField" , 
	count("EducationField")
from ibm_hr ih 
group by "JobSatisfaction" , "EducationField" 
order by "EducationField" , "JobSatisfaction" 


					------------------ Satisfaction v. Job Involvement

select 
	"RelationshipSatisfaction" ,
	"JobInvolvement" , 
	count("JobInvolvement")
from ibm_hr ih 
group by "RelationshipSatisfaction" , "JobInvolvement" 
order by "JobInvolvement" , "RelationshipSatisfaction" 



					------------------ Satisfaction v. Job Role

select 
	"RelationshipSatisfaction" ,
	"JobRole" , 
	count("JobLevel")
from ibm_hr ih 
group by "RelationshipSatisfaction" , "JobRole" 
order by "JobRole" , "RelationshipSatisfaction" 



					------------------ Satisfaction v. Marital Status

select 
	"JobSatisfaction" ,
	"MaritalStatus" , 
	count("MaritalStatus")
from ibm_hr ih 
group by "JobSatisfaction" , "MaritalStatus" 
order by "MaritalStatus" , "JobSatisfaction" 



					------------------ Satisfaction v. Work - Life Balans

select 
	"RelationshipSatisfaction" ,
	"WorkLifeBalance" , 
	count("WorkLifeBalance")
from ibm_hr ih 
group by "RelationshipSatisfaction" , "WorkLifeBalance" 
order by "WorkLifeBalance" , "RelationshipSatisfaction" 



					------------------ Satisfaction v. Business Travel

select 
	"JobSatisfaction" ,
	"BusinessTravel" , 
	count("BusinessTravel")
from ibm_hr ih 
group by "JobSatisfaction" , "BusinessTravel" 
order by "BusinessTravel" , "JobSatisfaction" 



					------------------ Satisfaction v. Monthly Income

select 
	"JobSatisfaction" ,
	"MonthlyIncome" , 
	count("MonthlyIncome")
from ibm_hr ih 
group by "JobSatisfaction" , "MonthlyIncome" 
order by "MonthlyIncome" , "JobSatisfaction" 
