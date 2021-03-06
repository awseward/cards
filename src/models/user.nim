import json
import oids
import os
import sequtils
import strutils
import times

import ../db
import ../timeutils

let db_open = open_pg

type User* = object
  user_id*: string
  created_at*: DateTime

proc fromDbRow(row: Row) : User =
  User(
    user_id: row[0],
    created_at: parseUtcIso8601 row[1]
  )

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
RETURNING
  user_id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}' AS created_at"""
  db_open.use conn:
    fromDbRow conn.getRow(query, userId)

proc usersInGame*(gameId: int): seq[User] =
  let query = sql"""
SELECT
  u.user_id
, TO_JSON(DATE_TRUNC('SECOND', u.created_at))#>>'{}' AS created_at
FROM users u
JOIN users_games ug ON ug.game_id = ?
                   AND u.user_id = ug.user_id"""
  db_open.use conn:
    let rows = conn.getAllRows(query, gameId)
    rows.map fromDbRow
