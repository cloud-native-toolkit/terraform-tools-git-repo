#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GLAB=$(command -v glab || command -v "${BIN_DIR}/glab")

echo "GLAB cli - ${GLAB}"

HOSTNAME="$1"
ORG="$2"
REPO="$3"
PUBLIC="$4"
BRANCH="${5:-main}"
MODULE_ID="$6"
STRICT="$7"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-gitlab-repo.sh HOSTNAME ORG REPO" >&2
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set" >&2
  exit 1
fi

"${GLAB}" auth login --hostname "${HOSTNAME}" --token "${TOKEN}" 1> /dev/null

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
  "${GLAB}" repo create "${ORG}/${REPO}" ${PUBLIC_PRIVATE}

  TOKEN="${TOKEN}" "${SCRIPT_DIR}/initialize-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${BRANCH}" "${MODULE_ID}"
fi
