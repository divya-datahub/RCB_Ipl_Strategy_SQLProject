SELECT
    p.Player_Name,
    SUM(bbb.Runs_Scored)                          AS Total_Runs,
    COUNT(DISTINCT bbb.Match_Id)                  AS Innings_Played,
    COUNT(wt.Player_Out)                          AS Times_Dismissed,
    ROUND(
        SUM(bbb.Runs_Scored) /
        NULLIF(COUNT(wt.Player_Out), 0)
    , 2)                                          AS Batting_Average
FROM ball_by_ball bbb
JOIN player p
    ON bbb.Striker = p.Player_Id
LEFT JOIN wicket_taken wt
    ON  bbb.Match_Id   = wt.Match_Id
    AND bbb.Over_Id    = wt.Over_Id
    AND bbb.Ball_Id    = wt.Ball_Id
    AND bbb.Innings_No = wt.Innings_No
    AND wt.Player_Out  = bbb.Striker
GROUP BY p.Player_Id, p.Player_Name
HAVING Total_Runs > 200
ORDER BY Batting_Average DESC
LIMIT 20;