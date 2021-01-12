# Project
environment             = "dev"
application_name        = "science-platform"
folder_id               = "985686879610"

# VPC
network_name            = "science-platform-dev-vpc"
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
# master_ipv4_cidr_block = "172.16.0.0/28"

# Filestore
fileshare_capacity = 2600
fileshare_tier = "BASIC_SSD"
fs2_fileshare_capacity = 2600
fs2_tier = "BASIC_SSD"

# NAT
nats = [{ name = "cloud-nat" }]
