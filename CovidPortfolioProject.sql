Select *
From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..Covidvaccinations
--order by 3,4

--selcet data that we are going to use 

Select location, date, total_cases, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--looking at total deaths and total cases

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

--looking at total cases and population as percentage 

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%States%'
order by 1,2

--looking at countries with hieghest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%lanka%'
Group by Location, Population
order by PercentPopulationInfected desc

--Countries with highest death count per population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%lanka%'
Group by Location, Population
order by PercentPopulationInfected desc

Select continent,  MAX (cast (Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%lanka%'
where continent is not null 
Group by continent
order by TotalDeathCount desc

Select location,  MAX (cast (Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%lanka%'
where continent is  null 
Group by location
order by TotalDeathCount desc


--Showing continents with highest death count


Select continent,  MAX (cast (Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%lanka%'
where continent is not null 
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select date, SUM (new_cases), SUM(cast(new_deaths as int)), SUM(CAST(new_deaths as int))/SUM(new_cases)* 100 as percentage 
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by date
order by 1,2

Select SUM (new_cases) as Total_cases , SUM(cast(new_deaths as int)) as Total_Deaths , SUM(CAST(new_deaths as int))/SUM(new_cases)* 100 as percentage 
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
--Group by date
order by 1,2

--looking at total population vs vaccination 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
Where dea.continent is not null
order by 2,3

--new vaccinatios per day

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP Table

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
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 




Select*
From Portfolioproject..CovidDeaths dea
Join Portfolioproject..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date















