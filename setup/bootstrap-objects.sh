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

ksecret() {
  NAMESPACE=$(echo "$1" | sed 's/^\([^/]*\)\/.*$/\1/')
  APPLICATION_NAME=$(echo "$1" | sed 's/^.*\/\(.*\)-values-secret.txt$/\1/')

  if output=$(envsubst < "${REPO_ROOT}/${1}"); then
    NAMESPACE_READY=1
    while [ $NAMESPACE_READY != 0 ]; do
      echo "waiting for $NAMESPACE namespace to be ready"
      ready=$(kubectl get ns --output=name | grep "$NAMESPACE" | tr -d '\n')
      if [ ${#ready} -ne 0 ]
      then
        NAMESPACE_READY=0
      fi
      sleep 5
    done
    kubectl create secret generic -n "$NAMESPACE" "${APPLICATION_NAME}-helm-values" --from-literal=values.yaml="$output"
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
  kapply "$REPO_ROOT"/kube-system/traefik/traefik-external-ingress.txt
  kapply "$REPO_ROOT"/kube-system/traefik/traefik-internal-ingress.txt
}

installValuesSecrets() {
  message "creating helm values secrets"

  ksecret pihole/pihole-values-secret.txt
  ksecret openfaas/openfaas-values-secret.txt
  ksecret bitwarden/bitwarden-values-secret.txt
  ksecret node-red/node-red-values-secret.txt
  ksecret home-assistant/home-assistant-values-secret.txt
  ksecret stash/stash-values-secret.txt
}

. "$REPO_ROOT"/setup/.env

installManualObjects
installValuesSecrets

message "all done!"