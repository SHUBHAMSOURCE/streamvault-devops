# StreamVault — End-to-End DevOps Pipeline

![CI/CD](https://github.com/SHUBHAMSOURCE/streamvault-devops/actions/workflows/deploy.yml/badge.svg)
![Docker](https://img.shields.io/badge/Docker-multi--stage-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-minikube-326CE5)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA)
![License](https://img.shields.io/badge/license-MIT-green)

A containerized streaming-app demo (React frontend + API backend) built to demonstrate a complete, production-style DevOps lifecycle: from a Dockerized app to a CI/CD pipeline, Kubernetes orchestration, Infrastructure as Code, observability, and HTTPS-secured ingress — all running locally on minikube, structured so it maps 1:1 onto a real cloud deployment.

## Why this project

Most "Docker + Kubernetes" portfolio repos stop at "it runs in a container." This one goes further and answers the question hiring managers actually ask: **can you operate this in production?**

Each phase below exists to solve a real operational problem, not just to check a box:

| Problem | Solution |
|---|---|
| App needs to run identically everywhere | Multi-stage Dockerfiles for frontend + backend |
| Manual deploys don't scale / are error-prone | GitHub Actions CI/CD pipeline (build → test → push) |
| Containers need orchestration, restarts, scaling | Kubernetes manifests (Deployments, Services) on minikube |
| Infra should be reproducible, not click-ops | Terraform-defined IAM, VPC, and networking |
| You can't fix what you can't see | Prometheus + Grafana for metrics and dashboards |
| Raw IPs and ports aren't production-grade | Nginx Ingress Controller for clean domain routing |
| Traffic must be encrypted | cert-manager-issued TLS certificates on Ingress |

## Architecture

```
Developer push
      │
      ▼
GitHub Actions CI/CD ──► Terraform (IaC: IAM, VPC, networking)
      │
      ▼
┌─────────────────────────── Kubernetes cluster (minikube) ───────────────────────────┐
│                                                                                       │
│                         Nginx Ingress  (TLS via cert-manager)                        │
│                          /                              \\                            │
│                  Frontend Service                  Backend Service                   │
│                  (React, port 80)                  (API, port 5000)                  │
│                          \\                              /                            │
│                       Prometheus + Grafana (metrics, dashboards)                      │
│                                                                                       │
│                  cert-manager: Issuer → Certificate → Secret                          │
└───────────────────────────────────────────────────────────────────────────────────────┘
```

## Tech stack

- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Orchestration:** Kubernetes (minikube)
- **Infrastructure as Code:** Terraform
- **Networking/Security:** Nginx Ingress Controller, cert-manager (TLS)
- **Observability:** Prometheus, Grafana
- **Cloud primitives modeled:** IAM, VPC

## Project phases

| Phase | What it covers | Status |
|---|---|---|
| 1 | Dockerfiles for frontend and backend | ✅ |
| 2 | Docker Compose for local multi-container dev | ✅ |
| 3 | Cloud storage practice (S3-style object storage) | ✅ |
| 4 | Version control and GitHub repo setup | ✅ |
| 5 | CI/CD pipeline with GitHub Actions | ✅ |
| 6 | Kubernetes deployment on minikube | ✅ |
| 7 | IAM and VPC fundamentals | ✅ |
| 8 | Infrastructure as Code with Terraform | ✅ |
| 9 | Monitoring with Prometheus and Grafana | ✅ |
| 10 | Ingress routing and HTTPS via cert-manager | ✅ |
| 11 | Documentation, architecture diagram, polish | ✅ |

## Getting started

### Prerequisites

- Docker and Docker Compose
- minikube and kubectl
- Terraform
- Helm (for Prometheus/Grafana)

### Local setup

```bash
# 1. Clone the repo
git clone https://github.com/SHUBHAMSOURCE/streamvault-devops.git
cd streamvault-devops

# 2. Copy environment variables
cp .env.example .env

# 3. Start minikube
minikube start

# 4. Enable Ingress addon
minikube addons enable ingress

# 5. Apply Kubernetes manifests
kubectl apply -f k8s/

# 6. Add the local domain to /etc/hosts
echo "$(minikube ip) streamvault.local" | sudo tee -a /etc/hosts

# 7. Visit the app
https://streamvault.local
```

> Note: the TLS certificate is self-signed for local development — your browser will show a security warning. This is expected; the underlying encryption is fully functional. In production, swapping the cert-manager `Issuer` for an ACME/Let's Encrypt issuer removes the warning with no other changes required.

## Repository structure

```
streamvault-devops/
├── frontend/              # React app + Dockerfile
├── backend/                # API service + Dockerfile
├── k8s/
│   ├── deployments/        # Deployment + Service manifests
│   ├── ingress/            # Ingress routing config
│   └── certs/              # cert-manager Issuer + Certificate
├── terraform/               # IAM, VPC, networking as code
├── monitoring/              # Prometheus + Grafana configs
├── .github/workflows/        # CI/CD pipeline definitions
├── .env.example
└── README.md
```

## Production differences

This setup runs entirely on minikube for local development. The table below shows what changes — and what doesn't — moving to a real cloud environment:

| Component | Local (this repo) | Production |
|---|---|---|
| Cluster | minikube | EKS / GKE / AKS |
| TLS issuer | Self-signed (cert-manager) | Let's Encrypt / ACM via cert-manager |
| Domain | `streamvault.local` (hosts file) | Real registered domain + DNS |
| Image registry | Local Docker | ECR / GCR / Docker Hub |
| IaC target | Local network simulation | Real VPC, subnets, IAM roles |

The Kubernetes manifests, Ingress logic, and CI/CD pipeline structure are unchanged between environments — only the issuer, registry, and DNS targets differ. That portability is the point.

## License

MIT
