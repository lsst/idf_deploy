# PROJECT

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

# VPC

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

# GKE

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "release_channel" {
  default = "REGULAR"
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "gce_pd_csi_driver" {
  description = "(Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver."
  type        = bool
  default     = false
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [{}]
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default = {
    owner       = "owner_here"
    environment = "environment"
  }
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  default = {
    all = {
      owner       = "owner_here"
      environment = "environment_here"
    }
  }
}

# CloudSQL

variable "database_version" {
  type        = string
  description = "The database version to use"
  default     = "POSTGRES_13"
}

variable "db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}
