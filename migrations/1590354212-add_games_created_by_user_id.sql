-- Migration: add_games_created_by_user_id
-- Created at: 2020-05-24 14:03:32
-- ====  UP  ====

BEGIN;

  INSERT INTO users (user_id) VALUES ('_');

  ALTER TABLE games ADD COLUMN created_by_user_id TEXT NOT NULL DEFAULT '_' REFERENCES users(user_id);

  ALTER TABLE games ALTER COLUMN created_by_user_id DROP DEFAULT;

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE games DROP COLUMN created_by_user_id;

  DELETE FROM users WHERE user_id = '_';

COMMIT;
