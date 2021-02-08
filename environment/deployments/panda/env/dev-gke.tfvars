# Project
environment             = "dev"
application_name        = "panda"

# VPC
network_name            = "panda-dev-vpc"

# GKE
master_ipv4_cidr_block = "172.22.0.0/28"
master_ipv4_cidr_block_2 = "172.23.0.0/28"
release_channel = "RAPID"
cluster_telemetry_type = "SYSTEM_ONLY"
node_pools = [
  {
    name               = "panda-low-mem-0-pool"
    machine_type       = "n2-standard-8"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "32"
    disk_type          = "pd-ssd"
    autoscaling        = "true"
    node_count         = 0
  }
]
node_pools_2 = [
  { 
    name               = "panda-low-mem-0-pool"
    machine_type       = "n2-standard-8"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "32"
    disk_type          = "pd-ssd"
    autoscaling        = "true"
    node_count         = 0
  }
 ]

