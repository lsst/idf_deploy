variable "id" {
  description = "ID of the group. For Google-managed entities, the ID must be the email address the group"
}

variable "display_name" {
  description = "Display name of the group"
  default     = ""
}

variable "description" {
  description = "Description of the group"
  default     = ""
}

variable "domain" {
  description = "Domain of the organization to create the group in. One of domain or customer_id must be specified"
  default     = ""
}

variable "customer_id" {
  description = "Customer ID of the organization to create the group in. One of domain or customer_id must be specified"
  default     = ""
}

variable "owners" {
  description = "Owners of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}

variable "managers" {
  description = "Managers of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}

variable "members" {
  description = "Members of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}