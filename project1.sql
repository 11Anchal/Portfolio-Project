select * from coviddeaths
where continent is not null;

-- Select Data that we are going to be starting with
select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
where continent is not null
order by 1,2;

-- looking at total case vs totaldeaths
select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) as death_percentage
from coviddeaths
where location like '%states%';


-- looking at total case vs population
-- show what percentage of population got covid
select location,date,total_cases,population,(total_cases/population)*100 as population_percentage
from coviddeaths
where continent is not null
-- where location like '%states%';


-- looking at countries with highest infection rate compared to population

select location, population,max(total_cases) as highestinfectioncount,max((total_cases/population))*100 as percentagepopulationinfected 
from coviddeaths
where continent is not null
group by location,population
order by percentagepopulationinfected desc;

-- showing countries highest death count per population

Select location, max(total_deaths) as totaldeathcount
from coviddeaths
where continent is not null
group by location
order by totaldeathcount desc;

-- LETS BREAK THING DOWN BY CONTINENT
-- showing conntinent with highest death count per population
Select CONTINENT, max(total_deaths) as totaldeathcount
from coviddeaths
where continent is not null
group bY continent
order by totaldeathcount desc;

-- global numbers

select sum(new_cases) as totalcases, sum(new_deaths) as totaldeath,sum(new_deaths)/sum(new_cases)*100 as death_percentage
from coviddeaths
-- where location like '%states%'
where continent is not null
-- group by date;


-- Total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum (new_vaccinations) over(partition by vac.location order by dea.location,dea.date) as rollingpopulationvaccinated,(rollingpopulationvaccinated/population)*100
 from covidvaccinations as vac
join coviddeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by dea.location,dea.date;

-- use CTE
WITH popvsvac
AS
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date) as rollingpopulationvaccinated
,(sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date)/population)*100 as rollingpopulationvaccinatedpercentage
from covidvaccinations as vac
join coviddeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
-- order by dea.location,dea.date;
)
select *, (rollingpopulationvaccinated/population)*100 from popvsvac


-- temp table
-- #percentagepoulationvaccinated
create table percentagepoulationvaccinated
(continent nvarchar(255),location varchar(224),date datetime,population varchar(225),new_vaccination varchar (223),rollingpopulationvaccinated varchar(223));

insert into #percentagepoulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date) as rollingpopulationvaccinated
,(sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date)/population)*100 as rollingpopulationvaccinatedpercentage
from covidvaccinations as vac
join coviddeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

-- CREATE VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE VIEW percentagepoulationvaccinated
AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date) as rollingpopulationvaccinated
,(sum(new_vaccinations) over(partition by vac.location order by dea.location,dea.date)/population)*100 as rollingpopulationvaccinatedpercentage
from covidvaccinations as vac
join coviddeaths as dea
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null