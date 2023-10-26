#Getting the whole Data
SELECT *
FROM `halogen-parsec-395505.database_Covid.Deaths` 
ORDER BY 3,4;

#Total Death count per location
SELECT 
location,MAX(total_deaths) As TotalDeathCount
FROM `halogen-parsec-395505.database_Covid.Deaths` 
GROUP BY location
ORDER BY TotalDeathCount desc;
# grouping by continent
SELECT 
location,MAX(total_deaths) As TotalDeathCount
FROM `halogen-parsec-395505.database_Covid.Deaths` 
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;
# grouping by the general grouping
SELECT 
location,MAX(total_deaths) As TotalDeathCount
FROM `halogen-parsec-395505.database_Covid.Deaths` 
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc;
#Death Percentage
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM `halogen-parsec-395505.database_Covid.Deaths` 
WHERE continent is not null
ORDER BY 1,2;

# Population Infected by Covid
SELECT location,population, MAX(total_cases) As HighestInfectionCount, MAX((total_cases/population))*100 As PercentagePopulationInfected
FROM `halogen-parsec-395505.database_Covid.Deaths` 
GROUP BY location, population
ORDER BY 1,2;

SELECT 
location,population, MAX(total_cases) As HighestInfectionCount, MAX((total_cases/population))*100 As PercentagePopulationInfected
FROM `halogen-parsec-395505.database_Covid.Deaths` 
GROUP BY location, population
ORDER BY PercentagePopulationInfected desc;

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
FROM `halogen-parsec-395505.database_Covid.Deaths` 
WHERE continent is not null
ORDER BY 1,2;

# Getting the vacinations Data
SELECT *
FROM `halogen-parsec-395505.database_Covid.Vacinations`
ORDER BY 1,2;

# Using the join statements to join the two datasets
SELECT *
FROM `halogen-parsec-395505.database_Covid.Deaths` dea
JOIN `halogen-parsec-395505.database_Covid.Vacinations` vac
 ON dea.location = vac.location
 AND dea.date = vac.date;

# Looking at the total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) As
 PeopleVaccinated
FROM `halogen-parsec-395505.database_Covid.Deaths` dea
JOIN `halogen-parsec-395505.database_Covid.Vacinations` vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

# Getting to use CTE
WITH RECURSIVE 
PopVsVac AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) As
 PeopleVaccinated
FROM `halogen-parsec-395505.database_Covid.Deaths` dea
JOIN `halogen-parsec-395505.database_Covid.Vacinations` vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (PeopleVaccinated/population)*100 As RollingPeopleVaccinated
FROM PopVsVac;

