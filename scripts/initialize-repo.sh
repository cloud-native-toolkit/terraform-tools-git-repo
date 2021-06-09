#!/usr/bin/env bash

HOSTNAME="$1"
ORG="$2"
REPO="$3"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: initialize-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

mkdir -p .tmprepo

git config --global user.email "cloudnativetoolkit@gmail.com"
git config --global user.name "Cloud-Native Toolkit"

git clone "https://${TOKEN}@${HOSTNAME}/${ORG}/${REPO}" .tmprepo

cd .tmprepo || exit 1

echo "# ${REPO}" > README.md
git add README.md
git commit -m "Initial commit"
git branch -m $(git rev-parse --abbrev-ref HEAD) main
git push

cd ..
rm -rf .tmprepo
