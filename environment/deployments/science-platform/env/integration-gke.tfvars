# Project
environment             = "int"
application_name        = "science-platform"

# VPC
#network_name            = "science-platform-int-vpc"
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
master_ipv4_cidr_block = "172.18.0.0/28"

node_pools = [
  {
    name               = "core-pool"
    machine_type       = "n1-standard-4"
    node_locations     = "us-central1-b,us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-ssd"
    autoscaling        = "false"
    node_count         = 3
  },
]

# TF State
bucket = "lsst-terraform-state"
prefix = "qserv/int/gke"
