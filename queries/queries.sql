-- 1 
WITH winners as (
SELECT home_team_id AS winner from games
WHERE home_score > away_score
UNION ALL
SELECT away_team_id as winner from games
WHERE away_score > home_score
)
SELECT t.team_name, COUNT(t.team_name) AS winns FROM winners w
JOIN teams t ON w.winner = t.team_id
GROUP BY t.team_name
ORDER BY winns DESC LIMIT 1;

-- 2
WITH team_scores AS (
    SELECT home_team_id AS team_id, home_score AS score FROM games
    UNION ALL
    SELECT away_team_id AS team_id, away_score AS score FROM games
)
SELECT 
    t.team_name,
    AVG(ts.score) AS avg_points,
    DENSE_RANK() OVER(ORDER BY AVG(ts.score) DESC) AS ranking
FROM team_scores ts
JOIN teams t ON t.team_id = ts.team_id
GROUP BY t.team_name;

 -- 3
 WITH diferencias as (
SELECT home_team_id as team_id, home_score as puntos_favor, away_score as puntos_contra FROM games
UNION ALL 
SELECT away_team_id as team_id, away_score as puntos_favor, home_score as puntos_contra FROM games
)
SELECT t.team_name, SUM(d.puntos_favor) - SUM(d.puntos_contra) AS diff_points
FROM diferencias d
JOIN teams t ON t.team_id = d.team_id
GROUP BY t.team_name
ORDER BY diff_points DESC;

-- 4
SELECT 
	p.name,
    SUM(passing_yards+rushing_yards+receiving_yards) AS total_yards,
    DENSE_RANK() OVER (ORDER BY SUM(ps.passing_yards+ps.rushing_yards+ps.receiving_yards) DESC) AS ranking
FROM
    playerstats ps
JOIN players p ON ps.player_id = p.player_id
GROUP BY p.name
ORDER BY ranking;

-- 5 
SELECT 
    p.name, ROUND(AVG(ps.passing_yards), 2) AS avg_passing_yards
FROM
    playerstats ps
        JOIN
    players p ON ps.player_id = p.player_id
WHERE
    p.position = 'QB'
GROUP BY p.name , p.player_id
ORDER BY avg_passing_yards DESC
LIMIT 5; 

-- 6 
SELECT 
    p.name, SUM(ps.rushing_yards) AS total_rushing_yards
FROM
    playerstats ps
        JOIN
    players p ON ps.player_id = p.player_id
WHERE
    p.position = 'RB'
GROUP BY p.player_id , p.name
ORDER BY total_rushing_yards DESC;

-- 7
SELECT 
    p.name, SUM(ps.touchdowns) AS total_touchdowns
FROM
    playerstats ps
        JOIN
    players p ON ps.player_id = p.player_id
GROUP BY p.player_id , p.name
HAVING SUM(ps.touchdowns) > 0
ORDER BY total_touchdowns DESC;

-- 8
SELECT 
    p.name,
    SUM(ps.fumbles + ps.interceptions) AS total_lost_balls
FROM
    playerstats ps
        JOIN
    players p ON ps.player_id = p.player_id
GROUP BY p.player_id , p.name
HAVING SUM(ps.fumbles + ps.interceptions) > 0
ORDER BY total_lost_balls DESC;

-- 9 
SELECT p.name, SUM(ps.sacks + ps.tackles) as total_defensive_actions FROM playerstats ps
JOIN players p ON ps.player_id = p.player_id
GROUP BY p.player_id, p.name
HAVING SUM(ps.sacks + ps.tackles) > 0
ORDER BY total_defensive_actions DESC;

-- 10
SELECT 
    t.team_name,
    COALESCE(h.home_wins, 0) AS home_wins,
    COALESCE(a.away_wins, 0) AS away_wins,
    COALESCE(h.home_wins, 0) - COALESCE(a.away_wins, 0) AS home_advantage
FROM teams t
LEFT JOIN (
    SELECT 
        home_team_id AS team_id, 
        COUNT(*) AS home_wins 
    FROM games
    WHERE home_score > away_score
    GROUP BY home_team_id
) h ON t.team_id = h.team_id
LEFT JOIN (
    SELECT 
        away_team_id AS team_id, 
        COUNT(*) AS away_wins 
    FROM games
    WHERE away_score > home_score
    GROUP BY away_team_id
) a ON t.team_id = a.team_id
ORDER BY home_advantage DESC;

-- 11
SELECT 
    stadium, AVG(home_score + away_score) AS avg_score
FROM
    games
GROUP BY stadium
ORDER BY avg_score DESC;

-- 12 
WITH game_totals AS (
    SELECT 
        g.game_id,
        SUM(ps.passing_yards + ps.rushing_yards + ps.receiving_yards) AS total_yards_game,
        SUM(g.home_score + g.away_score) AS total_points_game
    FROM playerstats ps
    JOIN games g ON ps.game_id = g.game_id
    GROUP BY g.game_id
)
SELECT 
    (COUNT(*) * SUM(total_yards_game * total_points_game) - SUM(total_yards_game) * SUM(total_points_game))
    / SQRT(
        (COUNT(*) * SUM(total_yards_game * total_yards_game) - POW(SUM(total_yards_game),2))
        * (COUNT(*) * SUM(total_points_game * total_points_game) - POW(SUM(total_points_game),2))
    ) AS correlation_coefficient
FROM game_totals; -- 0.17 weak correlation 

-- 13	
SELECT 
    game_id, (home_score + away_score) AS combinated_points
FROM
    games
ORDER BY combinated_points DESC
LIMIT 5;

-- 14
SELECT 
    p.name,
    SUM(ps.passing_yards + ps.receiving_yards + ps.receiving_yards) AS total_yards,
    SUM(ps.interceptions + ps.fumbles) AS total_losses,
    SUM(ps.touchdowns) AS total_touchdowns
FROM
    playerstats ps
        JOIN
    players p ON ps.player_id = p.player_id
GROUP BY ps.player_id
HAVING total_yards > 0;



