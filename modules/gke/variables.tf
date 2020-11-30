variable "name" {
  description = "A prefix to the default cluster name"
  default     = "simple"
}

variable "project_id" {}

variable "region" {
  default = "us-central1"
}

variable "network" {}

variable "ip_range_pods" {
  default = "kubernetes-pods"
}

variable "ip_range_services" {
  default = "kubernetes-services"
}

variable "subnetwork" {}

variable "regional" {
  default = true
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = ["us-central1-a"]
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "create_service_account" {
  default = "true"
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = false
}

variable "http_load_balancing" {
  default = false
}

variable "horizontal_pod_autoscaling" {
  default = true
}

variable "network_policy" {
  default = true
}

variable "enable_private_nodes" {
  default = true
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "remove_default_node_pool" {
  default = true
}

variable "enable_resource_consumption_export" {
  default = false
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded Nodes features on all nodes in this cluster."
  type = bool
  default = true
}


# ----------------------------------------
#  NODE POOL VALUES
# ----------------------------------------

variable "node_pool_1_name" {
  default = "core-pool"
}

variable "node_pool_1_machine_type" {
  default = "g1-small"
}

variable "node_pool_1_min_count" {
  default = 1
}

variable "node_pool_1_max_count" {
  default = 15
}

variable "node_pool_1_local_ssd_count" {
  default = 0
}

variable "node_pool_1_disk_size_gb" {
  default = 100
}

variable "node_pool_1_disk_type" {
  default = "pd-standard"
}

variable "node_pool_1_image_type" {
  default = "COS"
}

variable "node_pool_1_auto_repair" {
  default = true
}

variable "node_pool_1_auto_upgrade" {
  default = true
}

variable "node_pool_1_preemptible" {
  default = false
}

variable "node_pool_1_initial_node_count" {
  default = 1
}

variable "node_pool_1_oauth_scope" {
  default = "https://www.googleapis.com/auth/cloud-platform"
}

# ----------------------------------------
#  USER POOL VALUES
# ----------------------------------------

# variable "node_pool_2_name" {
#   default = "user-pool"
# }

# variable "node_pool_2_machine_type" {
#   default = "g1-small"
# }

# variable "node_pool_2_min_count" {
#   default = 1
# }

# variable "node_pool_2_max_count" {
#   default = 30
# }

# variable "node_pool_2_local_ssd_count" {
#   default = 0
# }

# variable "node_pool_2_disk_size_gb" {
#   default = 100
# }

# variable "node_pool_2_disk_type" {
#   default = "pd-standard"
# }

# variable "node_pool_2_image_type" {
#   default = "COS"
# }

# variable "node_pool_2_auto_repair" {
#   default = true
# }

# variable "node_pool_2_auto_upgrade" {
#   default = true
# }

# variable "node_pool_2_preemptible" {
#   default = false
# }

# variable "node_pool_2_initial_node_count" {
#   default = 1
# }

# variable "node_pool_2_oauth_scope" {
#   default = "https://www.googleapis.com/auth/cloud-platform"
# }
