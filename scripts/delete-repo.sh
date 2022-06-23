#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

GIT_HOST="$1"
ORG="$2"
REPO="$3"
MODULE_ID="$4"

if [[ -z "${GIT_HOST}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: delete-repo.sh GIT_HOST ORG REPO"
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

echo "Sleeping for 1 minute before deleting repo to allow things to settle"
sleep 60

REPO_URL=$(gitu exists -h "${GIT_HOST}" -o "${ORG}" "${REPO}" | jq -r '.http_url // empty')
if [[ -z "${REPO_URL}" ]]; then
  echo "Repo not found"
  exit 0
fi

REPO_URI=$(echo "${REPO_URL}" | sed -E "s~^https?://~~g")

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp/git-repo"
fi

REPO_DIR="${TMP_DIR}/repo-${MODULE_ID}"
START_DIR="${PWD}"

mkdir -p "${REPO_DIR}"
trap "cd ${START_DIR} && rm -rf ${REPO_DIR}" EXIT

echo "Cloning https://${REPO_URI}"
git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@${REPO_URI}" "${REPO_DIR}"

if [[ ! -f "${REPO_DIR}/.owner_module" ]]; then
  echo "owner_module value missing from repo"
  exit 0
fi

echo "Checking owner_module value"
cat "${REPO_DIR}/.owner_module"

if [[ $(cat "${REPO_DIR}/.owner_module") == "${MODULE_ID}" ]]; then
  echo "Deleting repo: https://${REPO_URI}"
  gitu delete -h "${GIT_HOST}" -o "${ORG}" "${REPO}"
fi
