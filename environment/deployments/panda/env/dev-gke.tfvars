# Project
environment      = "dev"
application_name = "panda"

# VPC
network_name = "panda-dev-vpc"

# GKE
master_ipv4_cidr_block   = "172.22.0.0/28"
master_ipv4_cidr_block_2 = "172.23.0.0/28"
master_ipv4_cidr_block_3 = "172.24.0.0/28"
master_ipv4_cidr_block_4 = "172.25.0.0/28"
master_ipv4_cidr_block_5 = "172.26.0.0/28"
master_ipv4_cidr_block_6 = "172.27.0.0/28"
release_channel          = "RAPID"
cluster_telemetry_type   = "SYSTEM_ONLY"
max_pods_per_node        = "15"

# ---- EXCEPTIONS TO DEFAULT VALUES ----- # 
identity_namespace_highmem_non_preempt = null # do not deploy workload identity for cluster
identity_namespace_moderatemem         = null
node_metadata_highmem_non_preempt      = "UNSPECIFIED"
node_metadata_moderatemem              = "UNSPECIFIED"
dns_cache_highmem_non_preempt          = true
dns_cache_moderatemem                  = true
# RAPID does not provide logging for GCP Support
release_channel_highmem_non_preempt = "REGULAR"
release_channel_moderatemem         = "REGULAR"

# ---- NODE POOLS ---- #
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
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 0
    min_count          = 0
    max_count          = 1000
    service_account    = "tf-gke-moderatemem-bwbc@panda-dev-1a74.iam.gserviceaccount.com"
  },
  {
    name               = "panda-low-mem-2-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 0
    min_count          = 0
    max_count          = 1000
    service_account    = "tf-gke-moderatemem-bwbc@panda-dev-1a74.iam.gserviceaccount.com"
  },
  {
    name               = "panda-low-mem-3-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 0
    min_count          = 0
    max_count          = 1000
    service_account    = "tf-gke-moderatemem-bwbc@panda-dev-1a74.iam.gserviceaccount.com"
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
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 0
    min_count          = 1
    max_count          = 1000
  },
  {
    name               = "panda-high-mem-1-pool"
    machine_type       = "n2-custom-4-43008-ext"
    node_locations     = "us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = true
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 0
    min_count          = 0
    max_count          = 1000
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
    disk_type          = "pd-ssd"
    autoscaling        = true
    node_count         = 1
    min_count          = 1
    max_count          = 800
    service_account    = "tf-gke-moderatemem-bwbc@panda-dev-1a74.iam.gserviceaccount.com"
  }
]

node_pools_merge_0 = [
  {
    name               = "node-pools-merge-0"
    machine_type       = "n2-standard-4"
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
    min_count          = 0
    max_count          = 10
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
    min_count          = 1
    max_count          = 5
  }
]

node_pool_extra_mem_0 = [
  {
    name               = "panda-extra-mem-1-pool"
    machine_type       = "n2-custom-2-240640-ext"
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
    min_count          = 0
    max_count          = 200
  }
]

node_pool_extra_mem_non_preempt_0 = [
  {
    name               = "panda-extra-mem-non-preempt-pool"
    machine_type       = "n2-custom-2-240640-ext"
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
    node_count         = 0
    min_count          = 0
    max_count          = 200
  }
]
