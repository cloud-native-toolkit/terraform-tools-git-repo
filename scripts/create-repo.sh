#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GIT_HOST="$1"
ORG="$2"
REPO="$3"
PUBLIC="${4:-false}"
MODULE_ID="$5"
STRICT="$6"

if [[ -z "${GIT_HOST}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-repo.sh GIT_HOST ORG REPO [PUBLIC]"
  exit 1
fi

if [[ -z "${GIT_USERNAME}" ]]; then
  echo "GIT_USERNAME environment variable must be set"
  exit 1
fi

if [[ -z "${GIT_TOKEN}" ]]; then
  echo "GIT_TOKEN environment variable must be set"
  exit 1
fi

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

export GIT_HOST

if gitu exists "${REPO}" -o "${ORG}"; then
  echo "Repo already exists"

  if [[ "${STRICT}" == "true" ]]; then
    exit 1
  else
    exit 0
  fi
else
  echo "Creating repo: ${ORG}/${REPO} ${PUBLIC_PRIVATE}"
  gitu create "${REPO}" -o "${ORG}" --public="${PUBLIC}" --autoInit="true"

  "${SCRIPT_DIR}/initialize-repo.sh" "${GIT_HOST}" "${ORG}" "${REPO}" "${MODULE_ID}"
fi
