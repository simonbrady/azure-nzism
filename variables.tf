variable "location" {
  type        = string
  description = "Location for managed identity, and resource group if created"
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) Name of resource group to create and assign initiative to"
  default     = null
}

variable "management_group_name" {
  type        = string
  description = "(Optional) Name of existing management group to assign intiative to"
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "(Optional) GUID of existing subscription to assign intiative to"
  default     = null
}
