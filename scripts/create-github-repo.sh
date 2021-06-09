#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
BIN_DIR=$(cd "${SCRIPT_DIR}/../bin"; pwd -P)

GH=$(command -v gh || command -v "${BIN_DIR}/gh")

HOSTNAME="$1"
ORG="$2"
REPO="$3"
PUBLIC="$4"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-github-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

echo "${TOKEN}" | gh auth login --hostname "${HOSTNAME}" --with-token

PUBLIC_PRIVATE="--private"
if [[ "${PUBLIC}" == "true" ]]; then
  PUBLIC_PRIVATE="--public"
fi

"${GH}" repo create "${ORG}/${REPO}" ${PUBLIC_PRIVATE}
