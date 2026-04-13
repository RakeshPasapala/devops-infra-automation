# devops-infra-automation — Azure AKS + Terraform + Helm

This project provisions a minimal **Azure Kubernetes Service (AKS)** cluster using **Terraform**, deploys a simple **Helm workload (NGINX)**, and manages the lifecycle end-to-end via **GitHub Actions**.

---

## 🧱 Architecture Overview

```
Developer → GitHub Actions (OIDC Auth) → Terraform (AzureRM) → AKS Cluster → Helm (NGINX App)
```

**Key Technologies:**

- Terraform (IaC)
- AzureRM provider
- GitHub Actions (Plan, Apply, Destroy)
- Helm (App Deployment)
- Remote state in Azure Storage

---

## 📁 Repository Structure

```
devops-infra-automation/
│
├── terraform/
│   ├── main.tf                 # Root module calling AKS module
│   ├── provider.tf             # AzureRM provider + backend
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Outputs (cluster name, RG, etc.)
│   ├── env/
│   │   └── dev.tfvars          # Environment variables for dev
│   └── modules/
│       └── aks/
│           ├── main.tf         # AKS resource + node pool
│           └── variables.tf
│
├── helm/
│   └── hello-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
│
├── .github/
│   └── workflows/
│       ├── tf-plan.yml         # Terraform lint/validate/plan
│       ├── tf-apply.yml        # Manual approval + apply
│       ├── tf-destroy.yml      # Manual destroy
│       └── helm-deploy.yml     # Helm lint + upgrade/install
│
├── .tflint.hcl
└── README.md                   # This file
```

---

## ⚙️ Prerequisites

| Tool      | Version  |
| --------- | -------- |
| Terraform | ≥ 1.13.3 |
| Azure CLI | ≥ 2.63   |
| Helm      | ≥ 3.14   |
| kubectl   | ≥ 1.30   |

---

## 🔐 Azure & GitHub Setup

### 1. App Registration (Manual)

- Create an **Azure App Registration** and grant **Contributor** role on your subscription.
- Configure **Federated Credentials (OIDC)** between GitHub and Azure:
  - Go to: Azure AD → App → Certificates & Secrets → Federated Credentials
  - Link repository → environment (`dev`)

### 2. Remote Backend (Manual)

Create a **Storage Account** and **Container** for Terraform state:

```bash
az storage account create -g <rg> -n <storageAccount> -l westeurope
az storage container create --account-name <storageAccount> -n tfstate
```

### 3. GitHub Secrets / Variables

| Type     | Name                    | Description                           |
| -------- | ----------------------- | ------------------------------------- |
| Secret   | `AZURE_CLIENT_ID`       | App registration client ID            |
| Secret   | `AZURE_TENANT_ID`       | Tenant ID                             |
| Secret   | `AZURE_SUBSCRIPTION_ID` | Subscription ID                       |
| Variable | `BACKEND_RG`            | Resource group name for backend       |
| Variable | `BACKEND_SA`            | Storage account name                  |
| Variable | `BACKEND_CONTAINER`     | State container name                  |
| Variable | `BACKEND_KEY`           | Backend key (e.g., terraform.tfstate) |

### 4. Git Repo Environment

Create the environment `dev` under the repository settings and add reviewers to approve the actions.
Admins may have permissions to bypass the configured protection rules

---

## 🧩 CI/CD Workflows

### 🪄 Terraform Plan & Apply with Approval (`tf-apply-with-approval.yml`)

Triggered on pull request or push:

- Runs `tflint`
- Runs `terraform fmt -check` and `terraform validate`
- Executes `terraform plan`
- Saves the plan as an artifact (`tfplan.txt`)
- Manual approval is presented to the authorized user
- Upon approval, same plan is downloaded and applied

### 💣 Terraform Destroy (`tf-destroy.yml`)

Manual trigger with confirmation input.

- Uses OIDC login
- Runs `terraform destroy`
- Tears down entire resource group cleanly

### 🐳 Helm Deploy (`helm-deploy.yml`)

Triggered manually or on Helm chart changes:

- Runs `helm lint`
- Installs or upgrades release (`helm upgrade --install`)
- Creates namespace if missing
- Uses values from `helm/hello-chart/values.yaml`

> 🔸 To improve: Add `kubectl rollout status` for post-deploy validation.

---

## 🌐 Verify Deployment

After `tf-apply` and `helm-deploy` complete:

```bash
az aks get-credentials -n <aks_name> -g <rg_name>
kubectl get svc -n hello
```

Copy the **EXTERNAL-IP** and open it in your browser.  
You should see the **NGINX default landing page**.

---

## 🧹 Teardown

To clean up all resources:

1. Trigger **Terraform Destroy** workflow (`tf-destroy.yml`)
2. Approve the environment (`dev`)
3. Confirm input when prompted

This destroys the AKS cluster and all associated resources.

---

## 🧩 Design Decisions & Notes

### Node Pool Design

- Selected **VM Scale Sets (VMSS)** over Availability Sets (modern, autoscaling, rolling updates)
- **Autoscaling disabled** for simplicity and cost control
- Configured **Zones = [1,2]** to illustrate safer rolling updates
- Conceptually separated **system** and **user** pools for hygiene, but only system pool implemented to keep demo minimal

### Issues & Fixes

- **vCPU Quota** exceeded initially → switched to smaller `Standard_D2ls_v6`
- **Terraform validation errors** resolved by upgrading Terraform + `azurerm` provider
- **OIDC auth issue** fixed by switching from branch-based to environment-based OIDC configuration
- **App registration & backend setup** done manually since tenant-level permissions are required

### Manual Setup (deliberate)

- App registration and backend state creation kept manual to simulate real-world org-level pre-setup
- This avoids overengineering and focuses on workflow logic
- Create tfstate RG, SA and container to separate remote backend

---

## 🧮 Stretch Goals

| Feature                   | Status         |
| ------------------------- | -------------- |
| Remote Terraform backend  | ✅ Implemented |
| OIDC-based authentication | ✅ Implemented |
| Manual approval workflow  | ✅ Implemented |
