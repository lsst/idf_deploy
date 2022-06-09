# Project
environment             = "dev"
application_name        = "science-platform"

# GKE
release_channel        = "RAPID"
master_ipv4_cidr_block = "172.16.0.0/28"
gce_pd_csi_driver      = true
maintenance_start_time = "2021-08-18T00:00:00Z"
maintenance_end_time   = "2021-08-18T12:00:00Z"
maintenance_recurrence = "FREQ=WEEKLY;BYDAY=WE"

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
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
  }
]

node_pools_labels = {
  core-pool = {
    infrastructure = "ok",
    jupyterlab = "ok"
  }
}

# Increase this number to force Terraform to update the dev environment.
# Serial: 2
