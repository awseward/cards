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

  get "games":
    okJson getGames()

  post "games":
    let game = initGame()
    let jsonNode = %game
    jsonNode["status"] = %(getGameStatus game)
    okJson jsonNode

  get "game/@id":
    let gameOpt = findGame parseInt(@"id")
    if gameOpt.isSome():
      let game = gameOpt.get()
      let jsonNode = %game
      jsonNode["status"] = %(getGameStatus game)
      okJson jsonNode
    else:
      resp Http404
