-- Step 2: Get RCB total runs in first season
SELECT 
    t.Team_Name,
    m.Season_Id,
    SUM(bbb.Runs_Scored) AS Total_Runs
FROM ball_by_ball bbb
JOIN matches m 
    ON bbb.Match_Id = m.Match_Id
JOIN team t 
    ON bbb.Team_Batting = t.Team_Id
WHERE t.Team_Name = 'Royal Challengers Bangalore'
  AND m.Season_Id = (SELECT MIN(Season_Id) FROM matches)
GROUP BY t.Team_Name, m.Season_Id;