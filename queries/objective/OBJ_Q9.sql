CREATE TABLE rcb_record AS
SELECT 
    v.Venue_Id,
    SUM(CASE WHEN m.Match_winner = 2 THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN m.Match_winner != 2 AND (m.Team_1 = 2 OR m.Team_2 = 2) THEN 1 ELSE 0 END) AS Losses
FROM matches m
JOIN venue v ON m.Venue_id = v.Venue_id
WHERE m.Team_1 = 2 OR m.Team_2 = 2
GROUP BY v.Venue_Id;