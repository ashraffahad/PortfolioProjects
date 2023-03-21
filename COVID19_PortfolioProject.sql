
select * from CovidDeaths
order by 3, 4

--select * from CovidVaccinations
--order by 3, 4

--Data that will be used in this project
select location,date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1, 2

--looking at total_cases vs total_deaths
select location,date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as DeathsPercentage
from CovidDeaths
where location like '%states'
order by 1, 2

--looking at total_cases vs population 
select location, date, total_cases, population, ((total_cases/population)*100) as InfectionRate
from CovidDeaths
where location like '%states' and continent is not null
order by 1, 2

--looking countries with Highest Infection Rate vs Population 
select location, population, max(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as 
PercentPopulationInfection
from CovidDeaths
where continent is not null
group by population, location 
--where location like '%states'
order by PercentPopulationInfection desc

--Let's dive into Continents

--showing continents with highest death count per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
select  sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases)*100)
as DeathsPercentage
from CovidDeaths
--where location like '%states'
where continent is not null
--group by date
order by 1, 2


--looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths as dea
Join ProjectPortfolio..CovidVaccinations as vac
  On dea.location=vac.location and
  dea.date=vac.date
  where dea.continent is not null 
  order by  2, 3

--USE CTE
  with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
  as
  (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths as dea
Join ProjectPortfolio..CovidVaccinations as vac
  On dea.location=vac.location and
  dea.date=vac.date
  where dea.continent is not null 
  --order by  2, 3
  )

  select *, (RollingPeopleVaccinated/population)*100
  from PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select * from PercentPopulationVaccinated