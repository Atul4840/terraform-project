variable "location" {
  description = "The Azure region to deploy resources"
  default     = "East US"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  default     = "adminuser"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  default     = "adminUser1@"
  sensitive   = true
}
