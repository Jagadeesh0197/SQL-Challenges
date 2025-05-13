-- 1. SELECT basics --------------------------------------------
  -- 1. Population of Germany
SELECT population FROM world
WHERE name='Germany';

  -- 2. name and population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
WHERE name IN ('Sweden','Norway','Denmark');

  -- 3. Countries and area for area BETWEEN 200000 AND 250000
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;

-- 2. SELECT from WORLD ----------------------------------------
  -- 1. Data Exploring
SELECT name, continent, population FROM world;

  -- 2. Countries(name) with population >= 200000000
SELECT name FROM world
WHERE population >= 200000000;

  -- 3. query name, per capita GDP with population >= 200000000 [per capita GDP  = GDP/population] ]
SELECT name, gdp/population AS per_capita_GDP
FROM world
WHERE population >= 200000000;

  -- 4. Population in millions
SELECT name, population/1000000
FROM world
WHERE continent = 'South America';

  -- 5. name and population in ('France','Germany','Italy')
SELECT name, population
FROM world
WHERE name IN ('France','Germany','Italy');

  -- 6. Country names that state with 'UNITED'
SELECT name FROM world
WHERE name LIKE 'United%';

  -- 7. Big interms of area or population
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000;

  -- 8. Can be big in area or population but not in both 
SELECT name, population, area
FROM world
WHERE (area > 3000000 or population > 250000000)
  AND NOT (area > 3000000 AND population > 250000000);

  -- 9. shows population in millions and GDP in billions [ROUND is used to round of to any precision. for more (https://sqlzoo.net/wiki/ROUND)]
  -- MYSQL answer 
SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000,2)
FROM world
WHERE continent = 'South America';

  -- 9. MSSQL answer [CAST used to convert the datatype]
SELECT name, ROUND(CAST(population AS DECIMAL)/1000000, 2), ROUND(CAST(gdp AS DECIMAL)/1000000000,2)
FROM world
WHERE continent = 'South America';

  -- 10. per capita GDP with atleast 1 trillion 
  -- Note : [ROUND(555, -1) = 550, ROUND(555, -2) = 500] tailing values will be rounded off.
SELECT name, ROUND(gdp/population,-3)
FROM world
WHERE gdp>= 1000000000000;
