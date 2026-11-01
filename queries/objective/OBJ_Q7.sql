SELECT 
    p.Player_Name,
    s.Season_Year,
    COUNT(DISTINCT CONCAT(wt.Match_Id, '-', wt.Over_Id, '-', wt.Ball_Id)) AS Total_Wickets,
    COUNT(DISTINCT b.Match_Id) AS Matches_Played,
    ROUND(
        COUNT(DISTINCT CONCAT(wt.Match_Id, '-', wt.Over_Id, '-', wt.Ball_Id)) / 
        COUNT(DISTINCT b.Match_Id), 2
    ) AS Avg_Wickets_Per_Match
FROM 
    ball_by_ball b
JOIN wicket_taken wt 
    ON b.Match_Id = wt.Match_Id 
    AND b.Over_Id = wt.Over_Id 
    AND b.Ball_Id = wt.Ball_Id
JOIN matches m ON b.Match_Id = m.Match_Id
JOIN season s ON m.Season_Id = s.Season_Id
JOIN player p ON b.Bowler = p.Player_Id
WHERE 
    wt.Kind_Out IS NOT NULL
GROUP BY 
    p.Player_Name, s.Season_Year
ORDER BY 
    p.Player_Name, s.Season_Year;