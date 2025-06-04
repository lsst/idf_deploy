# Project
environment             = "int"
application_name        = "science-platform"

# GKE
master_ipv4_cidr_block = "172.18.0.0/28"
gce_pd_csi_driver      = true
network_policy         = true
maintenance_start_time = "2021-08-19T00:00:00Z"
maintenance_end_time   = "2021-08-19T12:00:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=TH"

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-32"
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
    initial_node_count = 3
    min_count          = 3
    max_count          = 100
  },
  {
    name = "kafka-pool"
    machine_type = "n2-standard-32"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "500"
    disk_type          = "pd-standard"
    autoscaling        = true
    initial_node_count = 1
    min_count          = 1
    max_count          = 10
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
  },
  kafka-pool = {
    kafka = "ok"
  }
}

node_pools_taints = {
  core-pool = [],
  dask-pool = [],
  kafka-pool = [
    {
      effect = "NO_SCHEDULE"
      key = "kafka",
      value = "ok"
    }
  ],
  "user-lab-pool" = [
    {
      key = "nublado.lsst.io/permitted"
      value = "true"
      effect = "NO_EXECUTE"
    }
  ]
  
}

# Increase this number to force Terraform to update the int environment.
# Serial: 7
