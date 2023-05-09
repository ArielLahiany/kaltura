# Kaltura

## Description

A simple web application that summarizers a JSON POST requests.

### Endpoints

1. Root ("/api/add"): Listens to POST requests and responses accordingly.

2. Health ("/health"): Listens to GET requests and replies with a static OK HTTP response (status code 200).

## Prerequisites

1. Docker: a working station with Docker and Docker-Compose pre-installed.
2. Kubernetes: a working Kubernetes cluster and its Kubeconfig file.

## Usage

### Docker-Compose

1. Add the following entry to the hosts file of your working station:

   ```txt
   127.0.1.1 summarizer.kaltura.local
   ```

2. Build the service Docker image:

   ```bash
   make docker/build
   ```

3. Spin up the stack:

   ```bash
   make docker-compose/up
   ```

4. In order to see summarize two numbers send a POST request to the server using cURL (ignoring the self-signed certificate):

   ```bash
   curl -X POST -k https://summarizer.kaltura.local/api/add --header 'Content-Type: application/json' --data '{"num1": < First integer >, "num2": < Second integer >}'
   ```

### Kubernetes

1. Create a Kubernetes secret in order to pull from a private Docker registry:

   ```bash
   kubectl create secret docker-registry regcred \
           --docker-server=< AWS's Account ID. >.dkr.ecr.< AWS's Elastic Container Registry region. >.amazonaws.com \
           --docker-username=AWS \
           --docker-password=$(aws ecr get-login-password) \
           --namespace=counter-service
   ```

2. Test the Helm deployment:

   ```bash
   make helm/test
   ```

3. Deploy the Helm chart:
   ```bash
   make helm/install
   ```
