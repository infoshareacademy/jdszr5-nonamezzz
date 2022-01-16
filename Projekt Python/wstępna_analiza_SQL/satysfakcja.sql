
--------------------T3.STATYSTYKA DOT. OGÓLNEJ SATYSFAKCJI----------------------------------------------------------------------

select * from ibm_hr ih ;

--dodanie kolumny satysfakcja
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
--Podstawowe miary statystyczne

with sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	count(satisfaction),
	round(avg(satisfaction)::numeric,2) as mean,
	min(satisfaction),
	round(stddev(satisfaction)::numeric,2) as std,
	percentile_disc(0.25) within group (order by satisfaction) as q1,
	percentile_disc(0.5) within group (order by satisfaction) as q2,
	percentile_disc(0.75) within group (order by satisfaction) as q3, 
	max(satisfaction),
	mode() within group (order by satisfaction)
from sat_CTE;

--*sprawdzenie MODY
with sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	satisfaction,
	count(satisfaction) as total
from sat_CTE
group by satisfaction
order by satisfaction;

--korelacja --**zmienna jakosciowaaa

with corr_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction,
		case when ih."Attrition" = 'Yes' then 1 else 0 end as count_attrition,
		case when ih."BusinessTravel" = 'Non-Travel' then 1 else 0 end as count_Non_Travel,
		case when ih."BusinessTravel" = 'Travel_Rarely' then 1 else 0 end as count_Travel_Rarely,
		case when ih."BusinessTravel" = 'Travel_Frequently' then 1 else 0 end as count_Travel_Frequently
	from ibm_hr ih 
)
select
	round(corr(satisfaction,"Age")::numeric,2) as corr_age,
	round(corr(satisfaction,count_attrition)::numeric,2) as corr_attrition,
	round(corr(satisfaction,"Age")::numeric,2) as corr_age,
	round(corr(satisfaction,count_Non_Travel)::numeric,2) as corr_count_Non_Travel,
	round(corr(satisfaction,count_Travel_Rarely)::numeric,2) as corr_count_Travel_Rarely,
	round(corr(satisfaction,count_Travel_Frequently)::numeric,2) as corr_count_Travel_Frequently
from corr_sat_CTE


--korelacja pomiedzy ogolna satysfakcja a innymi czynnikami

with corr_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	round(corr(satisfaction,"Age")::numeric,2) as corr_age,
	round(corr(satisfaction,"DistanceFromHome")::numeric,2) as corr_DistanceFromHome,
	round(corr(satisfaction,"Education")::numeric,2) as corr_Education,
	round(corr(satisfaction,"EnvironmentSatisfaction")::numeric,2) as corr_EnvironmentSatisfaction,
	round(corr(satisfaction,"JobInvolvement")::numeric,2) as corr_JobInvolvement,
	round(corr(satisfaction,"JobLevel")::numeric,2) as corr_JobLevel,
	round(corr(satisfaction,"JobSatisfaction")::numeric,2) as corr_JobSatisfaction,
	round(corr(satisfaction,"MonthlyIncome")::numeric,2) as corr_MonthlyIncome,
	round(corr(satisfaction,"NumCompaniesWorked")::numeric,2) as corr_NumCompanyWorked,
	round(corr(satisfaction,"PerformanceRating")::numeric,2) as corr_PerformanceRating,
	round(corr(satisfaction,"RelationshipSatisfaction")::numeric,2) as corr_RelationshipSatisfaction,
	round(corr(satisfaction,"StockOptionLevel")::numeric,2) as corr_StockOptionLevel,
	round(corr(satisfaction,"TotalWorkingYears")::numeric,2) as corr_TotalWorkingYears,
	round(corr(satisfaction,"TrainingTimesLastYear")::numeric,2) as corr_TrainingTimesLastYear,
	round(corr(satisfaction,"WorkLifeBalance")::numeric,2) as corr_WorkLifeBalance,
	round(corr(satisfaction,"YearsAtCompany")::numeric,2) as corr_YearsAtCompany,
	round(corr(satisfaction,"YearsInCurrentRole")::numeric,2) as corr_YearsInCurrentRole,
	round(corr(satisfaction,"YearsSinceLastPromotion")::numeric,2) as corr_YearsSinceLastPromotion,
	round(corr(satisfaction,"YearsWithCurrManager")::numeric,2) as corr_YearsWithCurrManager
