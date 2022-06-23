#!/usr/bin/env bash

REPO_URL="$1"
MODULE_ID="$2"

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

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp/git-repo"
fi

REPO_DIR="${TMP_DIR}/repo-${MODULE_ID}"
START_DIR="${PWD}"

mkdir -p "${REPO_DIR}"
trap "cd ${START_DIR} && rm -rf ${REPO_DIR}" EXIT

REPO_URI=$(echo "${REPO_URL}" | sed -E "s~^https?://~~g")

echo "Initializing repo - https://${REPO_URI}"

git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@${REPO_URI}" "${REPO_DIR}"

cd "${REPO_DIR}" || exit 1

git config user.email "cloudnativetoolkit@gmail.com"
git config user.name "Cloud-Native Toolkit"

echo "${MODULE_ID}" > .owner_module
git add .owner_module
git commit -m "Saves owner_module id"
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
