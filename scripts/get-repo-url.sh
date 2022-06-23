#!/usr/bin/env bash

INPUT=$(tee)

BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')

export PATH="${BIN_DIR}:${PATH}"

HOST=$(echo "${INPUT}" | jq -r '.host')
ORG=$(echo "${INPUT}" | jq -r '.org')
REPO=$(echo "${INPUT}" | jq -r '.repo')
export GIT_PROJECT=$(echo "${INPUT}" | jq -r '.project // empty')
export GIT_USERNAME=$(echo "${INPUT}" | jq -r '.username // empty')
export GIT_TOKEN=$(echo "${INPUT}" | jq -r '.token // empty')

set -x

REPO_URL=$(gitu exists -h "${HOST}" -o "${ORG}" "${REPO}" | jq -r '.http_url')
if [[ -z "${REPO_URL}" ]]; then
  echo "Repo not found: ${HOST}/${ORG}/${REPO}" >&2
  exit 1
fi

REPO_URI=$(echo "${REPO_URL}" | sed -E "s~^https?://~~g")

jq -n --arg URL "${REPO_URL}" --arg URI "${REPO_URI}" '{"uri": $URI, "url": $URL}'
