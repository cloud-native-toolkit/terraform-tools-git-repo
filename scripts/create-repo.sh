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

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp/git-repo"
fi
mkdir -p "${TMP_DIR}"

export GIT_HOST TMP_DIR

if gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" -q; then
  echo "Repo already exists"

  if [[ "${STRICT}" == "true" ]]; then
    exit 1
  else
    exit 0
  fi
else
  echo "Creating repo: ${ORG}/${REPO} ${PUBLIC_PRIVATE}"
  gitu create "${REPO}" -h "${GIT_HOST}" -o "${ORG}" --public="${PUBLIC}" --autoInit="true"

  if gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" 1> /dev/null; then
    REPO_URL=$(gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" | jq -r '.http_url // empty')
  else
    exit 1
  fi

  echo "Initializing repo: ${REPO_URL}"
  "${SCRIPT_DIR}/initialize-repo.sh" "${REPO_URL}" "${MODULE_ID}"
fi
