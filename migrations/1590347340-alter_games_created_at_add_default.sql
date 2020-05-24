-- Migration: alter_games_created_at_add_default
-- Created at: 2020-05-24 12:09:00
-- ====  UP  ====

BEGIN;

  ALTER TABLE games ALTER COLUMN created_at SET DEFAULT NOW();

COMMIT;

-- ==== DOWN ====

BEGIN;

  ALTER TABLE games ALTER COLUMN created_at DROP DEFAULT;

COMMIT;
