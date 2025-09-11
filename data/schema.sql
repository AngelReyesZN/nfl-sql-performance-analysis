-- Creacion del schema
CREATE DATABASE IF NOT EXISTS nfl_stats;
USE nfl_stats;

-- Tabla de equipos
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50),
    city VARCHAR(50),
    conference VARCHAR(10),
    division VARCHAR(10)
);

-- Tabla de jugadores
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(10),
    team_id INT,
    height INT, -- en cm
    weight INT, -- en kg
    college VARCHAR(50),
    experience_years INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Tabla de partidos
CREATE TABLE Games (
    game_id INT PRIMARY KEY,
    season INT,
    week INT,
    home_team_id INT,
    away_team_id INT,
    home_score INT,
    away_score INT,
    stadium VARCHAR(50),
    date DATE,
    FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
);

-- Tabla de estadísticas de jugadores por partido
CREATE TABLE PlayerStats (
    stat_id INT PRIMARY KEY,
    game_id INT,
    player_id INT,
    passing_yards INT,
    rushing_yards INT,
    receiving_yards INT,
    touchdowns INT,
    interceptions INT,
    tackles INT,
    sacks INT,
    fumbles INT,
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

