default:
	@just --choose

build: zip build-docker
local-dev: zip repo-server poetry

install:
  kubectl apply -f easyaas/terraform_resource_controller/crds

zip:
	local-testing/scripts/zip

build-docker:
	docker build -t easyaas-registry.web:12345/easyaas:0.0.1 . && docker push easyaas-registry.web:12345/easyaas:0.0.1

import-docker:
	k3d image import --cluster easyaas easyaas-registry.web:12345/easyaas:0.0.1 easyaas-registry.web:12345/terragrunt-runner

create-k3d-cluster:
	k3d cluster create --config local-testing/k3d/easyaas.yaml

repo-server:
	cd local-testing && docker compose up -d

poetry:
	poetry install

test:
	poetry run pytest 

run:
	bin/run_controllers.sh

run-tfresource:
	bin/run_terraform_controller.sh
