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
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    initial_node_count = 3
    min_count          = 3
    max_count          = 100
  },
  {
    name               = "dask-pool"
    machine_type       = "n2-standard-32"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    initial_node_count = 0
    min_count          = 0
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
  }
]

node_pools_labels = {
  core-pool = {
    infrastructure = "ok",
    jupyterlab = "ok"
  },
  dask-pool = {
    dask = "ok"
  },
  kafka-pool = {
    kafka = "ok"
  }
}

node_pools_taints = {
  core-pool = [],
  dask-pool = []
  # Unfortunately, the kafka-pool node pool was created before taints were set.
  # It turns out that you can't modify a node pool to add taints; it must be
  # destroyed and recreated.
  #
  # But there are currently pods running on the kafka-pool nodes, including
  # critical core ones, so it's too dangerous to destroy the nodes. We'll have
  # to just leave it untainted.
  #
  # kafka-pool = [
  #   {
  #    effect = "NO_SCHEDULE"
  #    key = "kafka",
  #    value = "ok"
  #  }
  #]
  kafka-pool = []
}

# TF State declared during pipeline
# bucket = "lsst-terraform-state"
# prefix = "qserv/int/gke"

# Increase this number to force Terraform to update the dev environment.
# Serial: 3
