
WITH match_totals AS (
    SELECT 
        b.Match_Id,
        SUM(b.Runs_Scored) AS total_match_runs
    FROM Ball_by_Ball b
    GROUP BY b.Match_Id
)

SELECT 
    ROUND(AVG(total_match_runs), 2)  AS avg_runs_per_match,
    MAX(total_match_runs)            AS highest_match_score,
    MIN(total_match_runs)            AS lowest_match_score,
    
    -- Count high scoring matches (above 350 runs total)
    SUM(CASE WHEN total_match_runs > 350 
        THEN 1 ELSE 0 END)           AS high_scoring_matches,
    
    COUNT(*)                         AS total_matches

FROM match_totals;