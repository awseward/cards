import db_postgres
import json
import os
import sequtils
import strutils
import times

type GameStatus* = enum
  pending,
  going,
  done

type Game* = object
  id*: int
  created_at*: DateTime

proc `%`*(datetime: DateTime): JsonNode =
  % $datetime

let databaseUrl = getEnv "DATABASE_URL"

proc initGame*(): Game =
  let query = sql"INSERT INTO games (created_at) VALUES (CURRENT_TIMESTAMP)"
  let conn = open("", "", "", databaseUrl)
  try:
    let id = int(conn.insertId query)
    let createdAt = block:
      let value = conn.getValue sql(
        """
SELECT
  TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}'
FROM games
WHERE id = $1""" % [$id])
      let format = initTimeFormat "yyyy-MM-dd'T'HH:mm:ss'+00:00'"
      times.parse(value, format, utc())
    Game(
      id: id,
      createdAt: createdAt
    )
  finally:
    close conn

proc getGameStatus*(game: Game): GameStatus =
  # FIXME: Look up relevant details and determine status
  pending

proc fromDbRow(row: Row): Game =
  let id = parseInt row[0]
  let createdAt = block:
    let format = initTimeFormat "yyyy-MM-dd'T'HH:mm:ss'+00:00'"
    times.parse(row[1], format, utc())

  Game(id: id, createdAt: createdAt)

proc getGames*(): seq[Game] =
  let query = sql"""
SELECT
  id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}'
FROM games
  """
  let conn = open("", "", "", databaseUrl)
  try:
    let rows = conn.getAllRows query
    rows.map fromDbRow
  finally:
    close conn
