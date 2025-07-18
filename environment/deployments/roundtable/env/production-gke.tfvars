# Project
environment      = "prod"
application_name = "roundtable"

# GKE
master_ipv4_cidr_block = "172.30.0.0/28"
gce_pd_csi_driver      = true
gcs_fuse_csi_driver    = true
network_policy         = true
maintenance_start_time = "2021-08-20T00:00:00Z"
maintenance_end_time   = "2021-08-20T12:00:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=FR"

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-16" # 16 core, 64GB
    node_locations     = "us-central1-a,us-central1-b,us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    initial_node_count = 1
    min_count          = 1
    max_count          = 100
  },
  {
    name               = "kafka-pool"
    machine_type       = "n2-standard-8" # 8 vCPU 32GB
    node_locations     = "us-central1-a,us-central1-b,us-central1-c"
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
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
  },
  {
    name               = "zookeeper-pool"
    machine_type       = "n2-standard-8" # 8 vCPU 32GB
    node_locations     = "us-central1-a,us-central1-b,us-central1-c"
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
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
  }
]

node_pools_labels = {
  core-pool = {},
  kafka-pool = {
    "roundtable.lsst.cloud/pool" = "kafka"
  },
  zookeeper-pool = {
    "roundtable.lsst.cloud/pool" = "zookeeper"
  }
}

node_pools_taints = {
  kafka-pool = [
    {
      key    = "dedicated"
      value  = "kafka"
      effect = "NO_EXECUTE"
    }
  ],
  zookeeper-pool = [
    {
      key    = "dedicated"
      value  = "zookeeper"
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
  "CADVISOR"
]

# Increase this number to force Terraform to update the production environment.
# Serial: 4
