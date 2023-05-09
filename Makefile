# Variables declaration ---------------------------------------------------------------------------------------------- #
NAMESPACE = "kaltura"
PROFILE   = "development"
SERVICE   = "summarizer"
VERSION   = `git describe --tags --abbrev=0`

# Docker ------------------------------------------------------------------------------------------------------------- #
.PHONY: docker/build
docker/build:
	docker build --file deployment/docker/Dockerfile --tag $(SERVICE):$(VERSION) .

# Docker-Compose ----------------------------------------------------------------------------------------------------- #
.PHONY: docker-compose/down
docker-compose/down:
	docker-compose --file deployment/docker/docker-compose.yaml --profile $(PROFILE) down --volumes

.PHONY: docker-compose/log
docker-compose/log:
	docker-compose --file deployment/docker/docker-compose.yaml logs -f --tail 10

.PHONY: docker-compose/pull
docker-compose/pull:
	docker-compose --file deployment/docker/docker-compose.yaml --profile $(PROFILE) pull

.PHONY: docker-compose/up
docker-compose/up:
	docker-compose --file deployment/docker/docker-compose.yaml --profile $(PROFILE) up -d

# Elastic Kubernetes Service ----------------------------------------------------------------------------------------- #
.PHONY: eks/create
eks/create:
	eksctl create cluster --config-file infrastructure/cluster.yaml

.PHONY: eks/delete
eks/delete:
	eksctl delete cluster --config-file infrastructure/cluster.yaml

# Gunicorn ----------------------------------------------------------------------------------------------------------- #
.PHONY: gunicorn/run
gunicorn/run:
	gunicorn main:application --workers 1 --bind 0.0.0.0:8000

# Helm --------------------------------------------------------------------------------------------------------------- #
.PHONY: helm/delete
helm/delete:
	helm delete $(SERVICE) --namespace $(NAMESPACE)

.PHONY: helm/install
helm/install:
	helm install $(SERVICE) deployment/kubernetes --create-namespace --namespace $(NAMESPACE)

.PHONY: helm/template
helm/template:
	helm template deployment/kubernetes > /tmp/$(SERVICE).yaml

.PHONY: helm/test
helm/test:
	helm install $(SERVICE) deployment/kubernetes --create-namespace --namespace $(NAMESPACE) --dry-run --debug

.PHONY: helm/upgrade
helm/upgrade:
	helm upgrade $(SERVICE) deployment/kubernetes --namespace $(NAMESPACE)
