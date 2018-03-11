use retrosheet;

select * from Events;

-- Count of hits at bat for the rockies that hit a single,double,triple, or HR at coors 
DROP TABLE IF EXISTS RockiesHits;
CREATE TABLE RockiesHits AS 
	SELECT BAT_ID, count(EVENT_CD) as H
		FROM Events 
		WHERE (home_team_id = 'COL' 
			and BAT_HOME_ID = 1) 
			and (EVENT_CD = 20 
			or  EVENT_CD = 21
			or  EVENT_CD = 22
			or  EVENT_CD = 23)
		GROUP BY BAT_ID
		ORDER BY count(EVENT_CD) DESC;

-- At Bats for rockies at home 
-- Rockies players batting average at home
DROP TABLE IF EXISTS RockiesAB;
CREATE TABLE RockiesAB AS 
SELECT BAT_ID, count(BAT_EVENT_FL) as AB
    FROM Events 
	WHERE (home_team_id = 'COL' 
		and BAT_EVENT_FL = 'T')
	GROUP BY BAT_ID
    ORDER BY count(BAT_EVENT_FL) DESC;
    
select RAB.BAT_ID, RH.H/RAB.AB as battingAverage from RockiesAB as RAB join RockiesHits as RH on RAB.BAT_ID = RH.BAT_ID;

-- Rockies hits away
DROP TABLE IF EXISTS RockiesHitsAway;
CREATE TABLE RockiesHitsAway AS 
	SELECT BAT_ID, count(EVENT_CD) as H
		FROM Events 
		WHERE (away_team_id = 'COL' 
			and BAT_HOME_ID = 0) 
			and (EVENT_CD = 20 
			or  EVENT_CD = 21
			or  EVENT_CD = 22
			or  EVENT_CD = 23)
		GROUP BY BAT_ID
		ORDER BY count(EVENT_CD) DESC;
        
        
DROP TABLE IF EXISTS RockiesABAway;
CREATE TABLE RockiesABAway AS 
SELECT BAT_ID, count(BAT_EVENT_FL) as AB
    FROM Events 
	WHERE (away_team_id = 'COL' 
		and BAT_EVENT_FL = 'T')
	GROUP BY BAT_ID
    ORDER BY count(BAT_EVENT_FL) DESC;


-- Create Table of Rockies Batting Averages Away and Home 
DROP TABLE IF EXISTS BA_RockiesAway;
CREATE TABLE BA_RockiesAway AS 
	select RAB.BAT_ID, RH.H/RAB.AB as battingAverageAway 
    from RockiesABAway as RAB 
    join RockiesHitsAway as RH 
    on RAB.BAT_ID = RH.BAT_ID;

DROP TABLE IF EXISTS BA_RockiesHome;
CREATE TABLE BA_RockiesHome AS 
	select RAB.BAT_ID, RH.H/RAB.AB as battingAverageHome 
    from RockiesAB as RAB 
    join RockiesHits as RH 
    on RAB.BAT_ID = RH.BAT_ID;


select distinct r.LAST_NAME_TX, r.FIRST_NAME_TX, BA_RH.battingAverageHome, BA_RA.battingAverageAway,  BA_RH.battingAverageHome / BA_RA.battingAverageAway - 1 as percentBetterAtHome
	from BA_RockiesHome as BA_RH 
    JOIN BA_RockiesAway as BA_RA
    on BA_RH.BAT_ID = BA_RA.BAT_ID
    JOIN Rosters as r
    on r.Player_ID = BA_RH.BAT_ID;
    

select * from rosters;

