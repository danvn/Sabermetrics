use retrosheet;


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
DROP TABLE IF EXISTS RockiesAB;
CREATE TABLE RockiesAB AS 
SELECT BAT_ID, count(BAT_EVENT_FL) as AB
    FROM Events 
	WHERE (home_team_id = 'COL' 
		and BAT_EVENT_FL = 'T')
	GROUP BY BAT_ID
    ORDER BY count(BAT_EVENT_FL) DESC;
    
select RAB.BAT_ID, RH.H/RAB.AB from RockiesAB as RAB join RockiesHits as RH on RAB.BAT_ID = RH.BAT_ID;