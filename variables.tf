variable "prefix" {
  type        = string
  description = "This prefix will be included in the name of most resources."
}

variable "location" {
  type        = string
  description = "The region where the virtual network is created."
}

variable "environment" {
  type        = string
  description = "Environment for the deployment."
}

variable "project" {
  type        = string
  description = "Project name for the deployment."
}

variable "address_space" {
  type        = string
  description = "The address space that is used by the virtual network. Changing this forces a new resource to be created."
}

variable "subnet_prefix" {
  type        = string
  description = "The address prefix to use for the subnet."
}

variable "vm_size" {
  type        = string
  description = "Specifies the size of the virtual machine."
  default     = "Standard_B1s"
}

variable "image_publisher" {
  type        = string
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  type        = string
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  type        = string
  description = "Image SKU to apply (az vm image list)"
  default     = "18.04-LTS"
}

variable "image_version" {
  type        = string
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  type        = string
  description = "Administrator user name for linux and mysql."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for linux."
  default     = "Password123!"
}

