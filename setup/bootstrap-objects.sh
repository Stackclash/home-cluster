#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

kapply() {
  if output=$(envsubst < "$@"); then
    printf '%s' "$output" | kubectl apply -f -
  fi
}

installManualObjects(){
  message "installing manual secrets and objects"

  #########################
  # cert-manager bootstrap
  #########################
  kapply "$REPO_ROOT"/kube-system/cert-manager/cloudflare-api-key.txt
  CERT_MANAGER_READY=1
  while [ $CERT_MANAGER_READY != 0 ]; do
    echo "waiting for cert-manager to be fully ready..."
    kubectl -n kube-system wait --for condition=Available deployment/cert-manager > /dev/null 2>&1
    CERT_MANAGER_READY="$?"
    sleep 5
  done
  kapply "$REPO_ROOT"/kube-system/cert-manager/letsencrypt-issuer.txt
  kapply "$REPO_ROOT"/kube-system/cert-manager/certificate.txt
}

. "$REPO_ROOT"/setup/.env

installManualObjects

message "all done!"