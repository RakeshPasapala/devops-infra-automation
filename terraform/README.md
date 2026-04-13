# Terraform — AKS Infrastructure

This folder provisions the **Azure Kubernetes Service (AKS)** infrastructure using Terraform.

---

## 🧩 Structure

```
terraform/
│
├── main.tf            # Root file calling the AKS module
├── provider.tf        # AzureRM provider config + remote backend
├── variables.tf       # Input variable definitions
├── outputs.tf         # Exposed outputs (cluster name, RG, etc.)
├── env/
│   └── dev.tfvars     # Environment-specific variable values
└── modules/
    └── aks/
        ├── main.tf    # AKS cluster and node pool configuration
        └── variables.tf
```

---

## ⚙️ Backend Setup

Terraform stores its state remotely in an **Azure Storage Account**.

Create it manually before first run:
```bash
az storage account create -g <rg> -n <storageAccount> -l westeurope
az storage container create --account-name <storageAccount> -n tfstate
```

Then define GitHub variables:

| Name | Description |
|------|--------------|
| `BACKEND_RG` | Resource group for backend |
| `BACKEND_SA` | Storage account name |
| `BACKEND_CONTAINER` | Container for state |
| `BACKEND_KEY` | State file name (e.g. terraform.tfstate) |

The workflow automatically generates `backend.hcl` using these variables.

---

## 🔐 Authentication

The workflows use **GitHub OIDC** to authenticate with Azure:
```yaml
- uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

No long-lived credentials are stored.

---

## 🧠 Notes
- The AKS node pool uses **VMSS** for rolling upgrades.
- **Autoscaling disabled** for cost control.
- **Zones [1,2]** enabled for availability.
- Future improvement: separate user node pool.

---

## 🧹 Cleanup

To destroy all resources:
```bash
terraform destroy -var-file=env/dev.tfvars
```

Or trigger the **`tf-destroy.yml`** workflow in GitHub Actions.
