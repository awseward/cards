import db_postgres
import json
import oids
import os
import sequtils
import strutils
import times

import ../timeutils

let databaseUrl = getEnv "DATABASE_URL"

type User* = object
  userId*: string
  createdAt*: DateTime

proc initUser*(userId: string = $genOid()): User =
  let query = sql"""
INSERT INTO users (user_id) VALUES (?)
-- This ON CONFLICT is a little odd, but it needs to give back the RETURNING
-- block every time for the calling code to work correctly, which would not
-- happen with ON CONFLICT DO NOTHING.
--
-- It might just be better to rework the way the caller does things, but this
-- will do for now.
--
ON CONFLICT (user_id) DO UPDATE SET user_id = users.user_id
RETURNING TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}' AS created_at"""
  let conn = open("", "", "", databaseUrl)
  try:
    let createdAt = parseUtcIso8601 conn.getValue(query, userId)
    User(userId: userId, createdAt: createdAt)
  finally:
    close conn
