SELECT 
    v.Venue_Name,
    td.Toss_Name AS Toss_Decision,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN m.Toss_winner = m.Match_winner THEN 1 ELSE 0 END) AS Wins_After_Toss,
    ROUND(
        SUM(CASE WHEN m.Toss_winner = m.Match_winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS Win_Percentage
FROM  matches m
JOIN toss_decision td ON m.Toss_Decide = td.Toss_Id
JOIN venue v ON m.Venue_Id = v.Venue_Id
GROUP BY v.Venue_Name, td.Toss_Name
ORDER BY v.Venue_Name, Win_Percentage DESC;