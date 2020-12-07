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

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

# variable "node_pool_1_name" {
#   default = "core-pool"
# }

# variable "node_pool_1_image_type" {
#   default = "cos_containerd"
# }

# variable "node_pool_1_enable_secure_boot" {
#   description = "Secure Boot helps ensure that the system only runs authentic software by verifying the digital signature of all boot components, and halting the boot process if signature verification fails."
#   default = true  
# }

# variable "node_pool_1_machine_type" {
#   default = "g1-small"
# }

# variable "node_pool_1_min_count" {
#   default = 1
# }

# variable "node_pool_1_max_count" {
#   default = 15
# }

# variable "node_pool_1_local_ssd_count" {
#   default = 0
# }

# variable "node_pool_1_disk_size_gb" {
#   default = 100
# }

# variable "node_pool_1_initial_node_count" {
#   default = 1
# }

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