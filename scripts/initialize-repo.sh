#!/usr/bin/env bash

REPO_URL="$1"
MODULE_ID="$2"

set -e

if [[ -z "${REPO_URL}" ]]; then
  echo "Usage: initialize-repo.sh HOSTNAME ORG REPO"
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

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp/git-repo"
fi

REPO_DIR="${TMP_DIR}/repo-${MODULE_ID}"
START_DIR="${PWD}"

mkdir -p "${REPO_DIR}"
trap "cd ${START_DIR} && rm -rf ${REPO_DIR}" EXIT

echo "Initializing repo - ${REPO_URL}"

gitu clone "${REPO_URL}" "${REPO_DIR}" --configName "Cloud-Native Toolkit" --configEmail "cloudnativetoolkit@gmail.com" || exit 1

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
