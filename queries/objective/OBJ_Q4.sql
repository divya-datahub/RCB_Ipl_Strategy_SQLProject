SELECT 
    t.Team_Name,
    s.Season_Year,
    COUNT(*) AS Matches_Won
FROM matches m
JOIN team t 
    ON m.Match_Winner = t.Team_Id
JOIN season s 
    ON m.Season_Id = s.Season_Id
WHERE t.Team_Name = 'Royal Challengers Bangalore'
  AND s.Season_Year = 2013
GROUP BY t.Team_Name, s.Season_Year;