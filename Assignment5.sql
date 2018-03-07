use retrosheet;


-- Count of hits at bat for the rockies that hit a single,double,triple, or HR at coors 
SELECT BAT_ID, count(EVENT_CD)
    FROM Events 
	WHERE (home_team_id = 'COL' 
		and BAT_HOME_ID = 1) 
        and (EVENT_CD = 20 
        or  EVENT_CD = 21
        or  EVENT_CD = 22
        or  EVENT_CD = 23)
	GROUP BY BAT_ID
    ORDER BY count(EVENT_CD) DESC;
        
