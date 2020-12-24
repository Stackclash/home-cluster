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

message "installing flux"
flux install \
--version=latest \
--components=source-controller,kustomize-controller,helm-controller,notification-controller \
--namespace=flux-system \
--network-policy=false \
--arch=arm

message "adding CRDs"
kubectl apply -f "${REPO_ROOT}"/crds

message "adding helm repositories"
kubectl apply -f "${REPO_ROOT}"/deployments/flux-system/helm-repositories

message "installing sealed-secrets"
kubectl apply -f "${REPO_ROOT}"/.secrets/sealed-secrets/my-sealed-secrets-key.yml
kubectl apply -f "${REPO_ROOT}"/deployments/kube-system/sealed-secrets/sealed-secrets.yml

message "setting up git repository"
kubectl apply -f "${REPO_ROOT}"/.secrets/flux-system/ssh-credentials.yml
kubectl apply -f "${REPO_ROOT}"/deployments/flux-system/gotk-sync.yaml
