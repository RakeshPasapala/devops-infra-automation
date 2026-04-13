variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     = "devops-rg"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
  default     = "aks"
}

variable "node_count" {
  type        = number
  description = "AKS default node count"
  default     = 1
}

variable "node_vm_size" {
  type        = string
  description = "VM size for the node pool"
  default     = "Standard_D2ls_v6"
}

variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version (optional, else default)"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment Type"
  default     = "dev"
}
