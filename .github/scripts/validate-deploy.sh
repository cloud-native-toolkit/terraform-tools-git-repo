#!/usr/bin/env bash

BIN_DIR=$(cat .bin_dir)

export PATH="${BIN_DIR}:${PATH}"

HOST=$(jq -r '.host' .git_output)
ORG=$(jq -r '.org' .git_output)
REPO=$(jq -r '.name' .git_output)
USERNAME=$(jq -r '.username' .git_output)
TOKEN=$(jq -r '.token' .git_output)

git clone "https://${USERNAME}:${TOKEN}@${HOST}/${ORG}/${REPO}" .repo || exit 1

echo "Repo"
ls -l .repo

if [[ ! -f .repo/.owner_module ]]; then
  echo "owner module missing" >&2
  exit 1
fi
