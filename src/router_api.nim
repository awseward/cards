import asyncdispatch
import jester
import json
import options
import sequtils
import strutils
import ulid

import ./models/game

router api:
  template okText(thing: untyped): untyped =
    resp Http200, {"Content-Type": "text/plain"}, $thing

  template okJson(json: untyped): untyped =
    resp Http200, {"Content-Type": "application/json"}, $ %json

  template ensureUserId(): string =
    const key = "User-Id"
    if not request.headers.hasKey key: halt Http401
    let userId = request.headers[key]
    if userId == "_": halt Http401
    userId

  get "games":
    let userId = ensureUserId()
    okJson getGamesUserIsIn(userId)

  post "games":
    let userId = ensureUserId()
    let game = initGame userId
    let jsonNode = %game
    jsonNode["status"] = %(getGameStatus game)
    okJson jsonNode

  get "game/@id":
    let userId = ensureUserId()
    let gameOpt = findGame parseInt(@"id")
    if gameOpt.isSome():
      let game = gameOpt.get()
      let jsonNode = %game
      jsonNode["status"] = %(getGameStatus game)
      okJson jsonNode
    else:
      resp Http404
