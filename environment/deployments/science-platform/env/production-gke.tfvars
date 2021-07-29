# Project
environment             = "stable"
application_name        = "science-platform"

# GKE
master_ipv4_cidr_block = "172.30.0.0/28"
gce_pd_csi_driver      = true
network_policy         = false

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
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
#    autoscaling        = true
#    initial_node_count = 5
#    min_count          = 5
#    max_count          = 100
    autoscaling        = false
    node_count         = 5
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
    autoscaling        = false
    node_count         = 0
  }
]

node_pools_labels = {
  core-pool = {
    infrastructure = "ok",
    jupyterlab = "ok"
  },
  dask-pool = {
    dask = "ok"
  }
}

# TF State declared during pipeline
# bucket = "lsst-terraform-state"
# prefix = "qserv/stable/gke"

# Increase this number to force Terraform to update the dev environment.
# Serial: 1
