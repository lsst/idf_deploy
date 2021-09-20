# Project
environment             = "dev"
application_name        = "panda"

# VPC
network_name            = "panda-dev-vpc"

# GKE
master_ipv4_cidr_block = "172.22.0.0/28"
master_ipv4_cidr_block_2 = "172.23.0.0/28"
master_ipv4_cidr_block_3 = "172.24.0.0/28"
master_ipv4_cidr_block_4 = "172.25.0.0/28"
master_ipv4_cidr_block_5 = "172.26.0.0/28"
release_channel = "RAPID"
cluster_telemetry_type = "SYSTEM_ONLY"
max_pods_per_node = "15"
node_pools = [
  {
    name               = "panda-low-mem-1-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = true
    node_count         = 0
    min_count = 0
    max_count = 1000
  }
]

node_pools_2 = [
  { 
    name               = "panda-high-mem-0-pool"
    machine_type       = "n2-custom-4-43008-ext"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = true
    node_count         = 0
    min_count = 0
    max_count = 1000
  }
 ]

node_pools_non_preempt_0 = [
  {
    name               = "panda-high-mem-0-pool"
    machine_type       = "n2-custom-4-43008-ext"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = true
    node_count         = 1
    min_count = 0
    max_count = 10
  }
 ]

node_pools_merge_0 = [
  {
    name               = "node_pools_merge_0"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = true
    node_count         = 1
    min_count = 0
    max_count = 10
  }
 ]


node_pools_dev = [
  { 
    name               = "panda-low-mem-1-pool"
    machine_type       = "n2-custom-6-8960"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = true
    node_count         = 0
  }
 ]
