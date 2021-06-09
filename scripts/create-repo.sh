#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

TYPE="$1"
HOSTNAME="$2"
ORG="$3"
REPO="$4"
PUBLIC="$5"

if [[ -z "${TYPE}" ]] || [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-repo.sh TYPE HOSTNAME ORG REPO [PUBLIC]"
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set"
  exit 1
fi

if [[ -z "${USER}" ]]; then
  echo "USER environment variable must be set"
  exit 1
fi

if [[ "${TYPE}" == "github" ]]; then
  TOKEN="${TOKEN}" USER="${USER}" "${SCRIPT_DIR}/create-github-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${PUBLIC}"
elif [[ "${TYPE}" == "gitlab" ]]; then
  TOKEN="${TOKEN}" USER="${USER}" "${SCRIPT_DIR}/create-gitlab-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${PUBLIC}"
else
  echo "Unsupported repo type: $TYPE"
  exit 1
fi
