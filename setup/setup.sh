#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"
need "helm"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

ksecret() {
  NAMESPACE=$(echo "$1" | sed 's/^\([^/]*\)\/.*$/\1/')
  APPLICATION_NAME=$(echo "$1" | sed 's/^.*\/\(.*\)-values-secret.txt$/\1/')

  if output=$(envsubst < "${REPO_ROOT}/${1}"); then
    kubectl create ns "$NAMESPACE"
    kubectl create secret generic -n "$NAMESPACE" "${APPLICATION_NAME}-helm-values" --from-literal=values.yaml="$output"
  fi
}

installValuesSecrets() {
  message "creating helm values secrets"

  ksecret pihole/pihole-values-secret.txt
  ksecret openfaas/openfaas-values-secret.txt
  ksecret bitwarden/bitwarden-values-secret.txt
  ksecret node-red/node-red-values-secret.txt
  ksecret home-assistant/home-assistant-values-secret.txt
  ksecret grocy/grocy-values-secret.txt
  ksecret velero/velero-values-secret.txt
}

installFlux() {
  message "installing flux"
  # install flux
  kubectl create ns flux
  helm repo add fluxcd https://charts.fluxcd.io
  helm upgrade --install flux --values "$REPO_ROOT"/flux/flux/flux-values.yml --namespace flux fluxcd/flux
  helm upgrade --install helm-operator --values "$REPO_ROOT"/flux/helm-operator/helm-operator-values.yml --namespace flux fluxcd/helm-operator
  
  FLUX_READY=1
  while [ $FLUX_READY != 0 ]; do
    echo "waiting for flux pod to be fully ready..."
    kubectl -n flux wait --for condition=available deployment/flux
    FLUX_READY="$?"
    sleep 5
  done

  # grab output the key
  FLUX_KEY=$(kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2)

  message "adding the key to github automatically"
  "$REPO_ROOT"/setup/add-repo-key.sh "$FLUX_KEY"
}

. "$REPO_ROOT"/setup/.env

installValuesSecrets
# installFlux
# "$REPO_ROOT"/setup/bootstrap-objects.sh

message "all done!"