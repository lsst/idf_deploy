# Project
environment             = "dev"
application_name        = "qserv"

# VPC
network_name            = "qserv-dev-vpc"


# GKE  
master_ipv4_cidr_block = "172.20.0.0/28"
release_channel = "RAPID"
cluster_telemetry_type = "SYSTEM_ONLY"
node_pools = [
  {
    name               = "czar-pool"
    machine_type       = "n2-standard-32"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = "false"
    node_count         = 1
  },
  {
    name               = "worker-pool"
    machine_type       = "n2-standard-32"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = "false"
    node_count         = 10
  },
  {
    name               = "utility-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "100"
    disk_type          = "pd-standard"
    autoscaling        = "false"
    node_count         = 1
  },
]
