# Project
environment      = "stable"
application_name = "science-platform"

# GKE
master_ipv4_cidr_block = "172.30.0.0/28"
gce_pd_csi_driver      = true
network_policy         = true
maintenance_start_time = "2021-08-20T00:00:00Z"
maintenance_end_time   = "2021-08-20T12:00:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=FR"
maintenance_exclusions = [
  {
    name            = "DP1"
    start_time      = "2025-06-27T00:00:00Z"
    end_time        = "2025-07-10T19:30:00Z" # 12:30PM PDT
    exclusion_scope = "NO_UPGRADES"
  },
]

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-32" # 32 core, 128GB
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "300"
    disk_type          = "pd-ssd"
    autoscaling        = true
    initial_node_count = 5
    min_count          = 5
    max_count          = 100
  },
  {
    name               = "user-lab-pool"
    machine_type       = "n2-standard-32"
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

node_pools_labels = {
  core-pool = {
    infrastructure = "ok",
  }
}

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

  # Don't include kube-state-metrics, because the managed kube-state-metrics
  # doesn't provide kube_pod_container_status_last_terminated_reason, and
  # kube_pod_container_status_restarts_total, which are essential to alerting
  # on OOM kills. Phalanx installations can run their own kube-state-metrics
  # with these and other metrics, configured in the google-cloud-observability
  # app:
  # https://cloud.google.com/kubernetes-engine/docs/how-to/kube-state-metrics
  #
  # Google recommends not using the managed kube-state-metrics at all if you're
  # going to run your own:
  # https://cloud.google.com/kubernetes-engine/docs/how-to/kube-state-metrics#requirements

  # Gets us PVC disk usage metrics
  "KUBELET",

  # Gets us CPU throttling metrics
  "CADVISOR",

  # Gets us sum of requests/limits per node
  "SCHEDULER",
]

gke_backup_agent_config = true

enable_dataplane_v2 = false

# TF State declared during pipeline
# bucket = "lsst-terraform-state"
# prefix = "qserv/stable/gke"

# Increase this number to force Terraform to update the prod environment.
# Serial: 4
