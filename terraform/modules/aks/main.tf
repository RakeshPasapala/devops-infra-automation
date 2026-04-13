# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

# ---------------------------
# AKS
# ---------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_name}-dns"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                 = "systempool"
    node_count           = var.node_count
    vm_size              = var.node_vm_size
    os_disk_size_gb      = 60
    type                 = "VirtualMachineScaleSets"
    auto_scaling_enabled = false
    zones                = ["1", "2"]

    node_labels = {
      "role"        = "system"
      "environment" = var.environment
      "pool_type"   = "system"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control_enabled = true

  tags = {
    environment = var.environment
  }
}

# ---------------------------
# Output
# ---------------------------
output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "aks_name" { value = azurerm_kubernetes_cluster.aks.name }
