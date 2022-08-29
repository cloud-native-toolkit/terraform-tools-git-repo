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

if ! command -v gitu 1> /dev/null 2> /dev/null; then
  echo "gitu cli not found" >&2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq cli not found" >&2
  exit 1
fi

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp/git-repo"
fi
mkdir -p "${TMP_DIR}"

export GIT_HOST TMP_DIR

DEBUG_FLAG=""
if [[ "${DEBUG}" == "true" ]]; then
  DEBUG_FLAG="--debug"
fi

if [[ -n "${GIT_CA_CERT}" ]]; then
  echo "CA Cert provided"
  echo ""
else
  echo "CA Cert not provided"
  echo ""
fi

gitu --version

if [[ -n "${GIT_PROJECT}" ]]; then
  echo "Checking for existing repo: ${ORG}/${GIT_PROJECT}/${REPO}"
else
  echo "Checking for existing repo: ${ORG}/${REPO}"
fi
if gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" ${DEBUG_FLAG} -q 2> /dev/null; then
  echo "Repo already exists"

  if [[ "${STRICT}" == "true" ]]; then
    exit 1
  else
    exit 0
  fi
else
  if [[ -n "${GIT_PROJECT}" ]]; then
    echo "Creating repo: ${ORG}/${GIT_PROJECT}/${REPO} ${PUBLIC_PRIVATE}"
  else
    echo "Creating repo: ${ORG}/${REPO} ${PUBLIC_PRIVATE}"
  fi
  gitu create "${REPO}" -h "${GIT_HOST}" -o "${ORG}" --public="${PUBLIC}" --autoInit="true" ${DEBUG_FLAG}

  if gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" ${DEBUG_FLAG} 1> /dev/null; then
    REPO_URL=$(gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" --output json | jq -r '.http_url // empty')
  else
    exit 1
  fi

  echo "Initializing repo: ${REPO_URL}"
  "${SCRIPT_DIR}/initialize-repo.sh" "${REPO_URL}" "${MODULE_ID}"
fi
