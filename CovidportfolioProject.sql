SELECT 
*
FROM
PortfolioProject..CovidDeaths
WHERE
continent is not null
ORDER BY 
3,4



--SELECT 
--*
--FROM
--PortfolioProject..CovidVaccinations
--ORDER BY 
--3,4

SELECT 
location, date, population,total_cases, new_cases, total_deaths
FROM
PortfolioProject..CovidDeaths
WHERE
continent is not null
ORDER BY 
1,2 

-- Looking at total_cases vs total_death

SELECT 
location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM
PortfolioProject..CovidDeaths
WHERE
location like '%india%' and
continent is not null
ORDER BY 
1,2 

--Looking at total cases vs population

SELECT 
location, date,total_cases, population, (total_cases/population)*100 AS InfectedPercentage
FROM
PortfolioProject..CovidDeaths
--WHERE
--location like '%india%'
WHERE
continent is not null
ORDER BY 
1,2 

--Looking at countries with highest infection rate when compared to population

SELECT 
location, population, MAX(total_cases) as Highest_Infection_Count , MAX((total_deaths/total_cases))*100 AS InfectedPercentage
FROM
PortfolioProject..CovidDeaths
--WHERE
--location like '%india%'
WHERE
continent is not null
GROUP BY
location,population
ORDER BY 
InfectedPercentage DESC


-- showing the countries with the highest death count per population
SELECT 
location ,MAX(cast(total_deaths as int)) AS total_death_count
FROM
PortfolioProject..CovidDeaths
--WHERE
--location like '%india%'
WHERE
continent is not null
GROUP BY
location
ORDER BY 
total_death_count DESC

-- LETS BREAK THINGS DOWN BY CONTINENT

SELECT 
continent , MAX(cast(total_deaths as int)) AS total_death_count
FROM
PortfolioProject..CovidDeaths
--WHERE
--location like '%india%'
WHERE
continent is not null
GROUP BY
continent
ORDER BY 
total_death_count DESC

--Showing the continents with highest death count
SELECT 
location ,MAX(cast(total_deaths as int)) AS total_death_count
FROM
PortfolioProject..CovidDeaths
--WHERE
--location like '%india%'
WHERE
continent is not null
GROUP BY
location
ORDER BY 
total_death_count DESC

--GLOBAL NUMBERS

SELECT 
SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_death , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_perentage
FROM
PortfolioProject..CovidDeaths
WHERE
--location like '%india%' 
continent is not null
--GROUP BY 
--date
ORDER BY 
1,2 


--Looking at total population to the total vacination
SELECT 
dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
2,3

--Use CTE

with PopvsVac (continent, location, date, population,new_vaccinations ,Rollingpeoplevaccinated)
as

(
SELECT 
dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE
dea.continent is not null
--ORDER BY
--2,3
)
SELECT *, (Rollingpeoplevaccinated/population) *100
FROM PopvsVac

--TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT 
dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--WHERE
--dea.continent is not null
--ORDER BY
--2,3

SELECT *, ( Rollingpeoplevaccinated /population) *100
FROM #PercentPopulationVaccinated


--Creating view to store data for later data visualisation

CREATE VIEW Percentpopulationvaccinated2 as

SELECT dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN
PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE
dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM Percentpopulationvaccinated2




