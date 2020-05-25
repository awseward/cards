import db_postgres
import json
import options
import os
import sequtils
import strutils
import times

import ../timeutils
import ../models/user

type GameStatus* = enum
  pending,
  ready,
  playing,
  done

type Game* = object
  id*: int
  created_at*: DateTime
  created_by_user_id*: string

proc `%`*(datetime: DateTime): JsonNode =
  % $datetime

let databaseUrl = getEnv "DATABASE_URL"
proc openDb(): DbConn = open("", "", "", databaseUrl)

proc fromDbRow(row: Row): Game =
  Game(
    id: parseInt row[0],
    created_at: parseUtcIso8601 row[1],
    created_by_user_id: row[2]
  )

proc initGame*(creatorId: string): Game =
  let createGameSql = sql"""
INSERT INTO games (created_by_user_id) VALUES (?)
RETURNING
  id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}' AS created_at
, created_by_user_id
"""
  let joinGameSql = sql"INSERT INTO users_games (user_id, game_id) VALUES (?, ?)"
  let conn = openDb()
  try:
    conn.exec sql"BEGIN TRANSACTION"
    let game = fromDbRow conn.getAllRows(createGameSql, creatorId)[0]
    conn.exec(joinGameSql, creatorId, $game.id)
    conn.exec sql"COMMIT"
    game
  finally:
    close conn

proc getGameStatus*(game: Game, players: seq[User] = @[]): GameStatus =
  if players.len > 1:
    ready
  else:
    pending

proc getAllGames*(): seq[Game] =
  let query = sql"""
SELECT
  id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}'
, created_by_user_id
FROM games
  """
  let conn = openDb()
  try:
    let rows = conn.getAllRows query
    rows.map fromDbRow
  finally:
    close conn

proc getGamesUserisIn*(userId: string): seq[Game] =
  let query = sql"""
SELECT
  id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}'
, created_by_user_id
FROM games g
JOIN users_games ug ON ? = ug.user_id AND g.id = ug.game_id"""
  let conn = openDb()
  try:
    let rows = conn.getAllRows(query, userId)
    rows.map fromDbRow
  finally:
    close conn

proc findGame*(id: int): Option[Game] =
  let query = sql"""
SELECT
  id
, TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}'
, created_by_user_id
FROM games
WHERE id = ?
  """
  let conn = openDb()
  try:
    let rows = conn.getAllRows(query, id)
    if rows.len == 0: none Game
    else:
      some fromDbRow(rows[0])
  finally:
    close conn

proc removeUser*(gameId: int, userId: string) =
  let query = sql"DELETE FROM users_games WHERE game_id = ? AND user_id = ?"
  let conn = openDb()
  try:
    conn.exec(query, $gameId, userId)
  finally:
    close conn

proc addUser*(gameId: int, userId: string) =
  let query = sql"INSERT INTO users_games (game_id, user_id) VALUES (?, ?)"
  let conn = openDb()
  try:
    conn.exec(query, $gameId, userId)
  finally:
    close conn
