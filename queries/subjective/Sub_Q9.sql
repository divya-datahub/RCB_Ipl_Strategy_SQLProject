 SELECT 
    s.Season_Year,
    COUNT(m.Match_Id) AS Matches_Played,
    SUM(CASE WHEN m.Match_winner = t.Team_Id THEN 1 ELSE 0 END) AS Matches_Won,
    ROUND(SUM(CASE WHEN m.Match_winner = t.Team_Id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.Match_Id), 2) AS Win_Percentage
FROM matches m
JOIN season s ON m.Season_Id = s.Season_Id
JOIN team t ON t.Team_Name = 'Royal Challengers Bangalore'
WHERE m.Team_1 = t.Team_Id OR m.Team_2 = t.Team_Id
GROUP BY s.Season_Year
ORDER BY s.Season_Year;