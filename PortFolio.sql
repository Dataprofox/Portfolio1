

Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject..CovidVacinations
--Order by 3,4

--Select Data that i am going to be using

Select Location, Date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2


--Looking at the total cases vs total deaths
--with where clause added your state shows the likelihood of dying if you contract covid in your country

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Where continent is not null
Order By 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid

Select Location, Date, Population, total_cases, (total_deaths/Population)*100 As PercentPopulation
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Order By 1,2

--Looking at countries with highest Infection Rates compared to population

Select Location, Population, Max(total_cases) As HighestInfectionCount, Max((total_cases/Population))*100 As PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Group By Location, Population
Order By PercentPopulationInfected Desc

--Showing Countries with highest Deat Count Per Population

Select Location, Max(Cast(total_Deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Where continent is not null
Group By Location
Order By TotalDeathCount Desc



--Lets Break things down by Continent


Select continent, Max(Cast(total_Deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Where continent is not null
Group By continent
Order By TotalDeathCount Desc

---Showing the continent with highest death count Per population

Select continent, Max(Cast(total_Deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Where continent is not null
Group By continent
Order By TotalDeathCount Desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(new_cases)*100 As DeathPercentage
---- total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Eth%'
Where continent is not null
--Group By Date
Order By 1,2



---Looking at Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(convert(bigint, vac.new_vaccinations))
OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
---(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
Join PortfolioProject..CovidVacinations  vac
  On dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
  order by 2,3

  --UDE CTE

  With Popvsvac (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
  as 
  (
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(convert(bigint, vac.new_vaccinations))
OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
---, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
Join PortfolioProject..CovidVacinations  vac
  On dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
  --order by 2,3
  )

  Select *, (RollingPeopleVaccinated/population)*100
  From Popvsvac 

  ---TEMP TABLE

  Drop Table if exists #Percentpopulationvaccinated 
  Create table #PercentpopulationVaccinated
        (
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	new_vaccinations numeric,
	Rollingpeoplevacinated numeric
	   )


  Insert into #PercentpopulationVaccinated
  Select dea.continent, dea.location, dea.date, dea.population, 
  vac.new_vaccinations, SUM(convert(bigint, vac.new_vaccinations))
  OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
Join PortfolioProject..CovidVacinations  vac
  On dea.location = vac.location
  and dea.date = vac.date
--Where dea.continent is not null
  --order by 2,3

  Select *,(RollingPeopleVaccinated/population)*100
  From #PercentpopulationVaccinated



  ---Creating View to store data for later visualization

  Create View Percentpopulationvaccinated as
  Select dea.continent, dea.location, dea.date, dea.population, 
  vac.new_vaccinations, SUM(convert(bigint, vac.new_vaccinations))
  OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
Join PortfolioProject..CovidVacinations  vac
  On dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *
From Percentpopulationvaccinated













