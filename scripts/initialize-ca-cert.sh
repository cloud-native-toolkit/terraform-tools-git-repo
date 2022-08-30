#!/usr/bin/env bash

INPUT=$(tee)

BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')

export PATH="${BIN_DIR}:${PATH}"

export CA_CERT=$(echo "${INPUT}" | jq -r '.ca_cert')
export CA_CERT_FILE=$(echo "${INPUT}" | jq -r '.ca_cert_file')
export TMP_DIR=$(echo "${INPUT}" | jq -r '.tmp_dir')

if [[ -n "${CA_CERT_FILE}" ]] && [[ -f "${CA_CERT_FILE}" ]]; then
  jq -n --arg FILE "${CA_CERT_FILE}" '{"ca_cert_file": $FILE}'
  exit 0
fi

if [[ -n "${CA_CERT}" ]]; then
  if [[ -z "${CA_CERT_FILE}" ]]; then
    mkdir -p "${TMP_DIR}"
    CA_CERT_FILE="${TMP_DIR}/git-ca.crt"
  fi

  echo "${CA_CERT}" | base64 -d > "${CA_CERT_FILE}"
  jq -n --arg FILE "${CA_CERT_FILE}" '{"ca_cert_file": $FILE}'
  exit 0
fi

jq -n '{"ca_cert_file": ""}'
