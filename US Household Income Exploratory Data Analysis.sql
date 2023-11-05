#US Household Income Exploratory Data Analysis

select *
from us_household_income;

select*
from us_household_income_statistics;

#State with highest land
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by 2 desc;

#State with most lakes and streams
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by 3 desc;

#Top 10 largest State by land
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by 2 desc
limit 10;

#Top 10 largest State by water
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by 3 desc
limit 10;

#Combining two tables excluding dirty data where mean is 0
select *
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0;


select ui.State_Name, County, `type`, `Primary`, Mean, Median 
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0;

#Top 5 lower income state by average income
select ui.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0
Group by ui.State_Name
order by 2
limit 5;

#Top 5 higher income state by average income
select ui.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0
Group by ui.State_Name
order by 2 desc
limit 5;

#Top 10 highest state by median income 
select ui.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0
Group by ui.State_Name
order by 3 desc
limit 10;

#Top 10 lowest state by median income 
select ui.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0
Group by ui.State_Name
order by 3 asc
limit 10;

select `Type`, count(`Type`), round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
where mean<>0
Group by `Type`
having count(`Type`)>100
order by 4 desc
limit 50;


select *
from us_household_income
where Type='Community';

select ui.State_Name, City, Round(avg(mean),1), Round(avg(Median),1)
from us_household_income as ui
inner join us_household_income_statistics as uis
	on ui.id=uis.id
group by ui.State_Name,City
order by 3 desc
limit 10;


