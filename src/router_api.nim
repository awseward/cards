import asyncdispatch
import jester
import json
import options
import sequtils
import strutils
import ulid

import ./models/game
import ./models/user

proc enrich*(json: JsonNode, game: Game): JsonNode =
  let players = usersInGame game.id
  let status = getGameStatus(game, players)
  json["players"] = %players
  json["status"] = %status
  json

router api:
  template okText(thing: untyped): untyped =
    resp Http200, {"Content-Type": "text/plain"}, $thing

  template okJson(json: untyped): untyped =
    resp Http200, {"Content-Type": "application/json"}, $ %json

  template requireUserId(): string =
    const key = "User-Id"
    if not request.headers.hasKey key: halt Http401

    let userId = request.headers[key]
    if userId == "_": halt Http401

    userId

  get "games":
    discard requireUserId()
    okJson getAllGames()

  post "games":
    let userId = requireUserId()
    let game = initGame userId
    okJson (%game).enrich game

  get "game/@id":
    let userId = requireUserId()
    let gameOpt = findGame parseInt(@"id")
    if gameOpt.isSome():
      let game = gameOpt.get()
      okJson (%game).enrich game
    else:
      resp Http404

  put "game/@id/join":
    let userId = requireUserId()
    let gameId = parseInt @"id"
    addUser gameId, userId
    resp Http204

  put "game/@id/leave":
    let userId = requireUserId()
    let gameId = parseInt @"id"
    removeUser gameId, userId
    resp Http204
