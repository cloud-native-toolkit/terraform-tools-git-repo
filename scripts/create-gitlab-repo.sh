#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GLAB=$(command -v glab || command -v "${BIN_DIR}/glab")

echo "GLAB cli - ${GLAB}"

HOSTNAME="$1"
ORG="$2"
REPO="$3"
PUBLIC="$4"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-gitlab-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

"${GLAB}" auth login --hostname "${HOSTNAME}" --token "${TOKEN}"

PUBLIC_PRIVATE="--private"
if [[ "${PUBLIC}" == "true" ]]; then
  PUBLIC_PRIVATE="--public"
fi

"${GLAB}" repo create "${ORG}/${REPO}" ${PUBLIC_PRIVATE}
