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
  default = "172.22.0.0/28"
}

variable "master_ipv4_cidr_block_2" {
  default = "172.23.0.0/28"
}

variable "master_ipv4_cidr_block_3" {
  default = "172.24.0.0/28"
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  type        = list(string)
  default     = ["us-central1-c"]
}

variable "gce_pd_csi_driver" {
  description = "(Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver."
  type        = bool
  default     = true
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "STABLE"
}

variable "network_policy" {
  description = "Enable network policy addon"
  type        = bool
  default     = false
}

variable "cluster_telemetry_type" {
  type        = string
  description = "Available options include ENABLED, DISABLED, and SYSTEM_ONLY"
  default     = "SYSTEM_ONLY"
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [{}]
}

variable "node_pools_2" {
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

# Autoscaling definition for GKE clusters
variable "cluster_autoscaling_1" {
   type = object({
     enabled = bool
     autoscaling_profile = string
     min_cpu_cores = number
     max_cpu_cores = number
     min_memory_gb = number
     max_memory_gb = number
   })
  default = {
   enabled             = true
   autoscaling_profile = "BALANCED"
   min_cpu_cores       = 4
   max_cpu_cores       = 10000
   min_memory_gb       = 8
   max_memory_gb       = 20000
   }
}


# Autoscaling definition for GKE clusters
variable "cluster_autoscaling_2" {
   type = object({
     enabled = bool
     autoscaling_profile = string
     min_cpu_cores = number
     max_cpu_cores = number
     min_memory_gb = number
     max_memory_gb = number
   })
   default = {
   enabled             = true
   autoscaling_profile = "BALANCED"
   min_cpu_cores       = 4
   max_cpu_cores       = 5000
   min_memory_gb       = 64
   max_memory_gb       = 320000
   }
}