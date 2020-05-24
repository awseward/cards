#!/usr/bin/env bash

set -euo pipefail

_shmig() {
  local temp_dir; temp_dir="$(mktemp -d)"
  echo "${temp_dir}" | xargs -t git clone git://github.com/mbucc/shmig.git
  cd "${temp_dir}"
  make install
  echo "${temp_dir}" | xargs -t rm -rf
}

_all() {
  _shmig
}

"_${1:-all}"
