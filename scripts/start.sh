#!/bin/bash

# Variables declaration ---------------------------------------------------------------------------------------------- #
AWS_REGION="eu-central-1"
NAMESPACE="kaltura"
REPOSITORY_NAME="kaltura"
SERVICE="summarizer"
VERSION=`git describe --tags --abbrev=0`

# Docker ------------------------------------------------------------------------------------------------------------- #
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

aws ecr create-repository --repository-name $REPOSITORY_NAME/$SERVICE --image-scanning-configuration scanOnPush=true --region $AWS_REGION

docker build --file deployment/docker/Dockerfile --tag $SERVICE:$VERSION .

docker tag $SERVICE:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME/$SERVICE:$VERSION

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME/$SERVICE:$VERSION

# Elastic Kubernetes Service ----------------------------------------------------------------------------------------- #
eksctl create cluster --config-file infrastructure/cluster.yaml

eksctl utils write-kubeconfig --cluster=kaltura-development --region=eu-central-1 --kubeconfig=/tmp/kubeconfig.yaml

# Helm --------------------------------------------------------------------------------------------------------------- #
helm install $SERVICE deployment/kubernetes --create-namespace --namespace=$NAMESPACE --kubeconfig=/tmp/kubeconfig.yaml
