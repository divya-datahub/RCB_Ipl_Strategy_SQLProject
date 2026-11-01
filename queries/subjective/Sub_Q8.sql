WITH team_matches AS (
    SELECT 
        m.Match_Id,
        m.Match_Winner,
        m.Team_1,
        m.Team_2,
        m.Venue_Id,
        t.Team_Name AS RCB_Team,
        v.Venue_Name,
        CASE 
            WHEN v.Venue_Name LIKE '%Chinnaswamy%' 
                THEN 'Home'
            ELSE 'Away'
        END AS Match_Type
    FROM matches m
    JOIN team t 
        ON t.Team_Name = 'Royal Challengers Bangalore'
        AND (m.Team_1 = t.Team_Id OR m.Team_2 = t.Team_Id)
    JOIN venue v 
        ON v.Venue_Id = m.Venue_Id
)
SELECT 
    Match_Type,
    COUNT(*)                               AS Matches_Played,
    SUM(CASE 
            WHEN Match_Winner = (
                SELECT Team_Id FROM team 
                WHERE Team_Name = 'Royal Challengers Bangalore'
            ) 
            THEN 1 ELSE 0 
        END)                               AS Matches_Won,
    ROUND(
        SUM(CASE 
                WHEN Match_Winner = (
                    SELECT Team_Id FROM team 
                    WHERE Team_Name = 'Royal Challengers Bangalore'
                ) 
                THEN 1 ELSE 0 
            END) * 100.0 / COUNT(*)
    , 2)                                   AS Win_Percentage
FROM team_matches
GROUP BY Match_Type;