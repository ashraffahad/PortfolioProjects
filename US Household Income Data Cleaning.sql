#US Household Income Data Cleaning
use us_household_income_project;

select *
from us_household_income;

select * 
from us_household_income_statistics;

ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;


#Checking whether there is any duplicates
select id, count(id)
from us_household_income
group by id
having count(id)>1;

#Detected duplicates and trying to locate them in table
select *
from (
select row_id, 
id,
row_number() over(partition by id order by id) as row_num
from us_household_income) as row_num_table
where row_num>1;

#Deleting duplicates 
delete from us_household_income
where row_id in (
	select row_id
	from (
		select row_id, 
		id,
		row_number() over(partition by id order by id) as row_num
		from us_household_income) as row_num_table
	where row_num>1);


#Checking whether there is any duplicates, luckily there is no duplicates in this table
select id, count(id)
from us_household_income_statistics
group by id
having count(id)>1;

select distinct State_Name
from us_household_income
order by State_Name;

update us_household_income
set State_Name='Georgia'
where state_name='georia';

update us_household_income
set State_Name='Alabama'
where state_name='alabama';

update us_household_income
set State_Name=Upper(State_Name);

select *
from us_household_income;

select distinct(State_ab), State_Name
from us_household_income
order by 1;

select *
from us_household_income
where County='Autauga County'
;

update us_household_income
set place='Autaugaville'
where County='Autauga County' and
city='Vinemont';

select type, count(type)
from us_household_income
group by type
;

update us_household_income
set type='Borough'
where type='Boroughs';

select distinct AWater, ALand
from us_household_income
where (AWater=0 or AWater='' or AWater is null)
and (ALand=0 or ALand='' or ALand is null);

select distinct  ALand
from us_household_income
where ALand=0 or ALand='' or ALand is null;
