#!/usr/bin/env bash

set -euo pipefail

_install_shmig() {
  local temp_dir; temp_dir="$(mktemp -d)"
  mkdir -p "${temp_dir}"
  echo "${temp_dir}" | xargs -t git clone git://github.com/mbucc/shmig.git
  export PATH="${temp_dir}:${PATH}"
}

_host() {
  echo "${1}" | sed -E 's/^.*@([^:]+):.*$/\1/'
}

_port() {
  echo "${1}" | sed -E 's/^.*:([^\/]+)\/.*$/\1/'
}

_login() {
  echo "${1}" | sed -E 's/^.*:\/\/([^:]+):.*$/\1/'
}

_password() {
  echo "${1}" | sed -E 's/^.*:([^@]+)@.*$/\1/'
}

_name() {
  echo "${1}" | sed -E 's/^.*\/(.*)$/\1/'
}

DATABASE_HOST="$(_host "${DATABASE_URL}")"; export DATABASE_HOST
DATABASE_PORT="$(_port "${DATABASE_URL}")"; export DATABASE_PORT
DATABASE_LOGIN="$(_login "${DATABASE_URL}")"; export DATABASE_LOGIN
DATABASE_PASSWORD="$(_password "${DATABASE_URL}")"; export DATABASE_PASSWORD
DATABASE_NAME="$(_name "${DATABASE_URL}")"; export DATABASE_NAME

_install_shmig
echo up | xargs -t shmig