from corr_sat_CTE


--statystyki przy satysfakcji 3 i 4

with high_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	satisfaction,
	count(satisfaction)
from high_sat_CTE
where satisfaction between 3 and 4
group by satisfaction


with high_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	round(avg("Age")::numeric,2) as mean_age, --"Age"
	round(stddev("Age")::numeric,2) as std_age,
	min("Age") as min_age,
	percentile_disc(0.25) within group (order by "Age") as q1_age,
	percentile_disc(0.5) within group (order by "Age") as median_age,
	percentile_disc(0.75) within group (order by "Age") as q3_age, 
	max("Age") as max_age,
	round(avg("DistanceFromHome")::numeric,2) as mean_DistanceFromHome, --"DistanceFromHome"
	round(stddev("DistanceFromHome")::numeric,2) as std_DistanceFromHome,
	min("DistanceFromHome") as min_DistanceFromHome,
	percentile_disc(0.25) within group (order by "DistanceFromHome") as q1_DistanceFromHome,
	percentile_disc(0.5) within group (order by "DistanceFromHome") as median_DistanceFromHome,
	percentile_disc(0.75) within group (order by "DistanceFromHome") as q3_DistanceFromHome, 
	max("DistanceFromHome") as max_DistanceFromHome,
	round(avg("MonthlyIncome")::numeric,2) as mean_MonthlyIncome, --"MonthlyIncome"
	round(stddev("MonthlyIncome")::numeric,2) as std_MonthlyIncome,
	min("MonthlyIncome") as min_MonthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome, 
	max("MonthlyIncome") as max_MonthlyIncome,
	round(avg("NumCompaniesWorked")::numeric,2) as mean_NumCompaniesWorked,  --*czy tak to podac "NumCompaniesWorked"
	round(stddev("NumCompaniesWorked")::numeric,2) as std_NumCompaniesWorked,
	min("NumCompaniesWorked") as min_NumCompaniesWorked,
	percentile_disc(0.25) within group (order by "NumCompaniesWorked") as q1_NumCompaniesWorked,
	percentile_disc(0.5) within group (order by "NumCompaniesWorked") as median_NumCompaniesWorked,
	percentile_disc(0.75) within group (order by "NumCompaniesWorked") as q3_NumCompaniesWorked, 
	max("NumCompaniesWorked") as max_NumCompaniesWorked,
	round(avg("TotalWorkingYears")::numeric,2) as mean_TotalWorkingYears, --"TotalWorkingYears"
	round(stddev("TotalWorkingYears")::numeric,2) as std_TotalWorkingYears,
	min("TotalWorkingYears") as min_TotalWorkingYears,
	percentile_disc(0.25) within group (order by "TotalWorkingYears") as q1_TotalWorkingYears,
	percentile_disc(0.5) within group (order by "TotalWorkingYears") as median_TotalWorkingYears,
	percentile_disc(0.75) within group (order by "TotalWorkingYears") as q3_TotalWorkingYears, 
	max("TotalWorkingYears") as max_TotalWorkingYears,
	round(avg("YearsAtCompany")::numeric,2) as mean_YearsAtCompany, --"YearsAtCompany"
	round(stddev("YearsAtCompany")::numeric,2) as std_YearsAtCompany,
	min("YearsAtCompany") as min_TotalWorkingYears,
	percentile_disc(0.25) within group (order by "YearsAtCompany") as q1_YearsAtCompany,
	percentile_disc(0.5) within group (order by "YearsAtCompany") as median_YearsAtCompany,
	percentile_disc(0.75) within group (order by "YearsAtCompany") as q3_YearsAtCompany, 
	max("YearsAtCompany") as max_YearsAtCompany,
	round(avg("YearsInCurrentRole")::numeric,2) as mean_YearsInCurrentRole, --"YearsInCurrentRole"
	round(stddev("YearsInCurrentRole")::numeric,2) as std_YearsInCurrentRole,
	min("YearsInCurrentRole") as min_YearsInCurrentRole,
	percentile_disc(0.25) within group (order by "YearsInCurrentRole") as q1_YearsInCurrentRole,
	percentile_disc(0.5) within group (order by "YearsInCurrentRole") as median_YearsInCurrentRole,
	percentile_disc(0.75) within group (order by "YearsInCurrentRole") as q3_YearsInCurrentRole, 
	max("YearsInCurrentRole") as max_YearsInCurrentRole,
	round(avg("YearsSinceLastPromotion")::numeric,2) as mean_YearsSinceLastPromotion, --"YearsSinceLastPromotion"
	round(stddev("YearsSinceLastPromotion")::numeric,2) as std_YearsSinceLastPromotion,
	min("YearsSinceLastPromotion") as min_YearsSinceLastPromotion,
	percentile_disc(0.25) within group (order by "YearsSinceLastPromotion") as q1_YearsSinceLastPromotion,
	percentile_disc(0.5) within group (order by "YearsSinceLastPromotion") as median_YearsSinceLastPromotion,
	percentile_disc(0.75) within group (order by "YearsSinceLastPromotion") as q3_YearsSinceLastPromotion, 
	max("YearsSinceLastPromotion") as max_YearsSinceLastPromotion,
	round(avg("YearsWithCurrManager")::numeric,2) as mean_YearsWithCurrManager, --"YearsWithCurrManager"
	round(stddev("YearsWithCurrManager")::numeric,2) as std_YearsWithCurrManager,
	min("YearsWithCurrManager") as min_YearsWithCurrManager,
	percentile_disc(0.25) within group (order by "YearsWithCurrManager") as q1_YearsWithCurrManager,
	percentile_disc(0.5) within group (order by "YearsWithCurrManager") as median_YearsWithCurrManager,
	percentile_disc(0.75) within group (order by "YearsWithCurrManager") as q3_YearsWithCurrManager, 
	max("YearsWithCurrManager") as max_YearsWithCurrManager
