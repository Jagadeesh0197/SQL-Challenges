# SQLZOO Solutions

Solutions to [SQLZOO Tutorials](https://www.sqlzoo.net/ ).

This repository contains SQL solutions organized by sections. Each solution is designed to help learners practice and understand SQL concepts effectively.

## Table of Contents

1. [SELECT basics](#select-basics)
    - Population of Germany
    - Name and population for 'Sweden', 'Norway' and 'Denmark'
    - Countries and area for area BETWEEN 200000 AND 250000

2. [SELECT from WORLD](#select-from-world)
    - Data Exploring
    - Countries with population ≥ 200,000,000
    - Per capita GDP for countries with population ≥ 200,000,000
    - Population in millions (South America)
    - Name and population in ('France','Germany','Italy')
    - Country names that start with 'UNITED'
    - Big in terms of area or population
    - Big in area or population but not both
    - Population in millions and GDP in billions (MYSQL/MSSQL)
    - Per capita GDP with at least 1 trillion

3. [SELECT from Nobel Tutorial](#select-from-nobel-tutorial)
    - Winners from 1950
    - 1962 Literature winner
    - Albert Einstein's prizes
    - Recent Peace Prizes (after 2000)
    - Literature in the 1980's
    - Only Presidents (listed winners)
    - Winners with first name 'John'
    - Chemistry and Physics (different years)
    - Exclude Chemists and Medics (1980)
    - Early Medicine, Late Literature

4. [SELECT within SELECT Tutorial](#select-within-select-tutorial)
    - Countries bigger than Russia
    - Richer than UK
    - Neighbours of Argentina and Australia
    - Between Canada and Poland (by population)
    - Percentages of Germany's population
    - Bigger than every country in Europe
    - Largest in each continent
    - First country of each continent
    - Continents with population less than 25 million
    - Three times bigger

5. [SUM and COUNT](#sum-and-count)
    - Total world population
    - List of continents
    - GDP of Africa
    - Count the big countries
    - Baltic states population
    - Using GROUP BY and HAVING (countries per continent)
    - Counting big countries in each continent
    - Counting big continents (with population ≥ 100 million)

6. [The JOIN operation](#the-join-operation)
    - Matchid and player name for Germany goals
    - Info for game 1012
    - Player, teamid, stadium and mdate for German goals
    - Team1, team2 and player for goals by 'Mario'
    - Goals scored in the first 10 minutes
    - Matches where 'Fernando Santos' was team1 coach
    - Players who scored where stadium was 'National Stadium, Warsaw'
    - Players who scored against Germany
    - Teamname and total number of goals scored
    - Stadium and number of goals scored
    - Matches involving 'POL' with goal counts
    - Matches where 'GER' scored, with goal counts
    - Matches with goals by each team (using CASE WHEN)

7. [More JOIN operations](#more-join-operations)
    - Films where year is 1962
    - Year of 'Citizen Kane'
    - All Star Trek movies
    - ID of actor 'Glenn Close'
    - ID of film 'Casablanca'
    - Cast list for 'Casablanca'
    - Cast list for 'Alien'
    - Films 'Harrison Ford' has appeared in
    - Films 'Harrison Ford' appeared (not starring)
    - Leading star for all 1962 films
    - Busiest years for 'Rock Hudson'
    - Films and leading actor for 'Julie Andrews'
    - Actors with at least 15 starring roles
    - Films from 1978 ordered by cast size
    - People who worked with 'Art Garfunkel'

8. [Using Null](#using-null)
    - Teachers with NULL department
    - INNER JOIN teacher and dept
    - LEFT JOIN all teachers
    - RIGHT JOIN all departments
    - Use COALESCE for mobile number
    - COALESCE for department name
    - Number of teachers and mobile phones
    - Staff count per department (RIGHT JOIN)
    - CASE for 'Sci' or 'Art' based on dept
    - CASE for 'Sci', 'Art', or 'None' based on dept

9. [Self join](#self-join)
    - Number of stops in the database
    - ID value for 'Craiglockhart'
    - Stops on '4' 'LRT' service
    - Services linking London Road or Craiglockhart
    - Services from Craiglockhart to London Road
    - Services between 'Craiglockhart' and 'London Road' (by name)
    - Services connecting 'Haymarket' and 'Leith'
    - Services connecting 'Craiglockhart' and 'Tollcross'
    - Stops reachable from 'Craiglockhart' by one bus (LRT)
    - Routes involving two buses from Craiglockhart to Lochend
