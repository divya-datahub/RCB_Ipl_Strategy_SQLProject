WITH player_season_runs AS (
    SELECT 
        p.Player_Name,
        s.Season_Year,
        SUM(b.Runs_Scored) AS season_runs,
        COUNT(DISTINCT b.Match_Id) AS matches_played
    FROM ball_by_ball b
    JOIN player p ON b.Striker = p.Player_Id
    JOIN matches m ON b.Match_Id = m.Match_Id
    JOIN season s ON m.Season_Id = s.Season_Id
    GROUP BY p.Player_Id, p.Player_Name, s.Season_Id, s.Season_Year
),

consistency_stats AS (
    SELECT 
        Player_Name,
        COUNT(Season_Year) AS seasons_played,
        ROUND(AVG(season_runs), 2) AS avg_season_runs,
        ROUND(STDDEV(season_runs), 2) AS std_dev_runs,
        MIN(season_runs) AS min_season_runs,
        MAX(season_runs) AS max_season_runs,
        -- Coefficient of Variation: lower = more consistent
        ROUND(STDDEV(season_runs) / NULLIF(AVG(season_runs), 0) * 100, 2) AS cv_pct
    FROM player_season_runs
    GROUP BY Player_Name
    HAVING COUNT(Season_Year) >= 4   -- played in at least 4 seasons
)

SELECT 
    Player_Name,
    seasons_played,
    avg_season_runs,
    std_dev_runs,
    cv_pct,
    CASE 
        WHEN cv_pct < 30 THEN 'Highly Consistent'
        WHEN cv_pct BETWEEN 30 AND 60 THEN 'Moderately Consistent'
        ELSE 'Inconsistent'
    END AS consistency_rating
FROM consistency_stats
ORDER BY cv_pct ASC, avg_season_runs DESC;