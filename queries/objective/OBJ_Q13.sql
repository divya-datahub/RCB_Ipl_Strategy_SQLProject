WITH Bowler_Venue_Stats AS (
    SELECT
        p.Player_Name,
        v.Venue_Name,
        COUNT(DISTINCT wt.Match_Id)         AS Matches_Played,
        COUNT(wt.Player_Out)                AS Total_Wickets,
        ROUND(
            COUNT(wt.Player_Out) /
            NULLIF(COUNT(DISTINCT wt.Match_Id), 0)
        , 2)                                AS Avg_Wickets
    FROM wicket_taken wt
    JOIN ball_by_ball bbb
        ON  wt.Match_Id   = bbb.Match_Id
        AND wt.Over_Id    = bbb.Over_Id
        AND wt.Ball_Id    = bbb.Ball_Id
        AND wt.Innings_No = bbb.Innings_No
    JOIN player p
        ON bbb.Bowler = p.Player_Id
    JOIN matches m
        ON wt.Match_Id = m.Match_Id
    JOIN venue v
        ON m.Venue_Id = v.Venue_Id
    GROUP BY p.Player_Name, v.Venue_Name
    HAVING Total_Wickets >= 3
)
SELECT
    Venue_Name,
    Player_Name,
    Matches_Played,
    Total_Wickets,
    Avg_Wickets,
    RANK() OVER (
        PARTITION BY Venue_Name
        ORDER BY Avg_Wickets DESC
    )                                       AS Venue_Rank
FROM Bowler_Venue_Stats
ORDER BY Venue_Name, Venue_Rank
LIMIT 50;