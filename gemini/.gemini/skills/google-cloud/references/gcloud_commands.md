# Google Cloud CLI (gcloud) Reference

## Essential Configurations
- `gcloud config list`: Show active configuration (project, account, region, zone).
- `gcloud config set project <project-id>`: Set the default project.
- `gcloud config set compute/region <region>`: Set the default region.

## Authentication
- `gcloud auth login`: Authenticate using a Google account.
- `gcloud auth application-default login`: Acquire credentials for local development using Google Cloud client libraries.
- `gcloud auth print-access-token`: Print an OAuth2 access token for the active account.

## IAM & Service Accounts
- **List Service Accounts**: `gcloud iam service-accounts list`
- **Create Service Account**: `gcloud iam service-accounts create <sa-name> --display-name="<display-name>"`
- **Grant Role to Principal**:
  ```bash
  gcloud projects add-iam-policy-binding <project-id> \
      --member="serviceAccount:<sa-email>" \
      --role="roles/<role-name>"
  ```
- **List Roles on Project**: `gcloud projects get-iam-policy <project-id>`

## Cloud Run
- **Deploy a container**:
  ```bash
  gcloud run deploy <service-name> \
      --image=<image-url> \
      --region=<region> \
      --allow-unauthenticated
  ```
- **Deploy from source**:
  ```bash
  gcloud run deploy <service-name> \
      --source=. \
      --region=<region> \
      --allow-unauthenticated
  ```
- **List services**: `gcloud run services list`
- **Delete a service**: `gcloud run services delete <service-name> --region=<region>`

## Secrets Management
- **Create a Secret**: `gcloud secrets create <secret-name> --replication-policy="automatic"`
- **Add a Secret Version**: `echo -n "my-super-secret-value" | gcloud secrets versions add <secret-name> --data-file=-`
- **Access a Secret Value**: `gcloud secrets versions access latest --secret="<secret-name>"`
