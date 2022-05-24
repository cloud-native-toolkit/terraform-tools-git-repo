#!/usr/bin/env bash

HOSTNAME="$1"
ORG="$2"
REPO="$3"
MODULE_ID="$4"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
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

mkdir -p .tmp

git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@${HOSTNAME}/${ORG}/${REPO}" "./tmp${REPO}"

cd "./tmp${REPO}"

git config user.email "cloudnativetoolkit@gmail.com"
git config user.name "Cloud-Native Toolkit"

echo "${MODULE_ID}" > .owner_module
git add .owner_module
git commit -m "Saves owner_module id"
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

cd -

rm -rf ".tmp/${REPO}"
