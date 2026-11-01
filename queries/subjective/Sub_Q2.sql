SELECT 
    p.Player_Name,
    COUNT(*) AS Balls_Faced,
    SUM(bbb.Runs_Scored) AS Total_Runs,
    ROUND(SUM(bbb.Runs_Scored) * 1.0 / COUNT(*), 2) AS Strike_Rate
FROM ball_by_ball bbb
JOIN matches m ON bbb.Match_Id = m.Match_Id
JOIN season s ON m.Season_Id = s.Season_Id
JOIN player p ON bbb.Striker = p.Player_Id
WHERE s.Season_Year >= (SELECT MAX(Season_Year) - 3 FROM season)
GROUP BY p.Player_Name
HAVING COUNT(*) >= 50 -- minimum balls faced
ORDER BY Strike_Rate DESC, Total_Runs DESC
LIMIT 10;

SELECT 
    p.Player_Name,
    COUNT(*) AS Balls_Bowled,
    COUNT(wt.Player_out) AS Wickets,
    ROUND(COUNT(wt.Player_out) * 1.0 / COUNT(*), 2) AS Wicket_Per_Ball
FROM ball_by_ball bbb
JOIN matches m ON bbb.Match_Id = m.Match_Id
JOIN season s ON m.Season_Id = s.Season_Id
JOIN player p ON bbb.Bowler = p.Player_Id
LEFT JOIN wicket_taken wt ON bbb.Match_Id = wt.Match_Id 
                    AND bbb.Over_Id = wt.Over_Id 
                    AND bbb.Ball_Id = wt.Ball_Id
WHERE s.Season_Year >= (SELECT MAX(Season_Year) - 3 FROM season)
GROUP BY p.Player_Name
HAVING COUNT(*) >= 30 -- min overs
ORDER BY Wickets DESC, Wicket_Per_Ball DESC
LIMIT 10;
