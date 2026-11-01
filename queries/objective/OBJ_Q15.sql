SELECT
    p.Player_Name,
    v.Venue_Name,
    SUM(bbb.Runs_Scored) AS Total_Runs,
    COUNT(*) AS Balls_Faced,
    ROUND(SUM(bbb.Runs_Scored) * 1.0 / COUNT(*), 2) AS Strike_Rate
FROM ball_by_ball bbb
JOIN matches m ON bbb.Match_Id = m.Match_Id
JOIN venue v ON m.Venue_Id = v.Venue_Id
JOIN player p ON bbb.Striker = p.Player_Id
GROUP BY p.Player_Name, v.Venue_Name
HAVING COUNT(*) >= 10  -- Filter to ensure minimum balls faced
ORDER BY p.Player_Name, Total_Runs DESC;