-- This code gives a summary of COVID-19 cases in Asia.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths, SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From covid_deaths_asia dea
where continent is not null 
-- Group By date
order by 1,2
LIMIT 58000;

-- This code gives a list of locations with their respective total death counts in Asia.

Select location, SUM(cast(new_deaths as unsigned)) as TotalDeathCount
From covid_deaths_asia dea
Where continent is not null 
-- and location like '%India%'
Group by location
order by TotalDeathCount desc
LIMIT 58000;

-- This code provides information about the highest infection count and the percentage of population infected for different locations in Asia.
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths_asia dea
Group by Location, Population
order by PercentPopulationInfected desc
LIMIT  58000;

-- This code gives details about the highest infection count and the percentage of population infected for each location on specific dates in Asia.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_deaths_asia dea
where total_cases >= 1
-- Where location like '%India%'
Group by Location, Population, date
order by PercentPopulationInfected desc
LIMIT 58000;






