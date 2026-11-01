select 
	bs.Bowling_skill,
	COUNT(wt.Player_Out) AS Wicket_taken
from ball_by_ball as bb
join wicket_taken as wt on bb.Match_Id = wt.Match_Id and  bb.Innings_No = wt.Innings_No and bb.Over_Id = wt.Over_Id and bb.Ball_Id = wt.Ball_Id
join player as p on bb.Bowler = p.Player_Id
join bowling_style as bs on p.Bowling_skill = bs.Bowling_Id
group by bs.Bowling_skill;
