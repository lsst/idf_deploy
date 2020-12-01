variable "name" {
  description = "A prefix to the default cluster name"
  default     = "simple"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "region" {
  default = "us-central1"
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default = {
    owner       = "owner_here"
    environment = "environment"
  }
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "ip_range_pods" {
  default = "kubernetes-pods"
}

variable "ip_range_services" {
  default = "kubernetes-services"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
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

variable "enable_intranode_visibility" {
  type        = bool
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network"
  default     = true
}

variable "create_service_account" {
  default = "true"
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = true
}

variable "http_load_balancing" {
  default = true
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
  type        = bool
  default     = true
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

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  default     = "lsst.cloud"
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
