/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Aggregate Functions, Creating Views, Converting Data Types

*/

USE portfolio_project;
-- Select Data that we are going to be starting with
SELECT 
    *
FROM
    covid_deaths_asia
WHERE
    continent IS NOT NULL
ORDER BY 3 , 4;

-- Shows Total Cases vs Total Deaths
SELECT 
    Location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths_asia
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- Shows Total Cases vs Population
SELECT 
    Location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    covid_deaths_asia
WHERE
    location LIKE '%India%'
        AND continent IS NOT NULL
ORDER BY 1 , 2;

-- Shows Countries with Highest Infection Rate compared to their Population
SELECT 
    Location,
    date,
    Population,
    total_cases,
    (total_cases / population) * 100 AS PercentPopulationInfected
FROM
    covid_deaths_asia
ORDER BY 1 , 2;

-- Shows Countries with Highest Death Count per Population
SELECT 
    Location,
    Population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    covid_deaths_asia
GROUP BY Location , Population
ORDER BY PercentPopulationInfected DESC;

-- Shows Total death count country wise
SELECT 
    Location,
    MAX(CAST(Total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    covid_deaths_asia
WHERE
    continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT 
    location,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths,
    SUM(CAST(new_deaths AS UNSIGNED)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM
    covid_deaths_asia
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2;

-- Shows the percentage of population infected, country-wise
SELECT 
    continent,
    location,
    MAX(total_cases) AS highestinfectioncount,
    population,
    MAX(total_cases / population) * 100 AS percentpopinfected
FROM
    covid_deaths_asia
GROUP BY location , population
ORDER BY percentpopinfected DESC; 

-- Total Population vs Vaccinations showing Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM covid_deaths_asia dea
Join covid_vaccine_asia vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query
WITH popvsvac (location, date, population, new_vaccinations,   RollingPeopleVaccinated) AS 
(
   SELECT 
     dea.location, 
        dea.date, 
         dea.population,
        vac.new_vaccinations, 
         SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS   RollingPeopleVaccinated
     FROM 
         covid_deaths_asia dea
     JOIN 
         covid_vaccine_asia vac 
        ON dea.location = vac.location 
         AND dea.date = vac.date
 ) 
 SELECT 
    *, 
   (  RollingPeopleVaccinated / population) * 100 AS vaccination_rate
FROM 
   popvsvac;
   
--  Using Temp Table to perform Calculation on Partition By in previous query
Create Table PercentPopulationVaccinated
(
continent varchar(255),
Location varchar(255),
Date datetime,
Population BIGINT,
New_vaccinations BIGINT,
RollingPeopleVaccinated BIGINT);
Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From covid_deaths_asia dea
Join covid_vaccine_asia vac 
	On dea.location = vac.location
	and dea.date = vac.date;

SELECT 
    *, (RollingPeopleVaccinated / Population) * 100
FROM
    PercentPopulationVaccinated;

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From covid_deaths_asia dea
Join covid_vaccine_asia vac 
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;




  -- Tip-> In order to run the 12th code, you have to drop the table first.
   



