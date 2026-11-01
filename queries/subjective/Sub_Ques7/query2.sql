
WITH match_venue_runs AS (
    SELECT 
        b.Match_Id,
        m.Venue_Id,
        SUM(b.Runs_Scored) AS match_runs
    FROM Ball_by_Ball b
    JOIN Matches m ON b.Match_Id = m.Match_Id
    GROUP BY b.Match_Id, m.Venue_Id
)

SELECT 
    v.Venue_Name,
    COUNT(mvr.Match_Id)              AS matches_played,
    ROUND(AVG(mvr.match_runs), 2)    AS avg_runs_per_match,
    MAX(mvr.match_runs)              AS highest_score_at_venue,

    -- Flag venues as high scoring or normal
    CASE 
        WHEN AVG(mvr.match_runs) > 300 
        THEN 'High Scoring Venue'
        WHEN AVG(mvr.match_runs) > 260 
        THEN 'Average Venue'
        ELSE 'Low Scoring Venue'
    END AS venue_type

FROM match_venue_runs mvr
JOIN Venue v ON mvr.Venue_Id = v.Venue_Id

GROUP BY v.Venue_Id, v.Venue_Name

-- Only venues with at least 5 matches for reliability
HAVING COUNT(mvr.Match_Id) >= 5

ORDER BY avg_runs_per_match DESC;