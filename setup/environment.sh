#!/usr/bin/env bash
shopt -s globstar

export REPO_ROOT=$(git rev-parse --show-toplevel)
export CLUSTER_ROOT="${REPO_ROOT}/cluster"
export HELM_REPOSITORIES="${CLUSTER_ROOT}/flux-system/helm-repositories"
export GENERATED_SECRETS="${CLUSTER_ROOT}/_sealed-secrets.yml"

. ${REPO_ROOT}/setup/.env

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}
