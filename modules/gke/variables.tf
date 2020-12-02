variable "name" {
  description = "A prefix to the default cluster name"
  default     = "simple"
}

variable "project_id" {
  description = "The project ID to host the cluster in (required)"
  type        = string
}

variable "region" {
  description = "Region to deploy cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  type        = map(string)
  default = {
    owner       = "owner_here"
    environment = "environment"
  }
}

variable "network" {
  description = "The VPC network to host the cluster in (required)"
  type        = string
}

variable "ip_range_pods" {
  description = "The VPC network to host the cluster in (required)"
  type        = string
  default     = "kubernetes-pods"
}

variable "ip_range_services" {
  description = "The name of the secondary subnet range to use for services"
  type        = string
  default     = "kubernetes-services"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in (required)"
  type        = string
}

variable "regional" {
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  type        = bool
  default     = true
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "enable_intranode_visibility" {
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network"
  type        = bool
  default     = true
}

variable "create_service_account" {
  description = "Defines if service account specified to run nodes should be created."
  type        = bool
  default     = true
}

variable "skip_provisioners" {
  description = "Flag to skip local-exec provisioners"
  type        = bool
  default     = true
}

variable "http_load_balancing" {
  description = "Enable httpload balancer addon"
  type        = bool
  default     = true
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling addon"
  type        = bool
  default     = true
}

variable "network_policy" {
  description = "Enable network policy addon"
  type        = bool
  default     = true
}

variable "enable_private_nodes" {
  default = true
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "remove_default_node_pool" {
  description = "Remove default node pool while setting up the cluster"
  type        = bool
  default     = true
}

variable "enable_resource_consumption_export" {
  description = "Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export."
  type        = bool
  default     = false
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
  description = "Map of maps containing node labels by node-pool name."
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