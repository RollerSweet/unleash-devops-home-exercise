# Overview

- **Service** – Express/TypeScript API containerized via multi-stage `Dockerfile`.
- **CI/CD** – `.github/workflows/build_and_deploy.yaml` builds and pushes `rollersweet/unleash-home-exercise:latest` on pushes to `master`, then deploys to EKS through Helm.
- **Helm chart** – `charts/unleash-home-exercise` manages env vars, service account + IRSA annotations, ingress, and TCP probes.
- **Terraform** – `terraform/live/app_deps` creates the S3 bucket and IAM role consumed by the Helm release.

## Manual Deployment

```bash
docker build -t rollersweet/unleash-home-exercise:latest .
docker push rollersweet/unleash-home-exercise:latest

terraform -chdir=./terraform/live/app_deps init
terraform -chdir=./terraform/live/app_deps apply

tf_outputs=$(terraform -chdir=./terraform/live/app_deps output -json)
BUCKET_NAME=$(jq -r '.bucket_name.value' <<< "$tf_outputs")
ROLE_ARN=$(jq -r '.role_arn.value' <<< "$tf_outputs")

helm upgrade --install unleash-home-exercise charts/unleash-home-exercise \
  -n unleash --create-namespace \
  --set-string "bucketName=${BUCKET_NAME}" \
  --set-string "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=${ROLE_ARN}"
```

Ensure kubeconfig points to the target EKS cluster.

## Verifying the Service

With ingress enabled, hit `/check-file`:

```bash
curl "https://unleash.tamirmadar.com/check-file?fileName=Tamir_Madar_CV.pdf"
```

Success returns `The file "Tamir_Madar_CV.pdf" exists in the bucket.`; a missing object yields `The file "<FILENAME>" does not exist in the bucket.` (HTTP 404).

## Configuration Notes

- Provide `bucketName` (via values or CLI flag) so the pod targets the correct S3 bucket.
- Tune ingress/service/probe settings in `charts/unleash-home-exercise/values.yaml` as needed.
- Service account defaults to `unleash-home-exercise` in namespace `unleash`; IRSA annotation is injected during deployment.
