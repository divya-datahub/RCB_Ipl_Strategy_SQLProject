WITH player_wins AS (
    SELECT 
        pm.Player_Id,
        p.Player_Name,
        COUNT(*) AS Matches_Played,
        SUM(CASE WHEN m.Match_winner = pm.Team_Id THEN 1 ELSE 0 END) AS Matches_Won
    FROM player_match pm
    JOIN matches m ON pm.Match_Id = m.Match_Id
    JOIN player p ON pm.Player_Id = p.Player_Id
    GROUP BY pm.Player_Id, p.Player_Name
    HAVING COUNT(*) >= 10 -- only players with decent match count
),
win_rate AS (
    SELECT 
        Player_Name,
        Matches_Played,
        Matches_Won,
        ROUND(Matches_Won * 100.0 / Matches_Played, 2) AS Win_Percentage
    FROM player_wins
)
SELECT 
    *
FROM win_rate
ORDER BY Win_Percentage DESC
LIMIT 15;
