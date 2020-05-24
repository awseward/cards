import asyncdispatch
import jester
import os
import strutils

const isHeroku* = block:
  const key = "IS_HEROKU"
  existsEnv(key) and parseBool(getEnv key)

when isHeroku:
  import ./views/assets_file

  let bundleCss* = getAsset "public/build/bundle.css"
  let bundleCssMap* = getAsset "public/build/bundle.css.map"
  let bundleJs* = getAsset "public/build/bundle.js"
  let bundleJsMap* = getAsset "public/build/bundle.js.map"
  let globalCss* = getAsset "public/global.css"
  let indexHtml* = getAsset "public/index.html"

  router web:
    get "/":
      resp indexHtml

    get "/build/bundle.js":
      resp Http200, {"Content-Type": "text/javascript"}, bundleJs

    get "/build/bundle.js.map":
      resp Http200, {"Content-Type": "application/json"}, bundleJsMap

    get "/build/bundle.css":
      resp Http200, {"Content-Type": "text/css"}, bundleCss

    get "/build/bundle.css.map":
      resp Http200, {"Content-Type": "application/json"}, bundleCssMap

    get "/global.css":
      resp Http200, {"Content-Type": "text/css"}, globalCss

else:
  router web:
    get "/":
      # Ehhh this isn't awesome, but it works for now especially since it's
      # just local dev that it affects.
      redirect "/index.html"
