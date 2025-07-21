variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "description" {
  description = "A description of the instance."
  type        = string
  default     = "A description of the instance."
}

variable "labels" {
  description = "Labels"
  default = {
    name             = "cluster"
    application_name = "app_name"
  }
}

variable "location" {
  description = "The name of the zone of the instance"
  type        = string
  default     = "us-central1-b"
}

variable "network" {
  description = "The name of the GCE VPC network to which the instance is connected."
  type        = string
  default     = "default"
}

variable "allowed_ips" {
  description = "IP addresses allowed to connect to the Netapp instance"
  type        = string
  default     = "127.0.0.1"
}

variable "backup_project" {
  description = "Project containing the NetApp Backup Vaults"
  type        = string
  default     = "data-curation-prod-fbdb"
}

variable "backup_location" {
  description = "Location of NetApp Backup Vault
  type        = string
  default     = "us-central-1b"
}

variable "backup_network" {
  description = "Network allowing access to NetApp Backup Vault"
  type        = string
  default     = "curation-prod-vpc"
}

variable "definition" {
  description = "A definition for a set of NetApp Cloud Volume objects"
  type = object({
    name                   = string                   # Volume name
    service_level          = string                   # PREMIUM, EXTREME, STANDARD, FLEX
    capacity_gib           = number                   # At least 2000
    unix_permissions       = optional(string, "0770") # Unix permission for mount point
    snapshot_directory     = optional(bool, false)
    backups_enabled        = optional(bool, false)
    has_root_access        = optional(bool, false)
    allow_auto_tiering     = optional(bool, false) # Not for STANDARD/FLEX
    enable_auto_tiering    = optional(bool, false)
    cooling_threshold_days = optional(number, 183)
    access_type            = optional(string, "READ_ONLY") # READ_ONLY, READ_WRITE, READ_NONE
    default_user_quota_mib = optional(number)
    override_user_quotas = optional(list(object({
      username       = string
      uid            = number
      disk_limit_mib = number
    })), [])
  })
}
