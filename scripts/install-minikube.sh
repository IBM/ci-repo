#!/bin/bash -e

# shellcheck disable=SC1090
source "$(dirname "$0")"/resources.sh

# if KUBECTL_VERSION is not set, use latest
if [ -z "$KUBECTL_VERSION" ]
then
    KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    MINIKUBE_KUBERNETES=stable
else
    MINIKUBE_KUBERNETES="$KUBECTL_VERSION"
fi

KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/"$KUBECTL_VERSION"/bin/linux/amd64/kubectl

# if MINIKUBE_VERSION is not set, use latest
if [ -z "$MINIKUBE_VERSION" ]
then
    MINIKUBE_VERSION=latest
fi

MINIKUBE_URL=https://storage.googleapis.com/minikube/releases/"$MINIKUBE_VERSION"/minikube-linux-amd64

setup_minikube() {
  export CHANGE_MINIKUBE_NONE_USER=true
  sudo apt-get install conntrack   # required for > v1.18.0
  curl -Lo kubectl "$KUBECTL_URL" && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
  curl -Lo minikube "$MINIKUBE_URL" && chmod +x minikube && sudo mv minikube /usr/local/bin/
  sudo -E minikube start --vm-driver=none --kubernetes-version="$MINIKUBE_KUBERNETES"
  minikube update-context
  JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done
}

main(){
    if ! setup_minikube; then
        test_failed "$0"
    else
        test_passed "$0"
    fi
}

main
