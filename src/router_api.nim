import asyncdispatch
import jester
import json
import sequtils
import times
import ulid

import ./models/game

var games*: seq[Game] = @[initGame(), initGame()]

router api:
  template okText(thing: untyped): untyped =
    resp Http200, {"Content-Type": "text/plain"}, $thing
  template okJson(json: untyped): untyped =
    resp Http200, {"Content-Type": "application/json"}, $ %json

  get "games":
    okJson games

  post "games":
    let game = initGame()
    games.add game
    let jsonNode = %game
    jsonNode["status"] = %(getGameStatus game)
    okJson jsonNode

  get "game/@id":
    okText "TODO: Show endpoint for game " & @"id"
