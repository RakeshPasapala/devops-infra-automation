# GitHub Actions — CI/CD Workflows

This folder defines the automation workflows for Terraform and Helm.

---

## 🧩 Workflows Overview

| Workflow                     | Purpose                                                                                 | Trigger                 |
| ---------------------------- | --------------------------------------------------------------------------------------- | ----------------------- |
| `tf-apply-with-approval.yml` | Lint, validate, and plan Terraform changes. Deploy infrastructure after manual approval | Manual                  |
| `tf-destroy.yml`             | Destroy infrastructure after confirmation                                               | Manual                  |
| `helm-deploy.yml`            | Lint and deploy Helm workload                                                           | Manual or chart changes |

---

## ⚙️ Terraform Workflows

### 🔹 `tf-apply-with-approval.yml`

Manual trigger (requires environment approval `dev`):

- Checks formatting (`fmt -check`)
- Validates configuration
- Creates a plan artifact (`tfplan.txt`)
- Logs in using OIDC
- Applies Terraform configuration
- Creates or updates AKS cluster

### 🔹 `tf-destroy.yml`

Manual trigger:

- Requires confirmation input (`DESTROY=YES`)
- Runs `terraform destroy`
- Removes all resources

---

## 🐳 Helm Workflow

### 🔹 `helm-deploy.yml`

Triggered manually or when Helm chart files change:

- Runs `helm lint`
- Installs/Upgrades the release
- Creates namespace automatically
- Uses configurable variables:
  ```yaml
  HELM_RELEASE: hello
  HELM_NAMESPACE: hello
  HELM_CHART_PATH: helm/hello-chart
  HELM_VALUES_FILE: helm/hello-chart/values.yaml
  ```

---

## 🧠 Notes

- All workflows use **OIDC authentication** (no service principal secrets).
- **Environment approval** gates protect `apply` and `destroy` stages.
- **Artifacts** store Terraform plans for traceability.
