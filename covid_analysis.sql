CREATE TABLE covid_stats (
CountryRegion varchar(255),
Confirmed int,
Deaths int,
Recovered int,
Active int,
NewCases int,
NewDeaths int,
NewRecovered int,
DeathsPer100Cases int,
RecoveredPer100Cases int, 
DeathsPer100Recovered int,
ConfirmedLastWeek int, 
1WeekChange int,
1WeekPercentIncrease int, 
WHORegion varchar(255)
)

CREATE INDEX idx ON covid_stats (CountryRegion);

SELECT * FROM covid_stats;


SELECT CountryRegion, Confirmed FROM covid_stats WHERE Confirmed > 5000 ORDER BY Confirmed DESC LIMIT 5;

/*
Selects Country and confirmed columns from the table, and queries on where confirmed cases is greater than 5000 in descending order 
*/

SELECT COUNT(*) FROM covid_stats 
WHERE CountryRegion IS NULL or Confirmed IS NULL or Deaths IS NULL or Recovered IS NULL or Active IS NULL or  NewCases IS NULL
or NewDeaths IS NULL or NewRecovered IS NULL or DeathsPer100Cases IS NULL or RecoveredPer100Cases IS NULL or DeathsPer100Recovered IS NULL
or ConfirmedLastWeek IS NULL or 1WeekChange IS NULL or 1WeekPercentIncrease IS NULL or WHORegion IS NULL;

/*
no null values which is good 
*/

SELECT * FROM covid_stats WHERE DeathsPer100Cases > Any 
	(Select AVG(DeathsPer100Cases)
    FROM covid_stats);

/*
Selects all rows from covid_stats where DeathsPer100Cases is greater than the average DeathsPer100Cases, these countries are higher
than the average and need attention 
*/

SELECT CountryRegion, Deaths, Recovered FROM covid_stats WHERE Deaths > Recovered;

/*
Selecting countries that have more deaths than recoveries, these are the countries most at risk who need help 
*/

SELECT WHORegion, AVG(1WeekPercentIncrease), MAX(1WeekPercentIncrease), COUNT(CountryRegion)
FROM covid_stats
GROUP BY WHORegion;

/*
This makes sense because Western Pacific contains China and Africa also doesn't have the utilities to slow down COVID 
*/

SELECT CountryRegion FROM covid_stats WHERE CountryRegion LIKE 'B%';

/*
Selecting countries that start with the letter B 
*/

SELECT CountryRegion FROM covid_stats WHERE CountryRegion NOT LIKE 'B%';


/*
Selecting countries that Don't start with the letter B 
*/

ALTER TABLE covid_stats 
ADD fatalDeaths BOOLEAN

SET SQL_SAFE_UPDATES = 0

UPDATE covid_stats 
SET fatalDeaths = CASE
    WHEN Deaths >= Recovered THEN TRUE
    ELSE FALSE
	END;

SELECT CountryRegion, fatalDeaths FROM covid_stats where fatalDeaths = 1 

/*
Creates a column that contains a boolean on whether or not deaths is greater than confirmed 
*/

ALTER TABLE covid_stats 
ADD numNulls INT

UPDATE covid_stats
SET numNulls = (CASE WHEN CountryRegion IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN Active IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN NewCases IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN NewDeaths IS NULL THEN 1 ELSE 0 END)  + 
(CASE WHEN NewRecovered IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN DeathsPer100Cases IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN RecoveredPer100Cases IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN DeathsPer100Recovered IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN ConfirmedLastWeek IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN 1WeekChange IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN 1WeekPercentIncrease IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN WHORegion IS NULL THEN 1 ELSE 0 END) + 
(CASE WHEN fatalDeaths IS NULL THEN 1 ELSE 0 END);

/*
Makes a column that contains the total amount of null per row 
*/

ALTER TABLE covid_stats 
ADD ActiveFromNewCases INT AFTER NewRecovered

UPDATE covid_stats 
SET ActiveFromNewCases = (NewCases - NewDeaths - NewRecovered);

SELECT * FROM covid_stats 