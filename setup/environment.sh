#!/usr/bin/env bash
shopt -s globstar

REPO_ROOT=$(git rev-parse --show-toplevel)
CLUSTER_ROOT="${REPO_ROOT}/cluster"
HELM_REPOSITORIES="${CLUSTER_ROOT}/flux-system/helm-repositories"

. ${REPO_ROOT}/setup/.env

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}
