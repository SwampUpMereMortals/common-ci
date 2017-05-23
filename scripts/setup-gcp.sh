#!/bin/bash
#
# simply setup CI to authenticate and be in a position to run
# kubernetes and gcloud utility commands.
#
# First argument, $1 is the GCP Service Account (JSON) file.
# second arg, $2 is the name of the GKE cluster, eg "mere-mortals"
# third arg, $3 is the GCP zone, eg "us-central1-a"
# TODO:  Implement some reasonable argument handling.
# TODO: Implement some reasonable error handling, filepath checking,
# etc.
set -o nounset -o errexit
set -x
declare CREDENTIAL_FILE=$1
declare GOOGLE_KUBE_CLUSTER=$2
declare GOOGLE_KUBE_ZONE=$3
readonly GOOGLE_PROJECT=mere-mortals



### Install the Gcloud SDK
echo -e -n "******************** INSTALLING gcloud ********************\n\n"
rm -rf ${HOME}/google-cloud-sdk
curl https://sdk.cloud.google.com | bash
sudo gcloud auth activate-service-account --key-file ${CREDENTIAL_FILE}

### Configure gcloud
echo -e -n "******************** Configuring gcloud ********************\n\n"
gcloud config set container/cluster ${GOOGLE_KUBE_CLUSTER}
gcloud config set compute/zone ${GOOGLE_KUBE_ZONE}
gcloud config set project ${GOOGLE_PROJECT}


#### Setup Kubectl
echo -e -n "******************** Install & Config kubectl ********************\n\n"
# Install the kubernetes component
sudo gcloud components install kubectl
# Add kubectl to path
export PATH="${HOME}/google-cloud-sdk/bin:$PATH"
# Authenticate the service account against the kubernetes cluster
sudo gcloud container clusters get-credentials ${GOOGLE_KUBE_CLUSTER}
#   When running in CI or other systems on Google Cloud machines with
#   a restricted Google account, you have to use gcloud auth
#   activate-service-account before calling gcloud container clusters
#   get-credentials, but then have to override that authentication by
#   setting GOOGLE_APPLICATION_CREDENTIALS before calling kubectl.
export GOOGLE_APPLICATION_CREDENTIALS="${CREDENTIAL_FILE}"
# Update the kubernetes component once more
${HOME}/google-cloud-sdk/bin/gcloud components update kubectl
# Execute necessary kubectl commands
sudo ${HOME}/google-cloud-sdk/bin/kubectl cluster-info
