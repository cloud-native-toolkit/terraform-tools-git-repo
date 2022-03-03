#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

GH=$(command -v gh || command -v "${BIN_DIR}/gh")

HOSTNAME="$1"
ORG="$2"
REPO="$3"
MODULE_ID="$4"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: delete-github-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

export GITHUB_TOKEN="${TOKEN}"

echo "Cloning https://${HOSTNAME}/${ORG}/${REPO}"
git clone "https://${TOKEN}:${HOSTNAME}/${ORG}/${REPO}" .tmprepo

echo "Checking owner_module value"
cat .tmprepo/.owner_module

if [[ $(cat .tmprepo/.owner_module) == "${MODULE_ID}" ]]; then
  echo "Deleting repo: ${ORG}/${REPO}"
  "${GH}" api -X DELETE "repos/${ORG}/${REPO}"
fi

rm -rf .tmprepo
