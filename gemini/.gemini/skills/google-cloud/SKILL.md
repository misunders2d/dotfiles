---
name: google-cloud
description: A comprehensive guide for interacting with Google Cloud Platform (GCP), using the gcloud CLI, setting up IAM, and deploying to services like Cloud Run and Google Kubernetes Engine (GKE). Use when working on Google Cloud deployments, managing resources, or debugging GCP infrastructure.
---

# Google Cloud Skill

This skill provides procedural knowledge and best practices for working with Google Cloud Platform (GCP). It helps you navigate the `gcloud` CLI, configure authentication, manage infrastructure, and deploy applications effectively.

## Core Workflows

### 1. Working with the gcloud CLI
When running `gcloud` commands, refer to the command reference for patterns and best practices. Always ensure you are operating in the correct project and region.
See [references/gcloud_commands.md](references/gcloud_commands.md) for commonly used commands for identity, configuration, and resource management.

### 2. Deploying to GCP Services
When setting up a deployment pipeline or writing deployment configurations (like `Dockerfile`s or `cloudbuild.yaml`s), refer to the deployment best practices guide.
See [references/gcp_best_practices.md](references/gcp_best_practices.md) for patterns related to Cloud Run, Cloud Build, and Identity and Access Management (IAM).

### 3. Authentication & Setup
- **Login**: `gcloud auth login`
- **Application Default Credentials (ADC)**: `gcloud auth application-default login`. Use this when you are running local code that uses Google Cloud Client Libraries.
- **Set Project**: `gcloud config set project <project-id>`
- **Set Region**: `gcloud config set compute/region <region>`
- **View Configuration**: `gcloud config list`

### 4. IAM & Security Best Practices
- **Principle of Least Privilege**: Always grant the most restrictive roles that still allow a principal to perform their tasks.
- **Service Accounts**: Use Service Accounts rather than user credentials for automated deployments and inter-service communication.
- **Workload Identity Federation**: If deploying from an external system like GitHub Actions, use Workload Identity Federation instead of exporting long-lived Service Account keys.

### 5. Debugging & Observability
- **View Logs**: `gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=<service-name>" --limit 50`
- **Google Cloud Console**: If CLI output is limited, suggest the user check the Cloud Console UI, particularly for complicated permission issues or detailed trace logs.
