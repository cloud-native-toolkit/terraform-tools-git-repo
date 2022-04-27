#!/usr/bin/env bash

HOSTNAME="$1"
ORG="$2"
REPO="$3"
BRANCH="$4"
MODULE_ID="$5"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: initialize-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

mkdir -p .tmprepo

cd .tmprepo || exit 1

git init
git remote add origin "https://${TOKEN}@${HOSTNAME}/${ORG}/${REPO}"

git config user.email "cloudnativetoolkit@gmail.com"
git config user.name "Cloud-Native Toolkit"

echo "# ${REPO}" > README.md
git add README.md
echo "${MODULE_ID}" > .owner_module
git add .owner_module
git commit -m "Initial commit"
git branch -m "$(git rev-parse --abbrev-ref HEAD)" "${BRANCH}"
git push -u origin "${BRANCH}"

cd ..
rm -rf .tmprepo
