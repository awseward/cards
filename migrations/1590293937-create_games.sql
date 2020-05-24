-- Migration: create_games
-- Created at: 2020-05-23 21:18:57
-- ====  UP  ====

BEGIN;

  CREATE TABLE games (
    id         SERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP TABLE games;

COMMIT;
