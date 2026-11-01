-- ============================================================
-- SQ7 Query 4: Season-wise scoring trends
-- Are IPL matches getting higher scoring over the years?
-- ============================================================

WITH season_match_runs AS (
    SELECT 
        m.Season_Id,
        b.Match_Id,
        SUM(b.Runs_Scored) AS match_runs
    FROM Ball_by_Ball b
    JOIN Matches m ON b.Match_Id = m.Match_Id
    GROUP BY m.Season_Id, b.Match_Id
)

SELECT 
    s.Season_Year,
    COUNT(DISTINCT smr.Match_Id)       AS total_matches,
    ROUND(AVG(smr.match_runs), 2)      AS avg_runs_per_match,
    MAX(smr.match_runs)                AS highest_match_score,

    -- Year on year change using LAG
    ROUND(
        AVG(smr.match_runs) - 
        LAG(ROUND(AVG(smr.match_runs),2)) 
        OVER (ORDER BY s.Season_Year), 
    2)                                 AS change_from_prev_season

FROM season_match_runs smr
JOIN Season s ON smr.Season_Id = s.Season_Id

GROUP BY s.Season_Id, s.Season_Year
ORDER BY s.Season_Year;