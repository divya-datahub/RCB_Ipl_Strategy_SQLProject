-- ============================================================
-- SQ7 Query 3: Impact of toss decision on match scores
-- Batting first vs chasing — which produces higher scores?
-- ============================================================

WITH match_runs AS (
    SELECT 
        b.Match_Id,
        SUM(b.Runs_Scored) AS total_runs
    FROM Ball_by_Ball b
    GROUP BY b.Match_Id
)

SELECT 
    td.Toss_Name                         AS toss_decision,
    COUNT(m.Match_Id)                    AS total_matches,
    ROUND(AVG(mr.total_runs), 2)         AS avg_total_runs,
    MAX(mr.total_runs)                   AS highest_match_score,

    -- What % of matches were high scoring?
    ROUND(
        SUM(CASE WHEN mr.total_runs > 320 
            THEN 1 ELSE 0 END) * 100.0 
        / COUNT(m.Match_Id), 2
    )                                    AS pct_high_scoring_matches

FROM Matches m
JOIN match_runs mr 
    ON m.Match_Id = mr.Match_Id
JOIN Toss_Decision td 
    ON m.Toss_Decide = td.Toss_Id

GROUP BY td.Toss_Name;