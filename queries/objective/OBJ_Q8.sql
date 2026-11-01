
WITH Batting_Summary AS (
    SELECT 
        b.Striker          AS Player_Id,
        SUM(b.Runs_Scored) AS Total_Runs
    FROM Ball_by_Ball b
    GROUP BY b.Striker
),

Bowling_Summary AS (
    SELECT 
        b.Bowler               AS Player_Id,
        COUNT(w.Player_Out)    AS Total_Wickets
    FROM Ball_by_Ball b
    JOIN Wicket_Taken w
        ON  b.Match_Id    = w.Match_Id
        AND b.Over_Id     = w.Over_Id
        AND b.Ball_Id     = w.Ball_Id
        AND b.Innings_No  = w.Innings_No
    GROUP BY b.Bowler
),

Overall_Avg_Runs AS (
    SELECT AVG(Total_Runs) AS Avg_Runs
    FROM Batting_Summary
),

Overall_Avg_Wickets AS (
    SELECT AVG(Total_Wickets) AS Avg_Wickets
    FROM Bowling_Summary
)

SELECT 
    p.Player_Name,
    bat.Total_Runs,
    bow.Total_Wickets,
    ROUND(oar.Avg_Runs, 2)     AS Overall_Avg_Runs,
    ROUND(oaw.Avg_Wickets, 2)  AS Overall_Avg_Wickets

FROM Batting_Summary bat

JOIN Bowling_Summary bow
    ON bat.Player_Id = bow.Player_Id

-- Get the player's name
JOIN Player p
    ON bat.Player_Id = p.Player_Id

-- Bring in the overall averages
-- CROSS JOIN because it's just one number — no matching needed
CROSS JOIN Overall_Avg_Runs  oar
CROSS JOIN Overall_Avg_Wickets oaw

-- Filter: must beat BOTH averages
WHERE 
    bat.Total_Runs    > oar.Avg_Runs
    AND bow.Total_Wickets > oaw.Avg_Wickets

ORDER BY 
    bat.Total_Runs DESC;