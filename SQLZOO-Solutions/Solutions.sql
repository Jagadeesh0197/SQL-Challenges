-------------------------------------------------- 1. SELECT basics --------------------------------------
  -- 1. Population of Germany
SELECT population FROM world
WHERE name='Germany';

  -- 2. name and population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
WHERE name IN ('Sweden','Norway','Denmark');

  -- 3. Countries and area for area BETWEEN 200000 AND 250000
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;

------------------------------------------------ 2. SELECT from WORLD --------------------------------------
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

  -- 9. shows population in millions and GDP in billions [ROUND is used to round of to any precision. 
--for more (https://sqlzoo.net/wiki/ROUND)] MYSQL answer 
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
-------------------------------------------------3. SELECT from Nobel Tutorial -----------------------------------

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

-----------------------------------------------4. SELECT within SELECT Tutorial-------------------------------
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
WHERE x.continent = y.continent ) = (SELECT COUNT(name) 
	                             FROM WORLD z 
	                             WHERE  x.continent = z.continent AND population <= 25000000)

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

--13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" 
-- which has not been explained in any previous exercises. Notice in the query given every goal is listed. 
-- If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column 
-- to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT mdate, team1,
SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
team2,
SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
	FROM game LEFT OUTER JOIN goal ON id = matchid
	GROUP BY id
	ORDER BY mdate, matchid, team1, team2;


-----------------------------------------------7. More JOIN operations--------------------------------------------
--1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

--2. Give year of 'Citizen Kane'.
SELECT yr FROM movie
WHERE title = 'Citizen Kane'

--3. List all of the Star Trek movies, include the id, title and yr (all of these movies include
--the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr

--4. What id number does the actor 'Glenn Close' have?
SELECT id FROM actor
WHERE name='Glenn Close'

--5. What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

--6. Obtain the cast list for 'Casablanca'.
SELECT A.name
FROM actor A JOIN casting C ON C.actorid = A.id
WHERE movieid=11768

--7. Obtain the cast list for the film 'Alien'
SELECT A.name
FROM actor A JOIN casting C ON A.id = C.actorid
JOIN movie m ON C.movieid = m.id
WHERE title='Alien'

--8. List the films in which 'Harrison Ford' has appeared
SELECT m.title
FROM movie m JOIN casting c ON c.movieid = m.id
JOIN actor a ON c.actorid = a.id
WHERE a.name = 'Harrison Ford'

--9. List the films where 'Harrison Ford' has appeared 
-- but not in the starring role. [Note: the ord field of casting gives the position of the actor. 
--If ord=1 then this actor is in the starring role]
SELECT m.title
FROM movie m JOIN casting c ON c.movieid = m.id
JOIN actor a ON c.actorid = a.id
WHERE a.name = 'Harrison Ford' and c.ord != 1

--10. List the films together with the leading star for all 1962 films.
SELECT DISTINCT m.title, a.name
FROM movie m JOIN casting c ON m.id = c.movieid
JOIN actor a ON a.id = c.actorid
WHERE m.yr = 1962 and c.ord = 1

--10. Which were the busiest years for 'Rock Hudson', show the year and the number of movies 
--he made each year for any year in which he made more than 2 movies.

SELECT DISTINCT m.title, a.name
FROM movie m JOIN casting c ON m.id = c.movieid
JOIN actor a ON a.id = c.actorid
WHERE m.yr = 1962 and c.ord = 1

--11. Which were the busiest years for 'Rock Hudson', show the year and the number of 
-- movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(*)
FROM movie JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(*) > 2

--12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT m.title, a.name
  FROM movie m JOIN casting c ON c.movieid=m.id
JOIN actor a ON  c.actorid=a.id AND c.ord=1 
AND c.movieid IN (SELECT movieid FROM casting, actor
	WHERE actorid=actor.id AND name='Julie Andrews');
	 
--13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name
FROM casting JOIN actor ON  actorid = actor.id
WHERE ord=1
GROUP BY actor.name
HAVING COUNT(movieid)>=15;

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT m.title, COUNT(c.actorid) AS actor_count
FROM movie m JOIN casting c ON m.id = c.movieid
WHERE m.yr = 1978
GROUP BY m.id, m.title
ORDER BY actor_count DESC, m.title ASC;
	
--15. List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT d.name
FROM actor d JOIN  casting a ON d.id = a.actorid
JOIN casting b ON a.movieid = b.movieid
JOIN actor c ON (b.actorid = c.id AND c.name = 'Art Garfunkel')
where d.id != c.id

-----------------------------------------------8. Using Null --------------------------------------------
--1. List the teachers who have NULL for their department.
SELECT name 
FROM teacher
WHERE dept IS NULL

--2. INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept ON (teacher.dept=dept.id)

--3. Use a different JOIN so that all teachers are listed.
SELECT t.name, d.name
FROM teacher t LEFT JOIN dept d ON t.dept = d.id

--4. Use a different JOIN so that all departments are listed.
SELECT t.name, d.name
FROM teacher t RIGHT JOIN dept d ON (t.dept = d.id)

--5. Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. 
-- Show teacher name and mobile number or '07986 444 2266'
SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher

--6. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. 
-- Use the string 'None' where there is no department.
SELECT t.name, COALESCE(d.name,'None')
FROM teacher t LEFT JOIN dept d ON (t.dept = d.id)

--7. Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(name), COUNT(mobile) FROM teacher

--8. Use COUNT and GROUP BY dept.name to show each department and the number of staff. 
-- Use a RIGHT JOIN to ensure that the Engineering department is listed.
SELECT d.name, COUNT(t.name)
FROM teacher t RIGHT JOIN dept d ON t.dept = d.id
GROUP BY d.name

--9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
SELECT 
        t.name, 
	CASE 
	    WHEN t.dept IN ('1','2') THEN 'Sci'
            ELSE 'Art' END
FROM teacher t

--10. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, 
-- show 'Art' if the teacher's dept is 3 and 'None' otherwise.
SELECT 
       name,
       CASE
           WHEN dept IN (1, 2) THEN 'Sci'
           WHEN dept = 3 THEN 'Art'
           ELSE 'None' END
FROM teacher

-----------------------------------------------9. Self join --------------------------------------------
--1. How many stops are in the database.
SELECT COUNT(*) FROM stops

--2. Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops
WHERE name = 'Craiglockhart'

--3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT s.id, s.name
FROM stops s JOIN route r ON (r.stop= s.id)
WHERE r.company = 'LRT' and r.num = '4'

--4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
-- Run the query and notice the two services that link these stops have a count of 2. 
-- Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) > 1

--5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
--without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop = 149

--6. The query shown is similar to the previous one, however by joining two copies of the stops table 
-- we can refer to stops by name rather than by number. Change the query so that the services between 
--'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road'

--7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT  r.company, r.num
FROM route r JOIN route r1 ON (r.company= r1.company AND r.num = r1.num)
WHERE r.stop = 115 AND r1.stop = 137

--8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT r.company, r.num
FROM route r 
JOIN route r1 ON (r.company=r1.company AND r.num=r1.num)
JOIN stops ast ON (r.stop = ast.id)
JOIN stops bst ON (r1.stop = bst.id)
WHERE ast.name = 'Craiglockhart' AND bst.name = 'Tollcross'

--9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
-- including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT DISTINCT s2.name, r1.company, r2.num
FROM route r1 JOIN route r2 ON (r1.company = r2.company AND r1.num = r2.num AND r2.company='LRT')
JOIN stops s1 ON (r1.stop = s1.id AND s1.name = 'Craiglockhart')
JOIN stops s2 ON (r2.stop = s2.id)
ORDER BY s2.name

--10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and 
-- company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus
select DISTINCT bus1.num, bus1.company, bus1.name, bus2.num, bus2.company from
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    -- self join on service id (service id is company and bus number)
    -- this gives me all routs for curret service id
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    -- this gives me starting bus stops with name Craiglockhart
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Craiglockhart')
    -- gives me final route:
    -- list of all the stops for all the buses
    -- which can be reached from Craiglockhart
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus1
 JOIN
  -- next is simillar to query above
  -- this gives me all the stops for all the buses
  -- which can be reached from Lochend
  (SELECT DISTINCT r1.num, r1.company, s2.name from route r1
    join route r2
      ON (r1.company=r2.company AND r1.num=r2.num)
    join stops s1
      ON (r1.stop=s1.id AND s1.name='Lochend')
    join stops s2
      ON (s2.id=r2.stop)
  ) AS bus2
    -- join gives me full routes
    -- with transfer stops
    -- that can be reached from both of routes
    ON bus1.name=bus2.name
ORDER BY bus1.num, bus1.company, bus1.name, bus2.num, bus2.company
