-- 3.1 solution
create table crime_against_women
(
	state_ut varchar(20), district varchar(20), Year int, rape_cases int, kidnap_cases int, dowry_cases int, assault_cases int, insult_modesty_cases int, domestic_cruelty_cases int, girl_trafficking_cases int
);

select * from crime_against_women

-- 3.2 solution
with cte as (
    select state_ut, district, year, rape_cases + kidnap_cases as Sum_of_rape_and_kidnap,
    row_number() over(partition by state_ut, year order by rape_cases+kidnap_cases DESC) as row_num
    from crime_against_st
    where district <> 'TOTAL'
)
select state_ut, district, year, Sum_of_rape_and_kidnap
from cte
where row_num = 1

-- 3.3 solution
with cte as (
    select state_ut, district, year, rape_cases + kidnap_cases as Sum_of_rape_and_kidnap,
    row_number() over(partition by state_ut, year order by rape_cases+kidnap_cases ASC) as row_num
    from crime_against_st
    where district <> 'TOTAL'
)
select state_ut, district, year, Sum_of_rape_and_kidnap
from cte
where row_num = 1

-- 3.4 solution
create table crime_against_ST
(
	state_ut varchar(20), district varchar(20), Year int, murder_cases int, rape_cases int, kidnap_cases int, dacoity_cases int, robery_cases int, arson_cases int, hurt_cases int, pcr_cases int, poa_cases int, other_crimes int
);

select * from crime_against_ST

-- 3.5 solution
select district,  sum(murder_cases) as district_wise_murder_cases
from crime_against_ST
where district <> 'TOTAL'
group by 1
having sum(murder_cases) = (select min(murder_cases) from crime_against_ST)

--3.6 solution
select district, year, sum(murder_cases) as murder_cases_count
from crime_against_ST
group by 1,2
order by 3

-- 3.8.1 solution
create table crime_committed
(
	state_ut varchar(20), district varchar(20), Year int, murder_cases int, attempt_to_murder_cases int, f int, rape_cases int, 
);
	

-- 3.8.3 sql solution
with cte as (
    select state_ut, district, year, rape_cases + kidnap_cases as Sum_of_rape_and_kidnap,
    row_number() over(partition by state_ut, year order by rape_cases+kidnap_cases DESC) as row_num
    from crime_against_st
    where district <> 'TOTAL'
), 
t as (
    select state_ut, district, year, Sum_of_rape_and_kidnap,
    count(*) over(partition by state_ut, district) as district_count
    from cte 
    where row_num = 1
)
select state_ut, district, year, Sum_of_rape_and_kidnap
from t
where district_count > 2
order by 4 DESC
	
	