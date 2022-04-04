#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

export PATH="${BIN_DIR}:${PATH}"

if ! command -v glab 1> /dev/null 2> /dev/null; then
  echo "glab cli not found" >&2
  exit 1
fi

HOSTNAME="$1"
ORG="$2"
REPO="$3"
PUBLIC="$4"
BRANCH="${5:-main}"
MODULE_ID="$6"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-gitlab-repo.sh HOSTNAME ORG REPO" >&2
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set" >&2
  exit 1
fi

glab auth login --hostname "${HOSTNAME}" --token "${TOKEN}" 1> /dev/null || exit 1

PUBLIC_PRIVATE="--private"
if [[ "${PUBLIC}" == "true" ]]; then
  PUBLIC_PRIVATE="--public"
fi

if glab repo view ${ORG}/${REPO} --json url 1> /dev/null 2> /dev/null; then
  if [[ "${STRICT}" == "true" ]]; then
    echo "Repo already exists and the module is set to STRICT" >&2
    exit 1
  else
    echo '{"provision": false}'
    exit 0
  fi
else
  echo '{"provision": true}'
  exit 0
fi