from high_sat_CTE
where satisfaction between 3 and 4

--Departamenty

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Department" ,
	count("Department") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "Department"

--BusinessTravel

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"BusinessTravel" ,
	count("BusinessTravel") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "BusinessTravel"

--EducationField
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"EducationField" ,
	count("EducationField") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "EducationField"

--Gender 

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Gender" ,
	count("Gender") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "Gender"

--JobRole
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"JobRole" ,
	count("JobRole") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "JobRole"

--MaritalStatus

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"MaritalStatus" ,
	count("MaritalStatus") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "MaritalStatus"

--OverTime

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"OverTime" ,
	count("OverTime") as Total
from other_sat_CTE
where satisfaction between 3 and 4
group by "OverTime"

--statystyki przy satysfakcji 1 i 2

with low_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	satisfaction,
	count(satisfaction)
from low_sat_CTE
where satisfaction between 1 and 2
group by satisfaction

with low_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	round(avg("Age")::numeric,2) as mean_age, --"Age"
	round(stddev("Age")::numeric,2) as std_age,
	min("Age") as min_age,
	percentile_disc(0.25) within group (order by "Age") as q1_age,
	percentile_disc(0.5) within group (order by "Age") as median_age,
	percentile_disc(0.75) within group (order by "Age") as q3_age, 
	max("Age") as max_age,
	round(avg("DistanceFromHome")::numeric,2) as mean_DistanceFromHome, --"DistanceFromHome"
	round(stddev("DistanceFromHome")::numeric,2) as std_DistanceFromHome,
	min("DistanceFromHome") as min_DistanceFromHome,
	percentile_disc(0.25) within group (order by "DistanceFromHome") as q1_DistanceFromHome,
	percentile_disc(0.5) within group (order by "DistanceFromHome") as median_DistanceFromHome,
	percentile_disc(0.75) within group (order by "DistanceFromHome") as q3_DistanceFromHome, 
	max("DistanceFromHome") as max_DistanceFromHome,
	round(avg("MonthlyIncome")::numeric,2) as mean_MonthlyIncome, --"MonthlyIncome"
	round(stddev("MonthlyIncome")::numeric,2) as std_MonthlyIncome,
	min("MonthlyIncome") as min_MonthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome, 
	max("MonthlyIncome") as max_MonthlyIncome,
	round(avg("NumCompaniesWorked")::numeric,2) as mean_NumCompaniesWorked,  --*czy tak to podac "NumCompaniesWorked"
	round(stddev("NumCompaniesWorked")::numeric,2) as std_NumCompaniesWorked,
	min("NumCompaniesWorked") as min_NumCompaniesWorked,
	percentile_disc(0.25) within group (order by "NumCompaniesWorked") as q1_NumCompaniesWorked,
	percentile_disc(0.5) within group (order by "NumCompaniesWorked") as median_NumCompaniesWorked,
	percentile_disc(0.75) within group (order by "NumCompaniesWorked") as q3_NumCompaniesWorked, 
	max("NumCompaniesWorked") as max_NumCompaniesWorked,
	round(avg("TotalWorkingYears")::numeric,2) as mean_TotalWorkingYears, --"TotalWorkingYears"
	round(stddev("TotalWorkingYears")::numeric,2) as std_TotalWorkingYears,
	min("TotalWorkingYears") as min_TotalWorkingYears,
	percentile_disc(0.25) within group (order by "TotalWorkingYears") as q1_TotalWorkingYears,
	percentile_disc(0.5) within group (order by "TotalWorkingYears") as median_TotalWorkingYears,
	percentile_disc(0.75) within group (order by "TotalWorkingYears") as q3_TotalWorkingYears, 
	max("TotalWorkingYears") as max_TotalWorkingYears,
	round(avg("YearsAtCompany")::numeric,2) as mean_YearsAtCompany, --"YearsAtCompany"
	round(stddev("YearsAtCompany")::numeric,2) as std_YearsAtCompany,
	min("YearsAtCompany") as min_YearsAtCompany,
	percentile_disc(0.25) within group (order by "YearsAtCompany") as q1_YearsAtCompany,
	percentile_disc(0.5) within group (order by "YearsAtCompany") as median_YearsAtCompany,
	percentile_disc(0.75) within group (order by "YearsAtCompany") as q3_YearsAtCompany, 
	max("YearsAtCompany") as max_YearsAtCompany,
	round(avg("YearsInCurrentRole")::numeric,2) as mean_YearsInCurrentRole, --"YearsInCurrentRole"
	round(stddev("YearsInCurrentRole")::numeric,2) as std_YearsInCurrentRole,
	min("YearsInCurrentRole") as min_YearsInCurrentRole,
	percentile_disc(0.25) within group (order by "YearsInCurrentRole") as q1_YearsInCurrentRole,
	percentile_disc(0.5) within group (order by "YearsInCurrentRole") as median_YearsInCurrentRole,
	percentile_disc(0.75) within group (order by "YearsInCurrentRole") as q3_YearsInCurrentRole, 
	max("YearsInCurrentRole") as max_YearsInCurrentRole,
	round(avg("YearsSinceLastPromotion")::numeric,2) as mean_YearsSinceLastPromotion, --"YearsSinceLastPromotion"
	round(stddev("YearsSinceLastPromotion")::numeric,2) as std_YearsSinceLastPromotion,
	min("YearsSinceLastPromotion") as min_YearsSinceLastPromotion,
	percentile_disc(0.25) within group (order by "YearsSinceLastPromotion") as q1_YearsSinceLastPromotion,
	percentile_disc(0.5) within group (order by "YearsSinceLastPromotion") as median_YearsSinceLastPromotion,
	percentile_disc(0.75) within group (order by "YearsSinceLastPromotion") as q3_YearsSinceLastPromotion, 
	max("YearsSinceLastPromotion") as max_YearsSinceLastPromotion,
	round(avg("YearsWithCurrManager")::numeric,2) as mean_YearsWithCurrManager, --"YearsWithCurrManager"
	round(stddev("YearsWithCurrManager")::numeric,2) as std_YearsWithCurrManager,
	min("YearsWithCurrManager") as min_YearsWithCurrManager,
	percentile_disc(0.25) within group (order by "YearsWithCurrManager") as q1_YearsWithCurrManager,
	percentile_disc(0.5) within group (order by "YearsWithCurrManager") as median_YearsWithCurrManager,
	percentile_disc(0.75) within group (order by "YearsWithCurrManager") as q3_YearsWithCurrManager, 
	max("YearsWithCurrManager") as max_YearsWithCurrManager
