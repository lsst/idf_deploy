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

variable "service_level" {
  description = "The service level of the instance. Possible values are PREMIUM, EXTREME, STANDARD, and FLEX."
  type        = string
  default     = "PREMIUM"
}

variable "pool_name" {
  description = "The name of the storage pool"
  type        = string
  default     = "pool1"
}

variable "share_name" {
  description = "The share name (NFS export path) of the volume."
  type        = string
  default     = "share1"
}

variable "name" {
  description = "The resource name of the volume."
  type        = string
  default     = "vol1"
}

variable "capacity_gib" {
  description = "Pool and volume capacity in GiB. This must be at least 2000Gib."
  type        = number
  default     = 3000
}

variable "network" {
  description = "The name of the GCE VPC network to which the instance is connected."
  type        = string
  default     = "default"
}

variable "protocols" {
  description = "Protocols for volume access.  Allowed combinations are: ['NFSV3'], ['NFSV4'], ['SMB'], ['NFSV3', 'NFSV4'], ['SMB', 'NFSV3'] and ['SMB', 'NFSV4']. Each value may be one of: NFSV3, NFSV4, SMB."
  type        = list[string]
  default     = ['NFSV3', 'NFSV4']
}

variable "deletion_policy" {
  description = "Policy to determine if the volume should be deleted forcefully. Volumes may have nested snapshot resources. Deleting such a volume will fail. Setting this parameter to FORCE will delete volumes including nested snapshots. Possible values: DEFAULT, FORCE."
  type        = string
  default     = "DEFAULT"
}

variable "unix_permissions" {
  description = "(Optional) Unix permission the mount point will be created with. Default is 0770. Applicable for UNIX security style volumes only."
  type    = number
  default = 0770
}

variable "snapshot_directory" {
  description = "(Optional) If enabled, a NFS volume will contain a read-only .snapshot directory which provides access to each of the volume's snapshots."
  type = bool
  default = true
}

variable "export_policy" {
  description = "Export policy of the volume for NFSV3 and/or NFSV4.1 access."
  type = object
  default = {
    rules = {
      allowed_clients = {
        description = "Defines the client ingress specification (allowed clients) as a comma separated list with IPv4 CIDRs or IPv4 host addresses."
        type = list[string]
        default = []
      }
      has_root_access = {
        description = "If enabled, the root user (UID = 0) of the specified clients doesn't get mapped to nobody (UID = 65534). This is also known as no_root_squash."
	type = bool
	default = false
      }
      access_type = {
        description = "Defines the access type for clients matching the allowedClients specification. Possible values are: READ_ONLY, READ_WRITE, READ_NONE."
	type = string
	default = "READ_ONLY"
      }
      nfsv3 = {
        description = "Enable to apply the export rule to NFSV3 clients."
	type = bool
	enabled = true
      }
      nfsv4 = {
        description = "Enable to apply the export rule to NFSV4 clients."
	type = bool
	enabled = true
      }
    }

variable "restricted_actions" {
  description = "(Optional) List of actions that are restricted on this volume. Each value may be one of: DELETE."
  type = list[string]
  default = []
}

variable "snapshot_policy" {
  description = "Snapshot policy defines the schedule for automatic snapshot creation. To disable automatic snapshot creation you have to remove the whole snapshot_policy block."
  type = object
  default = {
    enabled = false
  }
}
