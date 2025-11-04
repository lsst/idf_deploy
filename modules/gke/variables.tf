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
  description = "Time window start for maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "maintenance_end_time" {
  description = "Time window end for maintenance operations in RFC3339 format"
  type        = string
  default     = "09:00"
}

variable "maintenance_recurrence" {
  description = "RFC 5545 RRULE for when maintenance windows occur"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=WE"
}

variable "maintenance_exclusions" {
  description = "List of maintenance exclusions. A cluster can have up to three"
  type        = list(object({ name = string, start_time = string, end_time = string, exclusion_scope = string }))
  default     = []
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

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 110
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

variable "dns_cache" {
  type        = bool
  description = "(Beta) The status of the NodeLocal DNSCache addon."
  default     = false
}

variable "gce_pd_csi_driver" {
  description = "(Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver."
  type        = bool
  default     = false
}

variable "gcs_fuse_csi_driver" {
  description = "Whether GCE FUSE CSI driver is enabled for this cluster."
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

variable "identity_namespace" {
  description = "Workload Identity namespace. (Default value of `enabled` automatically sets project based namespace `[project_id].svc.id.goog`)"
  type        = string
  default     = "enabled"
}

variable "node_metadata" {
  description = "Specifies how node metadata is exposed to the workload running on the node"
  default     = "GKE_METADATA_SERVER"
  type        = string
}

variable "enable_gcfs" {
  description = "Enable image streaming on cluster level"
  type        = bool
  default     = false
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

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"

  default = {}
}


variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    min_cpu_cores       = 0
    max_cpu_cores       = 0
    min_memory_gb       = 0
    max_memory_gb       = 0
  }
}

variable "monitoring_enable_managed_prometheus" {
  description = "Configuration for Managed Service for Prometheus. Whether or not the managed collection is enabled."
  type        = bool
  default     = false
}

variable "monitoring_enabled_components" {
  description = <<-EOT
    List of services to monitor: SYSTEM_COMPONENTS, APISERVER, SCHEDULER,
    CONTROLLER_MANAGER, STORAGE, HPA, POD, DAEMONSET, DEPLOYMENT, STATEFULSET,
    KUBELET, CADVISOR and DCGM. Empty list is default GKE configuration."
  EOT
  type        = list(string)
  default     = []

}

variable "gke_backup_agent_config" {
  description = "Whether Backup for GKE agent is enabled for this cluster."
  type = bool
  default = false
}

variable "enable_dataplane_v2" {
  description = "Whether to enable Dataplane V2 (all new clusters should have this enabled)."
  type = bool
  default = true
}

variable "use_update_variant" {
  description = "Whether to use the update variant of the GKE module. This should only be false when creating a cluster from scratch or intentionally destroying and recreating a cluster."
  type = bool
  default = true
}