from low_sat_CTE
where satisfaction between 1 and 2

--Departamenty

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Department" ,
	count("Department") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "Department"

--BusinessTravel

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"BusinessTravel" ,
	count("BusinessTravel") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "BusinessTravel"

--EducationField

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"EducationField" ,
	count("EducationField") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "EducationField"

--Gender 

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Gender" ,
	count("Gender") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "Gender"

--JobRole
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"JobRole" ,
	count("JobRole") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "JobRole"

--MaritalStatus

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"MaritalStatus" ,
	count("MaritalStatus") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "MaritalStatus"

--OverTime

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"OverTime" ,
	count("OverTime") as Total
from other_sat_CTE
where satisfaction between 1 and 2
group by "OverTime"


--statystyki przy satysfakcji 1

with vlow_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	satisfaction,
	count(satisfaction)
from vlow_sat_CTE
where satisfaction = 1
group by satisfaction


with vlow_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	round(avg("Age")::numeric,2) as mean_age, --"Age"
	round(stddev("Age")::numeric,2) as std_age,
	min("Age") as min_age,
	percentile_disc(0.25) within group (order by "Age") as q1_age,
	percentile_disc(0.5) within group (order by "Age") as median_age,
	percentile_disc(0.75) within group (order by "Age") as q3_age, 
	max("Age") as max_age,
	round(avg("DistanceFromHome")::numeric,2) as mean_DistanceFromHome, --"DistanceFromHome"
	round(stddev("DistanceFromHome")::numeric,2) as std_DistanceFromHome,
	min("DistanceFromHome") as min_DistanceFromHome,
	percentile_disc(0.25) within group (order by "DistanceFromHome") as q1_DistanceFromHome,
	percentile_disc(0.5) within group (order by "DistanceFromHome") as median_DistanceFromHome,
	percentile_disc(0.75) within group (order by "DistanceFromHome") as q3_DistanceFromHome, 
	max("DistanceFromHome") as max_DistanceFromHome,
	round(avg("MonthlyIncome")::numeric,2) as mean_MonthlyIncome, --"MonthlyIncome"
	round(stddev("MonthlyIncome")::numeric,2) as std_MonthlyIncome,
	min("MonthlyIncome") as min_MonthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome, 
	max("MonthlyIncome") as max_MonthlyIncome,
	round(avg("NumCompaniesWorked")::numeric,2) as mean_NumCompaniesWorked,  --*czy tak to podac "NumCompaniesWorked"
	round(stddev("NumCompaniesWorked")::numeric,2) as std_NumCompaniesWorked,
	min("NumCompaniesWorked") as min_NumCompaniesWorked,
	percentile_disc(0.25) within group (order by "NumCompaniesWorked") as q1_NumCompaniesWorked,
	percentile_disc(0.5) within group (order by "NumCompaniesWorked") as median_NumCompaniesWorked,
	percentile_disc(0.75) within group (order by "NumCompaniesWorked") as q3_NumCompaniesWorked, 
	max("NumCompaniesWorked") as max_NumCompaniesWorked,
	round(avg("TotalWorkingYears")::numeric,2) as mean_TotalWorkingYears, --"TotalWorkingYears"
	round(stddev("TotalWorkingYears")::numeric,2) as std_TotalWorkingYears,
	min("TotalWorkingYears") as min_TotalWorkingYears,
	percentile_disc(0.25) within group (order by "TotalWorkingYears") as q1_TotalWorkingYears,
	percentile_disc(0.5) within group (order by "TotalWorkingYears") as median_TotalWorkingYears,
	percentile_disc(0.75) within group (order by "TotalWorkingYears") as q3_TotalWorkingYears, 
	max("TotalWorkingYears") as max_TotalWorkingYears,
	round(avg("YearsAtCompany")::numeric,2) as mean_YearsAtCompany, --"YearsAtCompany"
	round(stddev("YearsAtCompany")::numeric,2) as std_YearsAtCompany,
	min("YearsAtCompany") as min_YearsAtCompany,
	percentile_disc(0.25) within group (order by "YearsAtCompany") as q1_YearsAtCompany,
	percentile_disc(0.5) within group (order by "YearsAtCompany") as median_YearsAtCompany,
	percentile_disc(0.75) within group (order by "YearsAtCompany") as q3_YearsAtCompany, 
	max("YearsAtCompany") as max_YearsAtCompany,
	round(avg("YearsInCurrentRole")::numeric,2) as mean_YearsInCurrentRole, --"YearsInCurrentRole"
	round(stddev("YearsInCurrentRole")::numeric,2) as std_YearsInCurrentRole,
	min("YearsInCurrentRole") as min_YearsInCurrentRole,
	percentile_disc(0.25) within group (order by "YearsInCurrentRole") as q1_YearsInCurrentRole,
	percentile_disc(0.5) within group (order by "YearsInCurrentRole") as median_YearsInCurrentRole,
	percentile_disc(0.75) within group (order by "YearsInCurrentRole") as q3_YearsInCurrentRole, 
	max("YearsInCurrentRole") as max_YearsInCurrentRole,
	round(avg("YearsSinceLastPromotion")::numeric,2) as mean_YearsSinceLastPromotion, --"YearsSinceLastPromotion"
	round(stddev("YearsSinceLastPromotion")::numeric,2) as std_YearsSinceLastPromotion,
	min("YearsSinceLastPromotion") as min_YearsSinceLastPromotion,
	percentile_disc(0.25) within group (order by "YearsSinceLastPromotion") as q1_YearsSinceLastPromotion,
	percentile_disc(0.5) within group (order by "YearsSinceLastPromotion") as median_YearsSinceLastPromotion,
	percentile_disc(0.75) within group (order by "YearsSinceLastPromotion") as q3_YearsSinceLastPromotion, 
	max("YearsSinceLastPromotion") as max_YearsSinceLastPromotion,
	round(avg("YearsWithCurrManager")::numeric,2) as mean_YearsWithCurrManager, --"YearsWithCurrManager"
	round(stddev("YearsWithCurrManager")::numeric,2) as std_YearsWithCurrManager,
	min("YearsWithCurrManager") as min_YearsWithCurrManager,
	percentile_disc(0.25) within group (order by "YearsWithCurrManager") as q1_YearsWithCurrManager,
	percentile_disc(0.5) within group (order by "YearsWithCurrManager") as median_YearsWithCurrManager,
	percentile_disc(0.75) within group (order by "YearsWithCurrManager") as q3_YearsWithCurrManager, 
	max("YearsWithCurrManager") as max_YearsWithCurrManager
