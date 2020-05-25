-- Migration: add_users_games_foreign_key_set_cascade_delete
-- Created at: 2020-05-25 00:45:42
-- ====  UP  ====

BEGIN;

  ALTER TABLE users_games DROP CONSTRAINT users_games_game_id_fkey;

  ALTER TABLE users_games ADD CONSTRAINT users_games_game_id_fkey
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE;

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE users_games DROP CONSTRAINT users_games_game_id_fkey;

  ALTER TABLE users_games ADD CONSTRAINT users_games_game_id_fkey
    FOREIGN KEY (game_id) REFERENCES games(id);

COMMIT;
