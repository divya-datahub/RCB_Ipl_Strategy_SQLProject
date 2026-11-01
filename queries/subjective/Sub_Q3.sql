SELECT 
    p.Player_Name,
    COUNT(*) AS Balls_Faced,
    SUM(bbb.Runs_Scored) AS Total_Runs,
    ROUND(SUM(bbb.Runs_Scored) * 1.0 / COUNT(*), 2) AS Strike_Rate,
    ROUND(SUM(bbb.Runs_Scored) * 1.0 / COUNT(DISTINCT m.Match_Id), 2) AS Runs_Per_Match
FROM ball_by_ball bbb
JOIN matches m ON bbb.Match_Id = m.Match_Id
JOIN season s ON m.Season_Id = s.Season_Id
JOIN player p ON bbb.Striker = p.Player_Id
WHERE s.Season_Year >= (SELECT MAX(Season_Year) - 2 FROM season)
GROUP BY p.Player_Name
HAVING COUNT(*) >= 30 -- At least 30 balls faced
ORDER BY Strike_Rate DESC, Total_Runs DESC
LIMIT 20;