from vlow_sat_CTE
where satisfaction = 1

--Departamenty

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Department" ,
	count("Department") as Total
from other_sat_CTE
where satisfaction = 1
group by "Department"

--BusinessTravel

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"BusinessTravel" ,
	count("BusinessTravel") as Total
from other_sat_CTE
where satisfaction = 1
group by "BusinessTravel"

--EducationField
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"EducationField" ,
	count("EducationField") as Total
from other_sat_CTE
where satisfaction = 1
group by "EducationField"

--Gender 

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Gender" ,
	count("Gender") as Total
from other_sat_CTE
where satisfaction = 1
group by "Gender"

--JobRole
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"JobRole" ,
	count("JobRole") as Total
from other_sat_CTE
where satisfaction = 1
group by "JobRole"

--MaritalStatus

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"MaritalStatus" ,
	count("MaritalStatus") as Total
from other_sat_CTE
where satisfaction = 1
group by "MaritalStatus"

--OverTime

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"OverTime" ,
	count("OverTime") as Total
from other_sat_CTE
where satisfaction = 1
group by "OverTime"

--statystyki przy satysfakcji 4

with vhigh_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	satisfaction,
	count(satisfaction)
from vhigh_sat_CTE
where satisfaction = 4
group by satisfaction


with vhigh_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	round(avg("Age")::numeric,2) as mean_age, --"Age"
	round(stddev("Age")::numeric,2) as std_age,
	min("Age") as min_age,
	percentile_disc(0.25) within group (order by "Age") as q1_age,
	percentile_disc(0.5) within group (order by "Age") as median_age,
	percentile_disc(0.75) within group (order by "Age") as q3_age, 
	max("Age") as max_age,
	round(avg("DistanceFromHome")::numeric,2) as mean_DistanceFromHome, --"DistanceFromHome"
	round(stddev("DistanceFromHome")::numeric,2) as std_DistanceFromHome,
	min("DistanceFromHome") as min_DistanceFromHome,
	percentile_disc(0.25) within group (order by "DistanceFromHome") as q1_DistanceFromHome,
	percentile_disc(0.5) within group (order by "DistanceFromHome") as median_DistanceFromHome,
	percentile_disc(0.75) within group (order by "DistanceFromHome") as q3_DistanceFromHome, 
	max("DistanceFromHome") as max_DistanceFromHome,
	round(avg("MonthlyIncome")::numeric,2) as mean_MonthlyIncome, --"MonthlyIncome"
	round(stddev("MonthlyIncome")::numeric,2) as std_MonthlyIncome,
	min("MonthlyIncome") as min_MonthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome, 
	max("MonthlyIncome") as max_MonthlyIncome,
	round(avg("NumCompaniesWorked")::numeric,2) as mean_NumCompaniesWorked,  --*czy tak to podac "NumCompaniesWorked"
	round(stddev("NumCompaniesWorked")::numeric,2) as std_NumCompaniesWorked,
	min("NumCompaniesWorked") as min_NumCompaniesWorked,
	percentile_disc(0.25) within group (order by "NumCompaniesWorked") as q1_NumCompaniesWorked,
	percentile_disc(0.5) within group (order by "NumCompaniesWorked") as median_NumCompaniesWorked,
	percentile_disc(0.75) within group (order by "NumCompaniesWorked") as q3_NumCompaniesWorked, 
	max("NumCompaniesWorked") as max_NumCompaniesWorked,
	round(avg("TotalWorkingYears")::numeric,2) as mean_TotalWorkingYears, --"TotalWorkingYears"
	round(stddev("TotalWorkingYears")::numeric,2) as std_TotalWorkingYears,
	min("TotalWorkingYears") as min_TotalWorkingYears,
	percentile_disc(0.25) within group (order by "TotalWorkingYears") as q1_TotalWorkingYears,
	percentile_disc(0.5) within group (order by "TotalWorkingYears") as median_TotalWorkingYears,
	percentile_disc(0.75) within group (order by "TotalWorkingYears") as q3_TotalWorkingYears, 
	max("TotalWorkingYears") as max_TotalWorkingYears,
	round(avg("YearsAtCompany")::numeric,2) as mean_YearsAtCompany, --"YearsAtCompany"
	round(stddev("YearsAtCompany")::numeric,2) as std_YearsAtCompany,
	min("YearsAtCompany") as min_YearsAtCompany,
	percentile_disc(0.25) within group (order by "YearsAtCompany") as q1_YearsAtCompany,
	percentile_disc(0.5) within group (order by "YearsAtCompany") as median_YearsAtCompany,
	percentile_disc(0.75) within group (order by "YearsAtCompany") as q3_YearsAtCompany, 
	max("YearsAtCompany") as max_YearsAtCompany,
	round(avg("YearsInCurrentRole")::numeric,2) as mean_YearsInCurrentRole, --"YearsInCurrentRole"
	round(stddev("YearsInCurrentRole")::numeric,2) as std_YearsInCurrentRole,
	min("YearsInCurrentRole") as min_YearsInCurrentRole,
	percentile_disc(0.25) within group (order by "YearsInCurrentRole") as q1_YearsInCurrentRole,
	percentile_disc(0.5) within group (order by "YearsInCurrentRole") as median_YearsInCurrentRole,
	percentile_disc(0.75) within group (order by "YearsInCurrentRole") as q3_YearsInCurrentRole, 
	max("YearsInCurrentRole") as max_YearsInCurrentRole,
	round(avg("YearsSinceLastPromotion")::numeric,2) as mean_YearsSinceLastPromotion, --"YearsSinceLastPromotion"
	round(stddev("YearsSinceLastPromotion")::numeric,2) as std_YearsSinceLastPromotion,
	min("YearsSinceLastPromotion") as min_YearsSinceLastPromotion,
	percentile_disc(0.25) within group (order by "YearsSinceLastPromotion") as q1_YearsSinceLastPromotion,
	percentile_disc(0.5) within group (order by "YearsSinceLastPromotion") as median_YearsSinceLastPromotion,
	percentile_disc(0.75) within group (order by "YearsSinceLastPromotion") as q3_YearsSinceLastPromotion, 
	max("YearsSinceLastPromotion") as max_YearsSinceLastPromotion,
	round(avg("YearsWithCurrManager")::numeric,2) as mean_YearsWithCurrManager, --"YearsWithCurrManager"
	round(stddev("YearsWithCurrManager")::numeric,2) as std_YearsWithCurrManager,
	min("YearsWithCurrManager") as min_YearsWithCurrManager,
	percentile_disc(0.25) within group (order by "YearsWithCurrManager") as q1_YearsWithCurrManager,
	percentile_disc(0.5) within group (order by "YearsWithCurrManager") as median_YearsWithCurrManager,
	percentile_disc(0.75) within group (order by "YearsWithCurrManager") as q3_YearsWithCurrManager, 
	max("YearsWithCurrManager") as max_YearsWithCurrManager
