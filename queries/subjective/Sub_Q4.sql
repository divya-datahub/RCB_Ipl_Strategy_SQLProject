WITH batting AS (
    SELECT 
        p.Player_Id,
        p.Player_Name,
        COUNT(*) AS Balls_Faced,
        SUM(bbb.Runs_Scored) AS Total_Runs,
        ROUND(SUM(bbb.Runs_Scored) * 100.0 / COUNT(*), 2) AS Strike_Rate
    FROM ball_by_ball bbb
    JOIN matches m ON bbb.Match_Id = m.Match_Id
    JOIN season s ON m.Season_Id = s.Season_Id
    JOIN player p ON bbb.Striker = p.Player_Id
    WHERE s.Season_Year >= (SELECT MAX(Season_Year) - 2 FROM season)
    GROUP BY p.Player_Id, p.Player_Name
    HAVING COUNT(*) >= 30
),
bowling AS (
    SELECT 
        p.Player_Id,
        COUNT(*) AS Balls_Bowled,
        COUNT(wt.Player_out) AS Wickets,
        ROUND(COUNT(wt.Player_out) * 1.0 / COUNT(*), 2) AS Wickets_Per_Ball
    FROM ball_by_ball bbb
    JOIN matches m ON bbb.Match_Id = m.Match_Id
    JOIN season s ON m.Season_Id = s.Season_Id
    JOIN player p ON bbb.Bowler = p.Player_Id
    LEFT JOIN wicket_taken wt ON bbb.Match_Id = wt.Match_Id 
                        AND bbb.Over_Id = wt.Over_Id 
                        AND bbb.Ball_Id = wt.Ball_Id
    WHERE s.Season_Year >= (SELECT MAX(Season_Year) - 2 FROM season)
    GROUP BY p.Player_Id
    HAVING COUNT(*) >= 30
)

SELECT 
    b.Player_Name,
    b.Total_Runs,
    b.Strike_Rate,
    bw.Wickets,
    bw.Wickets_Per_Ball
FROM batting b
JOIN bowling bw ON b.Player_Id = bw.Player_Id
ORDER BY b.Total_Runs DESC, bw.Wickets DESC;