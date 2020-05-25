#!/usr/bin/env bash

set -euo pipefail

_install_shmig() {
  local temp_dir; temp_dir="$(mktemp -d)"
  mkdir -p "${temp_dir}"
  echo "${temp_dir}" | xargs -t git clone git://github.com/mbucc/shmig.git
  export PATH="${temp_dir}:${PATH}"
}

_install_shmig
eval "$(heroku_database_url_splitter)"
echo up | xargs -t shmig