from vhigh_sat_CTE
where satisfaction = 4

--Departamenty

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Department" ,
	count("Department") as Total
from other_sat_CTE
where satisfaction = 4
group by "Department"

--BusinessTravel

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"BusinessTravel" ,
	count("BusinessTravel") as Total
from other_sat_CTE
where satisfaction = 4
group by "BusinessTravel"

--EducationField
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"EducationField" ,
	count("EducationField") as Total
from other_sat_CTE
where satisfaction = 4
group by "EducationField"

--Gender 

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"Gender" ,
	count("Gender") as Total
from other_sat_CTE
where satisfaction = 4
group by "Gender"

--JobRole
with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"JobRole" ,
	count("JobRole") as Total
from other_sat_CTE
where satisfaction = 4
group by "JobRole"

--MaritalStatus

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"MaritalStatus" ,
	count("MaritalStatus") as Total
from other_sat_CTE
where satisfaction = 4
group by "MaritalStatus"

--OverTime

with other_sat_CTE as (
	select 
		ih.*,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih 
)
select
	"OverTime" ,
	count("OverTime") as Total
from other_sat_CTE
where satisfaction = 4
group by "OverTime"



--OGOLNA SATYSFAKCJA DLA JOB ROLE, DEPARTAMENT 

--Departament
select distinct
ih."Department" 
from ibm_hr ih 

