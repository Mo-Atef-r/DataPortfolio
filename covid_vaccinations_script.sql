select * from vaccinations;

-- join the two tables on location and date

select *
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date;


-- New vaccinations vs population

select deaths.location, deaths.date,
       deaths.population, vaccinations.new_vaccinations 
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
order by 1,2;

-- Number of vaccinations vs population
select deaths.location, deaths.population,
       SUM(vaccinations.new_vaccinations) as "vaccinations_sum"
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
group by deaths.location, deaths.population
order by 3 DESC;

-- Rolling Count of Vaccinations Partitioned by Location

select deaths.location, deaths.date, deaths.population,
       vaccinations.new_vaccinations,
       SUM(vaccinations.new_vaccinations)
       over (partition by deaths.location order by deaths.date) as "vacc_rolling_count"
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null;

-- Use a CTE to get the rolling percentages of vaccinations

with
cte1 (location, date, population, new_vaccinations, vacc_rolling_count)
as
(
select deaths.location, deaths.date, deaths.population,
       vaccinations.new_vaccinations,
       SUM(vaccinations.new_vaccinations)
       over (partition by deaths.location order by deaths.date) as vacc_rolling_count
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null
)
select *, (vacc_rolling_count/population)*100 as "vacc_percentage"
from cte1
order by location, date;
       


-- rolling percentages with a temp table
drop table if exists rolling_percentages_temp;
create temporary table rolling_percentages_temp(
    location varchar(50),
    date varchar(50),
    population bigint,
    new_vaccinations int,
    vacc_rolling_count int
);

insert into rolling_percentages_temp
select deaths.location, deaths.date, deaths.population,
       vaccinations.new_vaccinations,
       SUM(vaccinations.new_vaccinations)
       over (partition by deaths.location order by deaths.date) as vacc_rolling_count
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null;

select *,(vacc_rolling_count/population)*100 as "vacc_percentage"
from rolling_percentages_temp
order by location,date;


-- Creating a view to display the rolling counts

create view rolling_percentages_view as
select deaths.location, deaths.date, deaths.population,
       vaccinations.new_vaccinations,
       SUM(vaccinations.new_vaccinations)
       over (partition by deaths.location order by deaths.date) as vacc_rolling_count
from deaths inner join vaccinations
on deaths.location = vaccinations.location
and deaths.date = vaccinations.date
where deaths.continent is not null;

select * from rolling_percentages_view;