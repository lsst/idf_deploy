# Project
environment             = "int"
application_name        = "science-platform"
folder_id               = "19762437767"

# VPC
network_name            = "science-platform-int-vpc"
subnets = [
  {
    "subnet_ip" : "10.130.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.131.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.130.16.0/20"
    },
  ]
}

# GKE
master_ipv4_cidr_block = "172.17.0.0/28"
# node_pool_1_name = "core-pool"
# node_pool_1_machine_type = "e2-standard-4" # 4 vCPU 16GB RAM
# node_pool_1_min_count = 1
# node_pool_1_max_count = 15
# node_pool_1_disk_size_gb = 100
# node_pool_1_initial_node_count = 5

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "g1-small"
    node_locations     = "us-central1-b"
    min_count          = 1
    max_count          = 15
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    initial_node_count = 5
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "100"
    disk_type          = "pd-standard"
  },
  {
    name               = "jhub-pool"
    machine_type       = "g1-small"
    node_locations     = "us-central1-b"
    min_count          = 1
    max_count          = 5
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    initial_node_count = 1
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "100"
    disk_type          = "pd-standard"
  }]

# Filestore
#fileshare_capacity = 2600

# NAT
nats = [{ name = "cloud-nat" }]
