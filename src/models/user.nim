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
ON CONFLICT DO NOTHING
RETURNING TO_JSON(DATE_TRUNC('SECOND', created_at))#>>'{}' AS created_at"""
  let conn = open("", "", "", databaseUrl)
  try:
    let createdAt = parseUtcIso8601 conn.getValue(query, userId)
    User(userId: userId, createdAt: createdAt)
  finally:
    close conn
