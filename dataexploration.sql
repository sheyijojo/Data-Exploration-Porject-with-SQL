SELECT * 
FROM MyPortfolioProject..CovidDeaths$
WHERE continent is not null
ORDER BY 3,4


SELECT * 
FROM MyPortfolioProject..CovidVaccinations
ORDER BY 3,4

--SELECT data that I will be using.
--looking at total cases VS total deaths
--%of people who died with number of cases


SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM MyPortfolioProject..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2

--looking at total cases vs population
--Shows population in Nigeria that are infected

SELECT location,population, date, total_cases, (total_cases/population)*100 AS CasePercentage
FROM MyPortfolioProject..CovidDeaths$
WHERE location like '%Nigeria%'
ORDER BY 1,2

--looking at couuntries with highest covid infection rate

SELECT location, population, max(total_cases) AS HigestInfectioncount, MAX((total_cases/population))*100 AS PercentagePositionInfected
FROM MyPortfolioProject..CovidDeaths$
--WHERE location like '%Nigeria%'
GROUP BY location,population
ORDER BY PercentagePositionInfected DESC

--countries with highst infection rate

SELECT location, population, max(total_cases) AS HighestIfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM CovidDeaths$
--WHERE location like '%Nigeria%'
where population > 2000000
Group by location, population
order by PercentagePopulationInfected desc

-- Looking at things based on continents
--continents with the highest amount of total deaths
SELECT continent, max(cast (total_deaths as int)) AS totaldeathcount
FROM CovidDeaths$
where continent is null
Group by continent
order by totaldeathcount desc




--showing countires with highest death count per population
SELECT location, max(cast (total_deaths as int)) AS totaldeathcount
FROM CovidDeaths$
where continent is not null
Group by location
order by totaldeathcount desc


--Global NUMBERS

--Tells us about glonal new cases and new deaths and the percentage
SELECT SUM(new_cases) AS new_cases, SUM(cast (new_deaths as int)) as new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS NewDeathPercentage
FROM MyPortfolioProject..CovidDeaths$
--WHERE location like '%Nigeria%'
WHERE continent is not null
--group by date
order by 1,2


--Tells about all the date grouped by the date everyday
SELECT date, SUM(new_cases) AS new_cases, SUM(cast (new_deaths as int)) as new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS NewDeathPercentage
FROM MyPortfolioProject..CovidDeaths$
--WHERE location like '%Nigeria%'
WHERE continent is not null
group by date
--order by 1,2
order by new_cases desc



--Vaccinations

--Total population vs vaccinations
-- new vacinnations here is per day
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM MyPortfolioProject..CovidDeaths$ dea
join MyPortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Rolling count of new_vaccinations
--using window functions and some other thing
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location)
FROM MyPortfolioProject..CovidDeaths$ dea
join MyPortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3