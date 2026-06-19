#!/bin/bash
# Phase 9 - Install Prometheus + Grafana monitoring stack
# Run this after setting up Kubernetes cluster

# Add Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack (Prometheus + Grafana + AlertManager)
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

# Wait for pods to be ready
echo "Waiting for monitoring pods to start..."
kubectl --namespace monitoring get pods

# Get Grafana admin password
echo "Grafana admin password:"
kubectl --namespace monitoring get secrets monitoring-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d ; echo

# Access Grafana (run in background)
echo "Access Grafana at http://localhost:3000"
kubectl --namespace monitoring port-forward svc/monitoring-grafana 3000:80