with satdep_CTE as (
	select
		ih. "Department" ,
		ih."MonthlyIncome" ,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih)
select
	"Department" ,
	round(avg("MonthlyIncome")::numeric,2) as avg_MonthlyIncome,
	round(stddev("MonthlyIncome")::numeric,2) as std_monthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome,
	round(avg(satisfaction)::numeric,2) as avg_Satisfaction,
	mode() within group (order by satisfaction) as mode_satisfaction,
	percentile_disc(0.5) within group (order by satisfaction) as median_satisfaction,
	round(stddev(satisfaction)::numeric,2) as std_satisfaction
from satdep_CTE
group by "Department" 

--Job role 

select distinct
	ih."JobRole" 
from ibm_hr ih 
	
with satjobrole_CTE as(
	select
		ih."JobRole" ,
		ih."MonthlyIncome" ,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih) 
select
	"JobRole" ,
	round(avg("MonthlyIncome")::numeric,2) as avg_MonthlyIncome,
	round(stddev("MonthlyIncome")::numeric,2) as std_monthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome,
	round(avg(satisfaction)::numeric,2) as avg_Satisfaction,
	mode() within group (order by satisfaction) as mode_satisfaction,
	percentile_disc(0.5) within group (order by satisfaction) as median_satisfaction,
	round(stddev(satisfaction)::numeric,2) as std_satisfaction
