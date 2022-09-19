Select * from PortfolioProject..CovidDeaths 
where continent is not null
order by 3,4

-- Select * from PortfolioProject..CovidVaccinations 
--order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths 
order by 1,2

--Looking at the toal cases vs total deaths
--Show what percentage of poplulation got Covid


Select Location, date, population, total_cases,(total_cases/population)*100 as DeathPercentage
 from PortfolioProject..CovidDeaths 
 where location like '%India%'
 order by 1,2



--Looking at Countries with highest rate compared in population

Select Location, population, MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentPopulationInfected
 from PortfolioProject..CovidDeaths 
 --where location like '%India%'
 Group by Location, Population
 order by PercentPopulationInfected desc



 --Showing the countries with highest death count per population

 Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths 
 --where location like '%state%'
 where continent is not null
 Group by Location
 order by TotalDeathCount desc
 



 --Breaking things by continent

  Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
 from PortfolioProject..CovidDeaths 
 --where location like '%state%'
 where continent is not null
 Group by continent
 order by TotalDeathCount desc

 

 --Global Numbers

 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as toal_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Percentage
 from PortfolioProject..CovidDeaths 
 where continent is not null
 order by 1,2



Select *
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date



--Looking at Total Population Vs Vaccination

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 1,2,3

	Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
	, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 1,2,3




	--USE CTE

	with PopvsVac(Continent , Location , Date , Population ,New_Vaccinations, RollingPeopleVaccinated)
	as
	(
		Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
	, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 1,2,3
	)
	Select *,(RollingPeopleVaccinated/Population)*100
	from PopvsVac



	--TEMP Table

	Create table #PercentPopulationVaccinated3
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccination numeric,
	RollingPeopleVaccinated numeric
	)

	Insert into #PercentPopulationVaccinated3
	Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
	, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 1,2,3

	Select *, (RollingPeopleVaccinated/Population)*100
	from #PercentPopulationVaccinated3







