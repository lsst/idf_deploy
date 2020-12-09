# Project
environment             = "int"
application_name        = "qserv"

# VPC
network_name            = "qserv-int-vpc"
subnets = [
  {
    "subnet_ip" : "10.134.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.135.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.134.16.0/20"
    },
  ]
}


# GKE
master_ipv4_cidr_block = "172.21.0.0/28"
release_channel = "RAPID"
node_pools = [
  {
    name               = "czar-pool"
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
    autoscaling        = "false"
    node_count         = 1
  },
  {
    name               = "worker-pool"
    machine_type       = "n2-standard-16"
    node_locations     = "us-central1-b,us-central1-c"
    local_ssd_count    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    image_type         = "cos_containerd"
    enable_secure_boot = true
    disk_size_gb       = "200"
    disk_type          = "pd-standard"
    autoscaling        = "false"
    node_count         = 5
  },
]