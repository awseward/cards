# hello_nim_svelte

There are 2 environments this considers:

## Heroku

#### Buildpacks

Please note that the order of these matters.

* `heroku/nodejs`
* `https://github.com/awseward/heroku-buildpack-nim.git` (currently @ `3deb24dfb74055d0b0a891efd3bf29793594562b`)

#### Config Vars

I believe these are exclusively for the Nim buildpack, but they're currently:
```sh
IS_HEROKU=true
NIMBLE_FLAGS=-d:release
NIM_BRANCH=devel
NIM_REV=dc3919bb1af89799e391b4c4ecd0f1f60f7862ff
```

With all that set up, deploying with `git push heroku master` should be sufficient.

## Local Dev

To do local development, you can run:

```sh
nimble dev
```

This will:

* Watch svelte files, rebuilding bundle and refreshing browser on changes detected
* Watch nim files, restarting the server on changes detected
