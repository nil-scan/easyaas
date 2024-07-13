#!/bin/sh
poetry run kopf run --all-namespaces -m easyaas.terraform_resource_controller -m easyaas.audit_controller -m easyaas.controller_manager --log-format=json --liveness=http://0.0.0.0:8080/healthz
