#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

GLAB=$(command -v glab || command -v "${BIN_DIR}/glab")

HOSTNAME="$1"
ORG="$2"
REPO="$3"
MODULE_ID="$4"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: delete-gitlab-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

"${GLAB}" auth login --hostname "${HOSTNAME}" --token "${TOKEN}"

"${GLAB}" repo delete "${ORG}/${REPO}"
