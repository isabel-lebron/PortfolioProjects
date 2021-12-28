
-- Data Exploration Using SQL – Covid Data

-- Let's preview our data and make sure it was imported correctly:
-- CovidDeaths table
Select *
From PortfolioProjects..CovidDeaths;

-- CovidVaccinations table
Select *
From PortfolioProjects..CovidVaccinations;

-- Now, let's select the data we'll be using.
Select 
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
From PortfolioProjects..CovidDeaths
Where continent is not null
Order by 1,2;

-- Looking at total cases vs. total deaths, we can see the likelihood of dying if you contract covid for each country
Select 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST(total_deaths as float)/CAST(total_cases as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Order by 1,2;

-- Let's store the above information for later: total cases vs. total deaths for each country
CREATE VIEW CountryDeathRate as 
Select
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST(total_deaths as float)/CAST(total_cases as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null;

Select *
From PortfolioProjects.dbo.CountryDeathRate
Order by 1,2;

-- Expanding on above, let's look at the likelihood of dying if you contract covid in the U.S. 
-- This will show us the death rates as time goes on
Select
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST(total_deaths as float)/CAST(total_cases as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where location = 'United States'
Order by 1,2;

-- Ordering the above slightly, we will see when the U.S. had the highest likelihood of dying if you contract covid
Select
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST(total_deaths as float)/CAST(total_cases as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where location = 'United States'
Order by 5 desc;

-- Looking at total cases vs population for each country
-- Shows what percentage of population got covid
Select 
    location, 
    date, 
    population, 
    total_cases, 
    CAST(total_cases as float)/CAST(population as float)*100 as PopulationPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Order by 1,2;

-- Let's store the above information for later: total cases vs population for each country
CREATE VIEW CountryPopulationPercentage as
Select 
    location, 
    date, 
    population, 
    total_cases, 
    CAST(total_cases as float)/CAST(population as float)*100 as PopulationPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null;

Select *
From PortfolioProjects.dbo.CountryPopulationPercentage
Order by 1,2;

-- Looking at countries with highest infection rate compared to population 
Select 
    location, 
    population, 
    MAX(total_cases) as HighestInfectionCount, 
    CAST(MAX(total_cases) as float)/CAST(MAX(population) as float) *100 as PopulationPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by location, population
Order by PopulationPercent desc;

-- Let's store the above information for later: countries with highest infection rate compared to population 
CREATE VIEW CountryHighestInfectionRate as
Select 
    location, 
    population, 
    MAX(total_cases) as HighestInfectionCount, 
    CAST(MAX(total_cases) as float)/CAST(MAX(population) as float) *100 as PopulationPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by location, population;

Select *
From PortfolioProjects.dbo.CountryHighestInfectionRate
Order by PopulationPercent desc;

-- Looking at countries with highest death count per population 
Select 
    location, 
    MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc;

-- Let's store the above information for later: countries with highest death count per population 
CREATE VIEW CountryHighestDeathCount as
Select 
    location, 
    MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by location;

Select *
From PortfolioProjects.dbo.CountryHighestDeathCount
Order by TotalDeathCount desc;

-- BREAKING DOWN BY CONTINENT 
-- Showing the continents with the highest death count 
Select 
    continent, 
    MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc;

-- Let's store the above information for later: continents with the highest death count 
CREATE VIEW ContinentHighestDeathCount as
Select 
    continent, 
    MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Group by continent;

Select *
From PortfolioProjects.dbo.ContinentHighestDeathCount
Order by TotalDeathCount desc;


-- GLOBAL NUMBERS
Select 
    SUM(new_cases) as total_cases, 
    SUM(new_deaths) as total_deaths, 
    CAST(SUM(new_deaths) as float)/CAST(SUM(new_cases) as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null
Order by 1,2;

-- Let's store the above information for later:
CREATE VIEW GlobalDeaths as
Select 
    SUM(new_cases) as total_cases, 
    SUM(new_deaths) as total_deaths, 
    CAST(SUM(new_deaths) as float)/CAST(SUM(new_cases) as float)*100 as DeathPercent
From PortfolioProjects.dbo.CovidDeaths
Where continent is not null;

Select *
From PortfolioProjects.dbo.GlobalDeaths
Order by 1,2;


-- COVID VACCINATIONS
-- In order to use data from both tables, CovidDeaths and CovidVaccinations, we need to use Join
-- Looking at Total Populations vs. Vaccinations 
Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vax.new_vaccinations,
    SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxxed
    --,(RollingPeopleVaxxed/population)*100 as RollingVaxPercent
    -- The code above won't work. We will look at how to do this next.  
From PortfolioProjects.dbo.CovidDeaths dea
Join  PortfolioProjects.dbo.CovidVaccinations vax
    On dea.location = vax.location
    And dea.date = vax.date
Where dea.continent is not null
Order by 2,3;

-- We can get the rolling percentage of the population that is vaccinated a few different ways:
-- 1. Using CTE
WITH PopvsVax as
(
Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vax.new_vaccinations,
    SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxxed
From PortfolioProjects.dbo.CovidDeaths dea
Join  PortfolioProjects.dbo.CovidVaccinations vax
    On dea.location = vax.location
    And dea.date = vax.date
Where dea.continent is not null
)
Select *, 
    CAST(RollingPeopleVaxxed as float)/CAST(Population as float)*100 as RollingVaxPercent
From PopvsVax
Order by 2,3;


-- 2. Using Temp Tables
CREATE TABLE PercentPopulationVaxxed
(
    continent nvarchar(255),
    location nvarchar(255),
    Date datetime,
    Population numeric,
    new_vaccinations numeric,
    RollingPeopleVaxxed numeric
)
Insert into PercentPopulationVaxxed
Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vax.new_vaccinations,
    SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxxed
From PortfolioProjects.dbo.CovidDeaths dea
Join  PortfolioProjects.dbo.CovidVaccinations vax
    On dea.location = vax.location
    And dea.date = vax.date
Where dea.continent is not null

Select *, 
    CAST(RollingPeopleVaxxed as float)/CAST(Population as float)*100 as RollingVaxPercent
From PercentPopulationVaxxed
Order by 2,3;

-- 3. We can also choose to Create View, like we've already done with other data, to store it for visualizations later on 
CREATE VIEW PercentPopulationVax as
Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vax.new_vaccinations,
    SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxxed
From PortfolioProjects.dbo.CovidDeaths dea
Join  PortfolioProjects.dbo.CovidVaccinations vax
    On dea.location = vax.location
    And dea.date = vax.date
Where dea.continent is not null

Select *, 
    CAST(RollingPeopleVaxxed as float)/CAST(Population as float)*100 as RollingVaxPercent
From PortfolioProjects.dbo.PercentPopulationVax
Order by 2,3;









