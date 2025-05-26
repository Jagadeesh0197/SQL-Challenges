-------------------------------------------------- 1. SELECT basics ---------------------------------------------------------
  -- 1. Population of Germany
SELECT population FROM world
WHERE name='Germany';

  -- 2. name and population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
WHERE name IN ('Sweden','Norway','Denmark');

  -- 3. Countries and area for area BETWEEN 200000 AND 250000
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;

------------------------------------------------ 2. SELECT from WORLD -----------------------------------------------------
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
-------------------------------------------------3. SELECT from Nobel Tutorial --------------------------------------------

-- 1. Winners from 1950 
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

-- 2. 1962 Literature
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'

-- 3. Albert Einstein 
SELECT yr, subject
  FROM nobel
WHERE winner='Albert Einstein'

--4. Recent Peace Prizes [in peace subject and after 2000]
SELECT winner
FROM nobel
WHERE subject = 'peace' AND yr >= 2000;

--5. Literature in the 1980's [between 1980 to 1989]
SELECT
 *
FROM
 nobel
WHERE subject  = 'literature' AND
 yr BETWEEN 1980 AND 1989

--6. Only Presidents [winners in]
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt',
'Thomas Woodrow Wilson',
'Jimmy Carter',
'Barack Obama')

--7. John [first name starts with John]
SELECT
 winner
FROM
 nobel
WHERE winner LIKE 'John%'

--8. Chemistry and Physics from different years[1980-physics, 1984-chemistry] 
SELECT *
FROM nobel
WHERE (subject = 'physics' AND yr = 1980)
OR
(subject = 'chemistry' AND yr = 1984)

--9. Exclude Chemists and Medics subjects and include in the year 1980
SELECT *
FROM nobel
WHERE yr = 1980 AND subject NOT IN ('chemistry','medicine')

-- 10 Early Medicine, Late Literature [Medicine before 1910 or Literature after 2004]
SELECT *
FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910)
OR
(subject = 'Literature' AND yr >= 2004)

-----------------------------------------------4. SELECT within SELECT Tutorial--------------------------------------------
--1. Bigger than Russia [population bigger than russia]
SELECT name FROM world
WHERE population > (SELECT population FROM world
                    WHERE name='Russia')

--2. Richer than UK [countries per capita greater than UK]
SELECT name FROM world
WHERE continent = 'Europe'
AND gdp/population > ( SELECT gdp/population FROM World
                       WHERE name = 'United Kingdom')

--3. Neighbours of Argentina and Australia
SELECT name, continent FROM world
WHERE continent IN (select continent from world
                    WHERE name IN ('Argentina', 'Australia'))
order by name

--4. Between Canada and Poland [countries with population greater than uk_population and less than germany_population]
WITH popul AS(
SELECT(SELECT population FROM world WHERE name='United Kingdom') AS uk_p,
(SELECT population FROM world WHERE name= 'Germany') AS ger_p
)

SELECT name, population FROM world, popul
WHERE population >  uk_p AND population < ger_p

-- 5. Percentages of Germany
WITH ger AS(SELECT(SELECT population FROM world WHERE name='Germany') AS g_popul)

SELECT name, CONCAT(CAST((CAST(population AS DECIMAL)/80000000)*100 AS INT),'%') AS percentage FROM world
CROSS JOIN ger g
WHERE continent = 'Europe'
ORDER by name

--6. Bigger than every country in Europe
SELECT name FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE continent='Europe')

--7. Largest in each continent by using a subquery and ALL.
SELECT continent, name, area FROM world x
WHERE area >= ALL(SELECT MAX(area) FROM world y
                 WHERE y.continent = x.continent and area >= 0)
ORDER by name

--8. First country of each continent using Subquey and MIN
SELECT continent, name
FROM world
WHERE name IN (SELECT MIN(name) 
               FROM world 
               GROUP BY continent);

--9. Difficult Questions That Utilize Techniques Not Covered In Prior Sections [continents with popopaltion less than 25000000 and in all its respective countries]
SELECT name, continent, population FROM WORLD x
WHERE (SELECT COUNT(name) FROM WORLD y
WHERE x.continent = y.continent ) = (SELECT COUNT(name) FROM WORLD z WHERE  x.continent = z.continent AND population <= 25000000)

--10. Three time bigger
SELECT name, continent FROM world x
WHERE CAST(population AS DECIMAL) >= ALL(SELECT CAST(population AS DECIMAL)*3 FROM world y
WHERE x.continent=y.continent AND y.name != x.name)
