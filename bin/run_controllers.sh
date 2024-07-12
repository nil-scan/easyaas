#!/bin/sh
poetry run kopf run --all-namespaces -m easyaas.audit_controller -m easyaas.controller_manager --log-format=json --liveness=http://0.0.0.0:8080/healthz
