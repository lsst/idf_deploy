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

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "REGULAR"
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

variable "gce_pd_csi_driver" {
  description = "(Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver."
  type        = bool
  default     = false
}

variable "cluster_telemetry_type" {
  type        = string
  description = "Available options include ENABLED, DISABLED, and SYSTEM_ONLY"
  default     = null
}

variable "authenticator_security_group" {
  type        = string
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  default     = "lsst.cloud"
}

# ----------------------------------------
#  NODE POOL VALUES
# ----------------------------------------

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name               = "core-pool"
      machine_type       = "n2-standard-4"
      node_locations     = "us-central1-b"
      node_count         = 5
      local_ssd_count    = 0
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      image_type         = "cos_containerd"
      enable_secure_boot = true
      disk_size_gb       = "200"
      disk_type          = "pd-ssd"
    },
  ]
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
