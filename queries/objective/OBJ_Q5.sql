-- ============================================================
-- Q5: Top 10 Players by Strike Rate in Last 4 Seasons (2013-2016)
-- ============================================================

SELECT 
    p.Player_Name,
    SUM(b.Runs_Scored)                              AS total_runs,
    COUNT(b.Ball_Id)                                AS balls_faced,
    ROUND(SUM(b.Runs_Scored) * 100.0 / COUNT(b.Ball_Id), 2) AS strike_rate
FROM 
    ball_by_ball b
JOIN matches m   ON b.Match_Id = m.Match_Id
JOIN season s    ON m.Season_Id = s.Season_Id
JOIN player p    ON b.Striker = p.Player_Id
WHERE 
    s.Season_Year BETWEEN 2013 AND 2016    -- last 4 seasons before 2017 auction
GROUP BY 
    p.Player_Id, p.Player_Name
HAVING 
    COUNT(b.Ball_Id) >= 200                -- minimum 200 balls to qualify
    -- This filters out players with 1 match who accidentally have 200 SR
ORDER BY 
    strike_rate DESC
LIMIT 10;