#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GH=$(command -v gh || command -v "${BIN_DIR}/gh")

echo "GH cli - ${GH}"

HOSTNAME="$1"
ORG="$2"
REPO="$3"
PUBLIC="$4"
BRANCH="${5:-main}"
MODULE_ID="${6}"
STRICT="$7"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-github-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

export GITHUB_TOKEN="${TOKEN}"

PUBLIC_PRIVATE="--private"
if [[ "${PUBLIC}" == "true" ]]; then
  PUBLIC_PRIVATE="--public"
fi

if "${GH}" repo view ${ORG}/${REPO} --json url 1> /dev/null 2> /dev/null; then
  echo "Repo already exists"

  if [[ "${STRICT}" == "true" ]]; then
    exit 1
  else
    exit 0
  fi
else
  echo "Creating repo: ${ORG}/${REPO} ${PUBLIC_PRIVATE}"
  "${GH}" repo create -y "${ORG}/${REPO}" ${PUBLIC_PRIVATE}

  TOKEN="${TOKEN}" "${SCRIPT_DIR}/initialize-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${BRANCH}" "${MODULE_ID}"
fi
