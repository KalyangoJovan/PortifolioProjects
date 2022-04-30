select*
From PortifolioProject..Coviddeaths
order by 2,3

--select*
--From PortifolioProject..Covidvaccis
--order by 2,3

-- selecting data to be used in future exploration

Select location, date, total_cases, new_cases, total_deaths, population
From PortifolioProject..Coviddeaths
order by 1,2

-- total case vs total deaths
-- what is the percentage of people  died who had covid
-- can be seen as chance of dying covid if get in a partcular country, on a particular day
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathProportion
From PortifolioProject..Coviddeaths
where location like '%uganda%' --  this refer to Uganda, 
order by 1,2

-- italy 
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathProportion
From PortifolioProject..Coviddeaths
where location like '%Italy%' --  this refer to Italy, 
order by 1,2

-- this is the likelihood of dying covid in a particular country
-- all countries 
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathProportion
From PortifolioProject..Coviddeaths
--where location like '%Italy%' --   
order by 1,2



-- total  cases vs population 
-- this is the proportion of people who has contracted Covid 
Select location, date,population, total_cases, (total_deaths/population)*100 as covidInfectedProportion
From PortifolioProject..Coviddeaths
where location like '%Italy%' --  this refer to Italy, 
order by 1,2

-- all contries 
Select location, date,population, total_cases, (total_deaths/population)*100 as covidInfectedProportion
From PortifolioProject..Coviddeaths
--where location like '%Italy%' -- all countries 
order by 1,2


-- the infection rate by contry and their population ( highest) 
Select location,population, MAX(total_cases) AS HighestInfectedCount, Max((total_deaths/population))*100 as covidInfectedProportion
From PortifolioProject..Coviddeaths
--where location like '%Italy%' -- all countries 
group by location, population
order by covidInfectedProportion desc

-- how many people died, highest death count per population 

Select location, MAX(cast(total_deaths as int)) AS totalDeathsCount
From PortifolioProject..Coviddeaths
where continent is null -- like '%Italy%' -- all countries 
group by location
order by totalDeathsCount  desc

-- continent level 
Select continent, MAX(cast(total_deaths as int)) AS totalDeathsCount
From PortifolioProject..Coviddeaths
where continent is  not null -- like '%Italy%' -- all countries 
group by continent
order by totalDeathsCount  desc


-- display continent with daily death count golobally

Select SUM(new_cases) as DailyCases, SUM(cast(new_deaths as int)) as DailyDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DailyDeathPercent
From PortifolioProject..Coviddeaths
where continent is  not null --  
--group by date
order by 1,2 

-- VACCINE JOINED TO DEATH

select dea.continent, dea.location, dea.population, vac.new_vaccinations
From PortifolioProject..Coviddeaths dea 
 join PortifolioProject..Covidvaccis vac
 on dea.location = vac.location
 and dea.date = vac.date



 where dea.continent is not null
 

 --TEMP TABLE
 --drop table if exists
 Create Table #VaccinatedPeople
 (
 Continent nvarchar(225), 
 location nvarchar(225), 
 population numeric,
 New_vaccinations numeric
 )
 Insert into #VaccinatedPeople
select dea.continent, dea.location, dea.population, vac.new_vaccinations
From PortifolioProject..Coviddeaths dea 
 join PortifolioProject..Covidvaccis vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 
 select*
 From #VaccinatedPeople

 -- creating views 
 Create view VaccinatedPeople as 
 select dea.continent, dea.location, dea.population, vac.new_vaccinations
From PortifolioProject..Coviddeaths dea 
 join PortifolioProject..Covidvaccis vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null


 Create view ContinentDeaths as 
 Select continent, MAX(cast(total_deaths as int)) AS totalDeathsCount
From PortifolioProject..Coviddeaths
where continent is  not null -- like '%Italy%' -- all countries 
group by continent
--order by totalDeathsCount  desc
select*
From ContinentDeaths
