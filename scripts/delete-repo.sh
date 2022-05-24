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

mkdir -p .tmp

echo "Cloning https://${GIT_HOST}/${ORG}/${REPO}"
git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@${GIT_HOST}/${ORG}/${REPO}" ".tmp/${REPO}"

if [[ ! -f ".tmp/${REPO}/.owner_module" ]]; then
  echo "owner_module value missing from repo"
  exit 0
fi

echo "Checking owner_module value"
cat ".tmp/${REPO}/.owner_module"

if [[ $(cat ".tmp/${REPO}/.owner_module") == "${MODULE_ID}" ]]; then
  echo "Deleting repo: https://${GIT_HOST}/${ORG}/${REPO}"
  gitu delete "https://${GIT_HOST}/${ORG}/${REPO}"
fi

rm -rf ".tmp/${REPO}"
