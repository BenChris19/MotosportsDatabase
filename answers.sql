-- Answer to Part 1 of the 2nd Database Assignment 2020/21
--
-- CANDIDATE NUMBER: 215816
-- Please insert your candidate number in the line above.
-- Do NOT remove ANY lines of this template.

-- In each section below put your answer in a new line 
-- BELOW the corresponding comment.
-- Use ONE SQL statement ONLY per question.
-- If you don’t answer a question just leave 
-- the corresponding space blank. 
-- Anything that does not run in SQL you MUST put in comments.

-- DO NOT REMOVE ANY LINE FROM THIS FILE.

-- START OF ASSIGNMENT CODE


-- @@01
CREATE TABLE MoSpo_HallOfFame(
hoFDriverId INTEGER UNSIGNED,
hoFYear INTEGER UNSIGNED DEFAULT 0000,
hoFSeries ENUM('BritishGT','Formula1','FormulaE','SuperGT'),
hoFImage BLOB,
hoFWins DECIMAL(2,0) UNSIGNED DEFAULT 0,
hoFBestRaceName VARCHAR(30),
hoFBestRaceDate DATE,
CONSTRAINT checkWins CHECK (hoFWins <=99),
CONSTRAINT checkYear CHECK (hoFYear LIKE 0000 OR hoFYear>=1901 AND hoFYear <=2155),
PRIMARY KEY(hoFDriverId,hoFYear),
CONSTRAINT HF_MoSpoDriver_
FOREIGN KEY(hoFDriverId) REFERENCES MoSpo_Driver(driverId)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT HF_MoSpoRaceName_
FOREIGN KEY (hoFBestRaceName,hoFBestRaceDate) REFERENCES MoSpo_Race(raceName,raceDate)
ON DELETE SET NULL
);


 
-- @@02
ALTER TABLE MoSpo_Driver
ADD driverWeight DECIMAL(3,1) UNSIGNED;


-- @@03
UPDATE MoSpo_RacingTeam
SET teamPostcode = 'HP135PN'
WHERE teamName LIKE 'Beechdean Motorsport';


-- @@04
DELETE FROM MoSpo_Driver WHERE LOWER(driverLastname) LIKE 'senna' AND LOWER(driverFirstname) LIKE'ayrton';



-- @@05
SELECT DISTINCT COUNT(*) numberTeams
FROM MoSpo_RacingTeam;



-- @@06
SELECT driverId, CONCAT(SUBSTR(driverFirstname,1,1),CONCAT(' ',driverLastname)) driverName,driverDOB
FROM MoSpo_Driver
WHERE SUBSTR(driverFirstname,1,1) LIKE SUBSTR(driverLastname,1,1);


-- @@07
SELECT DISTINCT driverTeam teamName, COUNT(*) numberOfDriver
FROM MoSpo_Driver
GROUP BY driverTeam
HAVING numberOfDriver>1;



-- @@08
SELECT lapInfoRaceName raceName, lapInfoRaceDate raceDate, MIN(lapInfoTime) lapTime
FROM MoSpo_LapInfo
WHERE (lapInfoRaceName,lapInfoRaceDate,lapInfoTime) NOT IN (SELECT lapInfoRaceName,lapInfoRaceDate,lapInfoTime FROM MoSpo_LapInfo WHERE lapInfoCompleted <=0)
GROUP BY lapInfoRaceName,lapInfoRaceDate;



-- @@09
SELECT pitstopRaceName raceName, COUNT(*)/COUNT(DISTINCT YEAR(pitstopRaceDate)) avgStops
FROM MoSpo_PitStop
GROUP BY pitstopRaceName;


-- @@10
SELECT DISTINCT carMake
FROM MoSpo_Car 
WHERE carId IN (SELECT raceEntryCarId FROM MoSpo_RaceEntry WHERE YEAR(raceEntryRaceDate) IN (SELECT YEAR(lapInfoRaceDate) FROM MoSpo_LapInfo WHERE lapInfoCompleted <=0 AND YEAR(lapInfoRaceDate) LIKE 2018));




-- @@11
SELECT A.raceName, A.raceDate, COUNT(B.pitstopRaceName) AS mostPitstops
FROM MoSpo_Race A LEFT OUTER JOIN MoSpo_PitStop B
ON (A.raceName,A.raceDate) = (B.pitstopRaceName,B.pitstopRaceDate)
GROUP BY A.raceName,A.raceDate;



-- @@12
SELECT driverId,driverLastName
FROM MoSpo_Driver
WHERE driverId IN (SELECT raceEntryDriverId FROM MoSpo_RaceEntry WHERE raceEntryNumber IN (SELECT lapInfoRaceNumber FROM MoSpo_LapInfo WHERE lapInfoCompleted >=1))
OR driverId NOT IN (SELECT raceEntryDriverId FROM MoSpo_RaceEntry);



-- @@13
SELECT A.carMake,COUNT(C.lapInfoCompleted)/COUNT(B.raceEntryCarId) AS retirementRate
FROM (MoSpo_Car A LEFT OUTER JOIN MoSpo_RaceEntry B
ON (A.carId,YEAR(B.raceEntryRaceDate)) = (B.raceEntryCarId,2018))
LEFT OUTER JOIN MoSpo_LapInfo C
ON (B.raceEntryRaceName,B.raceEntryNumber,YEAR(C.lapInfoRaceDate),lapInfoCompleted) = (C.lapInfoRaceName,C.lapInfoRaceNumber,2018,0)
GROUP BY A.carMake;



-- @@14
DELIMITER $$
DROP FUNCTION IF EXISTS totalRaceTime;

CREATE FUNCTION totalRaceTime(raceEntryNumber TINYINT, raceEntryRaceName VARCHAR(30), raceEntryRaceDate DATE) RETURNS INTEGER
BEGIN
DECLARE total INTEGER;
DECLARE all_completed_laps INT;
DECLARE all_laps INT;
IF raceEntryRaceName NOT IN (SELECT MoSpo_RaceEntry.raceEntryRaceName FROM MoSpo_RaceEntry) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'procedure Race does not exist';
END IF;
IF (raceEntryNumber,raceEntryRaceName,raceEntryRaceDate) NOT IN (SELECT MoSpo_RaceEntry.raceEntryNumber,MoSpo_RaceEntry.raceEntryRaceName,MoSpo_RaceEntry.raceEntryRaceDate FROM MoSpo_RaceEntry) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'procedure RaceEntry does not exist';
END IF;
SELECT COUNT(lapInfoRaceName) INTO all_completed_laps FROM MoSpo_LapInfo
WHERE lapInfoCompleted >=1 AND lapInfoRaceName LIKE raceEntryRaceName
AND lapInfoRaceNumber LIKE raceEntryNumber AND lapInfoRaceDate LIKE raceEntryRaceDate;
SELECT COUNT(lapInfoRaceName) INTO all_laps FROM MoSpo_LapInfo
WHERE lapInfoRaceName LIKE raceEntryRaceName
AND lapInfoRaceNumber LIKE raceEntryNumber AND lapInfoRaceDate LIKE raceEntryRaceDate;
IF all_completed_laps<all_laps THEN
RETURN NULL;
END IF;
SELECT SUM(lapInfoTime) INTO total FROM MoSpo_LapInfo
WHERE lapInfoRaceName LIKE raceEntryRaceName
AND lapInfoRaceNumber LIKE raceEntryNumber AND lapInfoRaceDate LIKE raceEntryRaceDate;
IF total IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'procedure TimeForAllLaps does not exist';
END IF;
RETURN total;
END$$



-- END OF ASSIGNMENT CODE
