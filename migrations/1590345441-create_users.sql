-- Migration: create_users
-- Created at: 2020-05-24 11:37:21
-- ====  UP  ====

BEGIN;

  CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    user_id    TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );

COMMIT;

-- ==== DOWN ====

BEGIN;

  DROP TABLE users;

COMMIT;
