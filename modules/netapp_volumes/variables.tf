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

variable "definitions" {
  description = "A list of volume definitions"
  type = list(object({
    name = string # Volume name
    service_level = string # PREMIUM, EXTREME, STANDARD, FLEX
    capacity_gib = number # At least 2000
    protocols = list(string) # each item is one of NFSV3, NFSV4, SMB
			     # SMB and either NFS, both NFSes, or any solo
    deletion_policy = string  # DEFAULT or FORCE
    unix_permissions=optional(number, 0770) # Unix permission for mount point
    restricted_actions = optional(list(string), [])  # Or [DELETE]
    snapshot_directory = bool
    snapshot_policy = optional(object({
      enabled = bool
      hourly_schedule = optional(object({
	snapshots_to_keep = number,
	minute = optional(number,0)
      }))
      daily_schedule = optional(object({
	snapshots_to_keep = number
	minute = optional(number,0)
	hour = optional(number,0)
      }))
      weekly_schedule = optional(object({
	snapshots_to_keep = number
	minute = optional(number,0)
	hour = optional(number,0)
	day = optional(string, "Sunday")
      })) 
      monthly_schedule = optional(object({
	snapshots_to_keep = number
	minute = optional(number,0)
	hour = optional(number,0)
	days = optional(string, "1")
      }))
    }))
    backup_policy = optional(object({
      enabled = bool # Enable backups?
      daily_backup_limit = optional(number)
      weekly_backup_limit  = optional(number)
      monthly_backup_limit = optional(number)
    }))
    # allowed_clients = string  # Derived from subnets
    has_root_access = bool
    access_type = string
    default_user_quota_mib = optional(number)
  }))
}