from satjobrole_CTE
group by "JobRole" 
	
with satbustrav_CTE as (
	select 	
		ih."BusinessTravel" ,
		ih."JobRole" ,
		ih."MonthlyIncome" ,
		(ih."EnvironmentSatisfaction"+ih."JobSatisfaction"+ ih."RelationshipSatisfaction")/3 as Satisfaction
	from ibm_hr ih)
select
	"BusinessTravel" ,
	"JobRole",
	round(avg("MonthlyIncome"):: numeric,2) as avg_monthlyincome,
	round(stddev("MonthlyIncome")::numeric,2) as std_monthlyIncome,
	percentile_disc(0.25) within group (order by "MonthlyIncome") as q1_MonthlyIncome,
	percentile_disc(0.5) within group (order by "MonthlyIncome") as median_MonthlyIncome,
	percentile_disc(0.75) within group (order by "MonthlyIncome") as q3_MonthlyIncome,
	round(avg(satisfaction)::numeric,2) as avg_Satisfaction,
	mode() within group (order by satisfaction) as mode_satisfaction,
	percentile_disc(0.5) within group (order by satisfaction) as median_satisfaction,
	round(stddev(satisfaction)::numeric,2) as std_satisfaction
from satbustrav_CTE
group by "BusinessTravel" , "JobRole" 
order by "JobRole" 


 
