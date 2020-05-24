-- Migration: add_users_games
-- Created at: 2020-05-24 13:26:30
-- ====  UP  ====

BEGIN;

  CREATE TABLE users_games (
    user_id TEXT NOT NULL REFERENCES users(user_id),
    game_id INT NOT NULL REFERENCES games(id),
    UNIQUE(user_id, game_id)
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP TABLE users_games;

COMMIT;
