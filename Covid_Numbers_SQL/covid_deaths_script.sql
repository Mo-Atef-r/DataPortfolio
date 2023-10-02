select * from deaths;

select location, date, total_cases, new_cases,
       total_deaths, population, continent 
from deaths
where continent is not null
order by 1,2;


-- What is the percentage of deaths w.r.t cases in Egypt?
select date, total_deaths, total_cases,
       (total_deaths/total_cases)*100 as "death_percentage"
from deaths
where location = "Egypt"
and continent is not null
order by date;

-- What is the percentage of cases w.r.t population in Egypt?
-- infection_rate = (total_cases/population)*100
select date, total_cases,population,
       (total_cases/population)*100 as "infection_rate"
from deaths
where location = "Egypt"
and continent is not null
order by date;

-- Which countries have had the highest and lowest infection rates?
select location, population, MAX(total_cases) as "max_infection_count",
       MAX((total_cases/population)*100) as "max_infection_rate"
from deaths
where continent is not null
group by location, population
order by max_infection_rate desc, 1;

-- Which countries have had the highest and lowest death rates?
-- death_rate = (total_deaths/total_cases)*100
select location, population,
       MAX(total_deaths) as total_death_count,
       MAX((total_deaths/population)*100) as total_death_rate
from deaths
where continent is not null
group by location, population
order by total_death_count desc;


-- Which continents have had the highest and lowest death rates?
select continent,
       MAX(total_deaths) as total_death_count
from deaths
where continent is not null
group by continent
order by total_death_count desc;

-- create a view for continent numbers

create view continent_numbers_view as
select continent,
       MAX(total_deaths) as total_death_count
from deaths
where continent is not null
group by continent
order by total_death_count desc;

select * from continent_numbers_view;

-- Global cases and deaths

-- by day
select date,
       sum(new_cases) as "total_cases_global",
       sum(new_deaths) as "total_deaths_global",
       (sum(new_deaths)/sum(new_cases))*100 as "global_death_percentage"
from deaths
where continent is not null
group by `date` 
order by `date`;

-- total
select sum(new_cases) as "total_cases_global",
       sum(new_deaths) as "total_deaths_global",
       (sum(new_deaths)/sum(new_cases))*100 as "global_death_percentage"
from deaths
where continent is not null;

-- create a view to display global numbers
create view global_numbers_view as
select sum(new_cases) as "total_cases_global",
       sum(new_deaths) as "total_deaths_global",
       (sum(new_deaths)/sum(new_cases))*100 as "global_death_percentage"
from deaths
where continent is not null;

select * from global_numbers_view;
