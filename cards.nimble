# Package

version       = "0.1.0"
author        = "Andrew Seward"
description   = "Trying out nim with svelte"
license       = "MIT"
srcDir        = "src"
bin           = @["web"]



# Dependencies

requires "jester >= 0.4.3"
requires "nim >= 1.2.0"
requires "nimassets >= 0.1.0"
requires "ulid >= 0.3.0"

requires "https://github.com/awseward/heroku_database_url_splitter#90c6f65"



# Tasks
task dev, "Run a dev server":
  # The sleep here actually matters so you have a chance to ^C this whole
  # thing. Otherwise it'll run away on you.
  exec "while true; do sleep 1 && find src -type f -name '*.nim' | entr -d -r npm run dev; done"

task dev_ports_cleanup, "If the dev server isn't up, but ports are still taken, use this":
  exec "lsof -i :35729 -i :5000 | tail -n +2 | awk '{ print $2 }' | xargs kill"

task svelte, "Generate svelte bundle":
  exec "npm run build"

task assets, "Generate packaged assets":
  exec "mkdir -vp src/views && echo src/views/assets_file.nim | xargs -t -I{} nimassets --dir=public --output={}"

task pretty, "Run nimpretty on all .nim files in the repo":
  exec "find . -type f -not -name 'assets_file.nim' -name '*.nim' | xargs -n1 nimpretty --indent:2 --maxLineLen:120"

task heroku_build, "Steps to perform during the heroku build phase":
  exec "echo '--accept' | nimble install --depsOnly"
  exec "echo assets | xargs -t nimble"
  exec "mkdir -vp .bin/"
  exec "echo .bin/ | xargs -t cp \"$(which heroku_database_url_splitter)\""
  exec """
temp_dir="$(mktemp -d)"
mkdir -vp "${temp_dir}"
echo "${temp_dir}" | xargs -t git clone git://github.com/mbucc/shmig.git
echo .bin/ | xargs -t cp "${temp_dir}/shmig"
"""
