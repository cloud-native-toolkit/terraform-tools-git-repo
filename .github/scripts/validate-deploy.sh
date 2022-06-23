#!/usr/bin/env bash

BIN_DIR=$(cat .bin_dir)

export PATH="${BIN_DIR}:${PATH}"

REPO=$(jq -r '.repo' .git_output)
USERNAME=$(jq -r '.username' .git_output)
TOKEN=$(jq -r '.token' .git_output)

echo "Cloning repo: ${REPO}"

git clone "https://${USERNAME}:${TOKEN}@${REPO}" .repo || exit 1

echo "Repo"
ls -l .repo

if [[ ! -f .repo/.owner_module ]]; then
  echo "owner module missing" >&2
  exit 1
fi
