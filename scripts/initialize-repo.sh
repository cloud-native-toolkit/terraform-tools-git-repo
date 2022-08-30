#!/usr/bin/env bash

GIT_HOST="$1"
ORG="$2"
REPO="$3"
MODULE_ID="$4"

set -e

if [[ -z "${GIT_HOST}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]] || [[ -z "${MODULE_ID}" ]]; then
  echo "Usage: initialize-repo.sh HOSTNAME ORG REPO MODULE_ID"
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

if [[ ! -f "${TMP_DIR}/initialize.out" ]] || [[ $(cat "${TMP_DIR}/initialize.out") != "true" ]]; then
  echo "Skipping repo initialization"
  exit 0
fi

REPO_URL=$(gitu exists "${REPO}" -h "${GIT_HOST}" -o "${ORG}" --output json | jq -r '.http_url // empty')

REPO_DIR="${TMP_DIR}/repo-${MODULE_ID}"
START_DIR="${PWD}"

mkdir -p "${REPO_DIR}"
trap "cd ${START_DIR} && rm -rf ${REPO_DIR}" EXIT

echo "Initializing repo - ${REPO_URL}"

if [[ -n "${GIT_CA_CERT}" ]]; then
  echo "  CA Cert provided"
  echo ""
else
  echo "  CA Cert not provided"
  echo ""
fi

gitu clone "${REPO_URL}" "${REPO_DIR}" --configName "Cloud-Native Toolkit" --configEmail "cloudnativetoolkit@gmail.com" --debug || exit 1

cd "${REPO_DIR}" || exit 1

export BASE_BRANCH=$(git rev-parse --abbrev-ref HEAD)

BRANCH="init-git"

git checkout -b "${BRANCH}"

echo "${MODULE_ID}" > .owner_module

git add .owner_module
git commit -m "Saves owner_module id"
git push -u origin "${BRANCH}"

set +e
PR_RESULT=$(gitu pr create "${REPO_URL}" --sourceBranch "${BRANCH}" --output json)
set -e

PR_NUMBER=$(echo "${PR_RESULT}" | jq -r '.pullNumber // empty')

if [[ -z "${PR_NUMBER}" ]]; then
  gitu pr create "${REPO_URL}" --sourceBranch "${BRANCH}" --debug
  echo "Error creating PR: ${PR_RESULT}" >&2
  exit 1
fi

gitu pr merge "${REPO_URL}" --pullNumber "${PR_NUMBER}" --waitForBlocked=1h
