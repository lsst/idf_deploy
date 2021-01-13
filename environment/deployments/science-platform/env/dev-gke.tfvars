# Project
# null update to force redeployment
environment             = "dev"
application_name        = "science-platform"

# VPC
#network_name            = "science-platform-dev-vpc"
subnets = [
  {
    "subnet_ip" : "10.128.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.129.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.128.16.0/20"
    },
  ]
}

# GKE
release_channel = "RAPID"
master_ipv4_cidr_block = "172.16.0.0/28"

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n2-standard-4"
    node_locations     = "us-central1-b"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    autoscaling        = false
    node_count         = 5
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
