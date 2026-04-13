variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "aks_name" { type = string }
variable "node_count" { type = number }
variable "node_vm_size" { type = string }
variable "environment" { type = string }
variable "kubernetes_version" {
  type    = string
  default = null
}