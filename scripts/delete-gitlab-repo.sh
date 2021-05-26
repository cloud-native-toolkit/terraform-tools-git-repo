#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
BIN_DIR=$(cd "${SCRIPT_DIR}/../bin"; pwd -P)

HOSTNAME="$1"
ORG="$2"
REPO="$3"

if [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: delete-gitlab-repo.sh HOSTNAME ORG REPO"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

glab auth login --hostname "${HOSTNAME}" --token "${TOKEN}"

glab repo delete "${ORG}/${REPO}"
