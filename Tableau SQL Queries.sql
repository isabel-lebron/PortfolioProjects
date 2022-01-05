
-- Tableau Queries

-- 1. 
-- Below is the number of total cases vs total deaths globally
Select 
    SUM(CONVERT(float,new_cases)) as total_cases, 
    SUM(CONVERT(float,new_deaths)) as total_deaths, 
    CAST(SUM(new_deaths) as float)/CAST(SUM(new_cases) as float)*100 as DeathPercent
From PortfolioProjects..CovidDeaths
where continent is not null 
order by 1,2

-- 2. 
-- Showing the continents with the highest death count 
Select 
    location, 
    SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null 
And location not in ('World', 'European Union', 'International')
And location not like '%income%'
Group by location
order by TotalDeathCount desc

-- 3.
-- Looking at countries with highest infection rate compared to population
Select 
    Location, 
    Population, 
    MAX(total_cases) as HighestInfectionCount,  
    CAST(MAX(total_cases) as float)/CAST(MAX(population) as float) *100 as PopulationPercent
From PortfolioProjects..CovidDeaths
Group by Location, Population
order by PopulationPercent desc

-- 4.
Select 
    Location, 
    Population, 
    date,
    MAX(total_cases) as HighestInfectionCount,  
    CAST(MAX(total_cases) as float)/CAST(MAX(population) as float) *100 as PopulationPercent
From PortfolioProjects..CovidDeaths
Group by Location, Population, date
order by PopulationPercent desc