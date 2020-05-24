import asyncdispatch
import jester

router api:
  get "/":
    resp Http200, "API endpoints here"
