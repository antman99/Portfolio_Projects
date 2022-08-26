--Project exploring government data about covid-19
--Skills that were used in this project include Joins, Temp tables, Creation of views, conversion of data, and Sql window function.

--First, always check to make sure data imported properly

Select *
From Covid_19_project.dbo.CovidDeaths$
Order by 3, 4;

Select *
From Covid_19_project.dbo.CovidVaccinations$
Order by 3,4;

-- Select Useful Data 
-- Query shows likelihood of dying from covid

Select location, date, total_cases, total_deaths
From Covid_19_project.dbo.CovidDeaths$
Order by 1, 2;

-- Total cases vs Total deaths
-- Query shows likelihood of dying from covid in the United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Covid_19_project.dbo.CovidDeaths$
Where location like '%states%'
Order by 1, 2;

-- Total Cases vs Population
-- Query shows what percentage of the population has gotten covid in United States

Select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Covid_19_project.dbo.CovidDeaths$
Where location like '%states%'
Order by 1, 2;

-- Countries with Highest Infection Rate compared to Population

Select location, population, date, Max(total_cases) as HighestInfectionRate,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_19_project.dbo.CovidDeaths$
Group by location, population, date
Order by location, date desc, PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population

Select Location, Max(cast(Total_deaths as bigint)) as TotalDeathCount
From Covid_19_project.dbo.CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Broken Down by continent
-- Showing contintents with the highest death count per population
Select location, Sum(cast(new_deaths as bigint)) as TotalDeathCount
From Covid_19_project.dbo.CovidDeaths$
Where continent is null And location not in ('Upper middle income' , 'High income' , 'Lower middle income' , 'Low income', 'World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_19_project.dbo.CovidDeaths$
where continent is not null 
order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(bigint, vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingpeopleVaccinated
From Covid_19_project.dbo.CovidVaccinations$ vac
Join Covid_19_project.dbo.CovidDeaths$ dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

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
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_19_project.dbo.CovidVaccinations$ vac
Join Covid_19_project.dbo.CovidDeaths$ dea
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
