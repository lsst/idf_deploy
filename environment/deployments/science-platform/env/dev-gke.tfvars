# Project
environment             = "dev"
application_name        = "science-platform"

# GKE
release_channel        = "RAPID"
master_ipv4_cidr_block = "172.16.0.0/28"
gce_pd_csi_driver      = true

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    autoscaling        = true
    initial_node_count = 1
    min_count          = 1
    max_count          = 5
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
  },
  {
    name               = "dask-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-b"
    node_count         = 0
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    autoscaling        = false
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
  }
]

node_pools_labels = {
  core-pool = {
    infrastructure = "ok"
    jupyterlab = "ok"
  },
  dask-pool = {
    dask = "ok"
  }
}

# CloudSQL
db_maintenance_window_day          = 1
db_maintenance_window_hour         = 22
db_maintenance_window_update_track = "canary"
