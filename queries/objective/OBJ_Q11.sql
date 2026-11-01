WITH Season_Stats AS (
    SELECT
        t.Team_Name,
        s.Season_Year,
        SUM(bbb.Runs_Scored)        AS Total_Runs,
        COUNT(wt.Player_Out)        AS Total_Wickets
    FROM matches m
    JOIN season s
        ON m.Season_Id = s.Season_Id
    JOIN ball_by_ball bbb
        ON m.Match_Id = bbb.Match_Id
    JOIN team t
        ON bbb.Team_Batting = t.Team_Id
    LEFT JOIN wicket_taken wt
        ON  bbb.Match_Id   = wt.Match_Id
        AND bbb.Over_Id    = wt.Over_Id
        AND bbb.Ball_Id    = wt.Ball_Id
        AND bbb.Innings_No = wt.Innings_No
    GROUP BY t.Team_Name, s.Season_Year
),
Previous_Season AS (
    SELECT
        Team_Name,
        Season_Year,
        Total_Runs,
        Total_Wickets,
        LAG(Total_Runs)
            OVER (PARTITION BY Team_Name ORDER BY Season_Year)
                                    AS Prev_Runs,
        LAG(Total_Wickets)
            OVER (PARTITION BY Team_Name ORDER BY Season_Year)
                                    AS Prev_Wickets
    FROM Season_Stats
)
SELECT
    Team_Name,
    Season_Year,
    Total_Runs,
    Prev_Runs,
    Total_Wickets,
    Prev_Wickets,
    CASE
        WHEN Prev_Runs IS NULL
            THEN 'First Season'
        WHEN Total_Runs > Prev_Runs
         AND Total_Wickets > Prev_Wickets
            THEN 'Better'
        WHEN Total_Runs < Prev_Runs
         AND Total_Wickets < Prev_Wickets
            THEN 'Worse'
        ELSE 'Partially Better'
    END                             AS Performance_Status
FROM Previous_Season
ORDER BY Team_Name, Season_Year;