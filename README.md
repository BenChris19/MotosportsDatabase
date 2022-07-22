# MotosportsDatabase


*Specification*

A race has a name and must take place at a single race course at a specific date and at a specific starting time. A race has a certain number of laps (around the race course) and a total length in miles. No two races of the same name take place on the same day. A race course has a unique name, a location, and a length in miles. For each driver, we keep the name, consisting of first and last name, nationality, date of birth and a unique driver identifier. Drivers always belong to a single racing team. We need to find out which driver drove which car in which race. We also need to store in which place they arrived at the finish (non-finishers are recorded as arrived in 0-th place). Drivers drive at most one car in a race but not all drivers do. There are no driver swaps during a race but at different races different drivers may be driving the same car. The type of tyres on the car at the start of the race is recorded as well as the car’s racing number for that particular race.                                                                      
Cars have a unique identifier and must belong to a racing team. The make of the engine of a car is relevant too. Not every car is necessarily  
driven in a race. A car may complete a lap of a race in which case the lap time and fuel consumption are to be recorded. A car may have a pit stop during a lap in a race, in which case the duration of the pit stop and the items that have been changed during the pit stop (tyres, front nose, etc.) are recorded. A car may retire in a lap of a race, in which case the reason for the retirement is to be recorded. In all these cases, we need to know in which lap of which race this occurred.                                
Important aspects of a racing team are its name and the address of the team’s headquarter consisting of postcode, street name, house number. Racing teams may be entered on the database before any drivers or cars are assigned to them.                                             


*Questions*

**1. Write one SQL statement to set up table MoSpo HallOfFame accord-
ing to the following Relational Schema:**
MoSpo HallOfFame(hoFdriverId, hoFYear, hoFSeries, hoFImage,
hoFWins, hoFBestRaceName, hoFBestRaceDate)
primary key (hoFdriverId,hoFYear)
foreign key (hoFdriverId) references MoSpo Driver(driverId)
foreign key (hoFBestRaceName,hoFBestRaceDate) references
MoSpo Race(raceName,raceDate)
Your code must execute without error, assuming that all other tables
have been set up by running scripts a2-setup.sql and a2-setup-additional.sql.
[10 marks]
The data types you choose for the columns should be most appropri-
ate for the data they will contain. You must also accommodate the
following requirements:
(a) For table and column names you must pick exactly the names
used in the schema above (otherwise you will lose marks as tests
will fail).
(b) hoFYear is a 4-digit number representing a year between 1901
and 2155 (or 0000).
(c) hoFSeries is one of the following strings: BritishGT, Formula1,
FormulaE, SuperGT. Please make sure you use the correct spelling.
These column values, when ordered, should always appear in the
order they have been listed above. Values for this attribute must
not be missing.
(d) hoFWins is a positive integer number and never larger than 99.
The default is 0 but values can be missing.
(e) hoFImage is a path to an image document which is a string never
longer than 200 characters. This value can be missing.
(f) Equip any foreign key constraints with constraint names of your
choosing.
(g) Ensure that if a driver is deleted from the database their corre-
sponding hall of fame entries are deleted automatically too.
(h) Ensure that if a race is deleted from the database then foreign key
values in hall of fame entries that reference it are automatically
set to null.

**2. The weight of drivers has been omitted from the MoSpo_Driver table.
Without deleting and recreating the table, add a column driverWeight
to the already created table that allows values to be missing.
Take into consideration that a driver’s weight is always in the range
0.0 to 99.9.**

**3. Change the postcode of the racing team Beechdean Motorsport to (the
following string) HP135PN.**

**4. Remove all drivers with last name Senna and first name Ayrton (what-
ever the capitalisation) from the database.**

**5. Find out how many racing teams are on the database.**

**6. List all racing drivers (driver id, name and dob) whose last name be-
gins with the same letter as their first name. The name of the driver
should be given as a string consisting of the initial from the first name,
followed by a blank, followed by their last name. So a driver with first
name Alan and last name Turing would be listed as A Turing.**

**7. List for each racing team how many drivers they have associated with
them. Only include teams with more than one driver.**

**8. For each race list the fastest lap time. The information provided
should include race name, race date, lap time. No races must ap-
pear for which there is no proper such minimal time available.**

**9. Given a race (name) and a year, ‘total pitstops’ is the total number of
pitstops of all cars in the given race that year. For each race name
compute the average of the number of ‘total pitstops’ based on the
years we have data for.**

**10. A car (of a race entry) retires in a lap if the corresponding attribute
lapInfoCompleted has value 0. Find out all the (different) makes
of cars that had to retire in a race in the year 2018.**

**11. For each race, compute the highest number of pitstops any car had.
Provide race name and date as well as the highest number of stops.
Races with no pitstops recorded at all should appear with a 0.**

**12. List all drivers (id, last name) who had no retirement ever. Note that
the reason for not having had a retirement may well be that the driver
never participated in a race.**

**13. For any given care make m mand time period t, let RetirementsRate(t)
be the total number of retirements of cars of make m divided by the
total number of cars of make mtaking part in a race during time t.
In case no car of make m participated in race r during period t this
number is undefined (NULL).**
**For example, let t be the year 2000 and m = Porsche. Assume that
in the year 2000 there were two races with Porsche cars involved. In
the first race 2 cars of that make raced and 1 had a retirement. In the
second race 3 cars of that make raced with 0 retirements. Therefore,
we get that RetirementsRatePorsche(t) = 1/5 = 0.2.**

**For a period t, let AverageRetirementRate(t) be the average of re-
tirement rates for period t across all makes m, i.e. the average of
RetirementsRate(t) ignoring undefined values, over all makes m.
List for each car make mthe retirement rate RetirementRatem(t) where
tis 2018. Only select car makes mwith a retirement rate above the
average retirement rate across all makes for the same period t, i.e.
where RetirementRatem(t) > AverageRetirementRate(t).**

**14. Write a stored function totalRaceTime that, given a racing num-
ber, the name of a race, and the date of a race, returns the total race
time for the car specified by the racing number in the given race. If
the given race does not exist, the routine should throw the error with
message procedure Race does not exist. If the specified racing num-
ber did not take part in the existing race, the routine should throw an
error with message procedure RaceEntry does not exist.**
**In the case that not all required lap times for the (existing) car in the
(existing) race are available either until race finish or retirement, the
routine should throw an error with message procedure TimeForAll-
Laps does not exist.**
**If the (existing) race was not completed by the (participating) car in
the race due to retirement but all lap times were available until retire-
ment, the routine must not throw an error but return null.
Note that in those error cases the function must not return a string but
produce an SQL error.**

**The total race time should be returned as an integer denoting millisec-
onds. Note that this stored routine has three arguments and you must
declare them in the order given above.**

