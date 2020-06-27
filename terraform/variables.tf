#########
# Global
#########
variable "tenant_id" {
  description = "The tenant id of this deployment"
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "The subscription id of this deployment"
  type        = string
  default     = null
}

variable "client_id" {
  description = "The client id of this deployment"
  type        = string
  default     = null
}

variable "client_secret" {
  description = "The client secret of this deployment"
  type        = string
  default     = null
}

variable "location" {
  description = "The location of this deployment"
  type        = string
  default     = "Central US"
}

variable "resource_prefix" {
  description = "A prefix for the name of the resource, used to generate the resource names"
  type        = string
}

variable "tags" {
  description = "Tags given to the resources created by this template"
  type        = map(string)
  default     = {}
}

#########################
# Compute - Azure DevOps
#########################
variable "vm_source_image_id" {
  description = "ID of a source image for the Linux Azure DevOps VMs"
  type        = string
}

variable "vm_size" {
  description = "Size of instances to deploy"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_disk_type" {
  description = "Type of disk to use on instances"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "vm_disk_size_gb" {
  description = "Size of disk to use on instances"
  type        = number
  default     = 127
}

variable "vm_disk_caching" {
  description = "Caching option to use on instances"
  type        = string
  default     = "None"
}

#########
# Locals
#########
locals {
  resource_prefix = "${var.resource_prefix}-azdo"
}
