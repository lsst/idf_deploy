# Project
environment      = "dev"
application_name = "science-platform"

# GKE
release_channel        = "RAPID"
master_ipv4_cidr_block = "172.16.0.0/28"
gce_pd_csi_driver      = true
maintenance_start_time = "2021-08-18T00:00:00Z"
maintenance_end_time   = "2021-08-18T12:00:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=WE"
cluster_autoscaling = {
  enabled             = true
  autoscaling_profile = "OPTIMIZE_UTILIZATION"
  min_cpu_cores       = 0
  max_cpu_cores       = 0
  min_memory_gb       = 0
  max_memory_gb       = 0
}

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-8"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    autoscaling        = true
    initial_node_count = 1
    min_count          = 1
    max_count          = 100
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "300"
    disk_type          = "pd-ssd"
  },
  {
    name               = "user-lab-pool"
    machine_type       = "n2-standard-8"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    autoscaling        = true
    initial_node_count = 1
    min_count          = 1
    max_count          = 100
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "300"
    disk_type          = "pd-ssd"
  }
]

node_pools_taints = {
  "user-lab-pool" = [
    {
      key    = "nublado.lsst.io/permitted"
      value  = "true"
      effect = "NO_EXECUTE"
    }
  ]
}

monitoring_enable_managed_prometheus = true
monitoring_enabled_components = [
  # Default
  "SYSTEM_COMPONENTS",

  # kube state metrics (gets us container last terminated reason, for
  # monitoring OOM kills)
  "DAEMONSET",
  "DEPLOYMENT",
  "HPA",
  "POD",
  "STATEFULSET",
  "STORAGE",

  # Gets us PVC disk usage metrics
  "KUBELET",

  # Gets us CPU throttling metrics
  "CADVISOR"
]

# Increase this number to force Terraform to update the dev environment.
# Serial: 6
