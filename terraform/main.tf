module "aks" {
  source              = "./modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  aks_name            = var.aks_name
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  kubernetes_version  = var.kubernetes_version
  environment         = var.environment
}

output "resource_group_name" { value = module.aks.resource_group_name }
output "aks_name" { value = module.aks.aks_name }
