#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

INPUT=$(tee)

export BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')
TYPE=$(echo "${INPUT}" | grep "type" | sed -E 's/.*"type": ?"([^"]*)".*/\1/g')
HOSTNAME=$(echo "${INPUT}" | grep "host" | sed -E 's/.*"host": ?"([^"]*)".*/\1/g')
ORG=$(echo "${INPUT}" | grep "org" | sed -E 's/.*"org": ?"([^"]*)".*/\1/g')
REPO=$(echo "${INPUT}" | grep "repo" | sed -E 's/.*"repo": ?"([^"]*)".*/\1/g')
export TOKEN=$(echo "${INPUT}" | grep "token" | sed -E 's/.*"token": ?"([^"]*)".*/\1/g')
PUBLIC=$(echo "${INPUT}" | grep "public" | sed -E 's/.*"public": ?"([^"]*)".*/\1/g')
BRANCH=$(echo "${INPUT}" | grep "branch" | sed -E 's/.*"branch": ?"([^"]*)".*/\1/g')
MODULE_ID=$(echo "${INPUT}" | grep "module_id" | sed -E 's/.*"module_id": ?"([^"]*)".*/\1/g')
STRICT=$(echo "${INPUT}" | grep "strict" | sed -E 's/.*"strict": ?"([^"]*)".*/\1/g')


if [[ -z "${TYPE}" ]] || [[ -z "${HOSTNAME}" ]] || [[ -z "${ORG}" ]] || [[ -z "${REPO}" ]]; then
  echo "Usage: create-repo.sh TYPE HOSTNAME ORG REPO [PUBLIC]" >&2
  exit 1
fi

if [[ -z "${TOKEN}" ]]; then
  echo "TOKEN environment variable must be set" >&2
  exit 1
fi

if [[ "${TYPE}" == "github" ]]; then
  TOKEN="${TOKEN}" BIN_DIR="${BIN_DIR}" "${SCRIPT_DIR}/check-github-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${PUBLIC}" "${BRANCH}" "${MODULE_ID}"
elif [[ "${TYPE}" == "gitlab" ]]; then
  TOKEN="${TOKEN}" BIN_DIR="${BIN_DIR}" "${SCRIPT_DIR}/check-gitlab-repo.sh" "${HOSTNAME}" "${ORG}" "${REPO}" "${PUBLIC}" "${BRANCH}" "${MODULE_ID}"
else
  echo "Unsupported repo type: $TYPE" >&2
  exit 1
fi
