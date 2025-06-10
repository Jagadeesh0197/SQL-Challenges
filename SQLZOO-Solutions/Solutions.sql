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

--9. Difficult Questions That Utilize Techniques Not Covered In Prior Sections [continents with 
-- popopaltion less than 25000000 and in all its respective countries]
SELECT name, continent, population FROM WORLD x
WHERE (SELECT COUNT(name) FROM WORLD y
WHERE x.continent = y.continent ) = (SELECT COUNT(name) FROM WORLD z WHERE  x.continent = z.continent AND population <= 25000000)

--10. Three time bigger
SELECT name, continent FROM world x
WHERE CAST(population AS DECIMAL) >= ALL(SELECT CAST(population AS DECIMAL)*3 FROM world y
WHERE x.continent=y.continent AND y.name != x.name)

-----------------------------------------------5. SUM and COUNT--------------------------------------------
--1. Total world population [SUM() aggregate func]
SELECT SUM(population)
FROM world

--2. List of continents [There will be multiple countries for single continents so continents 
-- will be in repeated. we need all distinct so use 'DISTINCT']
SELECT DISTINCT continent FROM world

--3. GDP of Africa [multiple countries were under the 'Africa' Continent. so SUM up gdp based on the continent]
SELECT SUM(gdp) FRoM world
WHERE continent = 'Africa'

--4. Count the big countries  [area atleast 1000000]
select count(name) FROM world
where area >= 1000000

--5. Baltic states population [Total population in those particular countries]
SELECT SUM(population) FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

--6. Using GROUP BY and HAVING [continent and number of countries for that continent]
SELECT continent, count(name)
FROM world
GROUP BY continent

--7. Counting big countries in each continent [same as (6 question) above but with one more condition as 
-- population greater than 10000000 ]
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent

--8. Counting big continents 
-- List the continents that have a total population of at least 100 million.
SELECT continent FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000

-----------------------------------------------6. The JOIN operation--------------------------------------------
--1. Modify it to show the matchid and player name for all goals scored by Germany.
-- To identify German players, check for: teamid = 'GER'
SELECT matchid, player  FROM goal 
  WHERE teamid = 'GER'

--2. Notice in the that the column matchid in the goal table corresponds to the id column in the game table. 
-- We can look up information about game 1012 by finding that row in the game table. 
-- Show id, stadium, team1, team2 for just game 1012
SELECT DISTINCT id,stadium,team1,team2
  FROM game
  join goal on goal.matchid = game.id
WHERE goal.matchid = '1012'

--3.The FROM clause says to merge data from the goal table with that from the game table. The ON says how to 
-- figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. 
-- (If we wanted to be more clear/specific we could say ON (game.id=goal.matchid) The code below shows the player 
-- (from the goal) and stadium name (from the game table) for every goal scored. Modify it to show the 
-- player, teamid, stadium and mdate for every German goal.
SELECT player,teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER'

--4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1 , team2, player
FROM game
JOIN goal ON (id = matchid)
WHERE player LIKE 'Mario%'

--5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach , gtime
  FROM goal JOIN eteam ON (teamid=eteam.id)
 WHERE gtime<=10

--6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game JOIN eteam ON (game.team1 = eteam.id)
WHERE coach = 'Fernando Santos'

--7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal JOIN game ON (id=matchid)
WHERE stadium IN ('National Stadium, Warsaw')

--8. Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER') and (teamid != 'GER')

--9. Show teamname and the total number of goals scored.
SELECT teamname, COUNT(*)
FROM eteam JOIN goal ON teamid = id
GROUP BY teamname

--10. Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(*)
FROM game JOIN goal ON (id= matchid)
GROUP BY stadium

--11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT goal.matchid, game.mdate, COUNT(*)
FROM  goal JOIN game ON matchid = id
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY goal.matchid, game.mdate

--12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(teamid)
FROM goal JOIN game ON (matchid=id)
WHERE teamid='GER'
GROUP BY matchid, mdate
