import db_postgres
import json
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

proc initGame*(): Game =
  Game(
    id: 4, # This is just temporary
    created_at: now()
  )

proc getGameStatus*(game: Game): GameStatus =
  # FIXME: Look up relevant details and determine status
  pending
