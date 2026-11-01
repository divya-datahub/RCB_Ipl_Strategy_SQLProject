SELECT 
    COUNT(DISTINCT p.Player_Id)  AS players_above_25_in_2014

FROM Player p

-- Only include players who actually PLAYED in 2014
JOIN Player_Match pm 
    ON p.Player_Id = pm.Player_Id

JOIN Matches m 
    ON pm.Match_Id = m.Match_Id

JOIN Season s 
    ON m.Season_Id = s.Season_Id

WHERE 
    -- Filter for Season 2014 only
    s.Season_Year = 2014

    -- Player must have a valid DOB
    AND p.DOB IS NOT NULL

    -- Age must be MORE THAN 25 during IPL 2014
    -- Using April 1, 2014 as reference (IPL season start)
    AND TIMESTAMPDIFF(
            YEAR, 
            p.DOB, 
            '2014-04-01'        -- IPL 2014 approximate start date
        ) > 25;