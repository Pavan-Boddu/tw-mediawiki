#!/bin/bash

# Install required packages
sudo yum install git wget jq kubectl helm -y

# Install Helm
sudo wget https://get.helm.sh/helm-v2.16.10-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.16.10-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm helm-v2.16.10-linux-amd64.tar.gz
sudo rm -rf linux-amd64
export PATH=$PATH:/usr/local/bin

# Configure Google Auth
gcloud auth activate-service-account --key-file=/tmp/credentials.json
gcloud container clusters get-credentials $1 --zone $2 --project $3

# GIT Clone and Deploy
git clone https://github.com/Pavan-Boddu/tw-mediawiki.git

# Install tiller
cd tw-mediawiki/kubernetes
kubectl apply -f tiller-account-rbac.yaml
helm init --service-account=tiller \
   --stable-repo-url=https://kubernetes-charts.storage.googleapis.com \
   --upgrade \
   --automount-service-account-token=true \
   --replicas=1 \
   --history-max=100 \
   --wait

# Deploy Application
cd helm
helm install tw-mediawiki --name tw-mediawiki
sleep 30
echo ""
echo "--------------------------------------------------------------"
echo "External IP"
kubectl get nodes -o json | jq .items[0].status.addresses[1].address
echo "--------------------------------------------------------------"
