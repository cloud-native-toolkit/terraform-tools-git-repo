#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

GH=$(command -v gh || command -v "${BIN_DIR}/gh")

HOSTNAME="$1"
ORG="$2"
REPO="$3"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: delete-github-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

echo "${TOKEN}" | "${GH}" auth login --hostname "${HOSTNAME}" --with-token -s delete_repo

"${GH}" api -X DELETE "repos/${ORG}/${REPO}"
