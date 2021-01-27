# Project
environment             = "stable"
application_name        = "science-platform"
folder_id               = "719717645081"

# VPC
network_name            = "science-platform-stable-vpc"
subnets = [
  {
    "subnet_ip" : "10.132.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.133.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.132.16.0/20"
    },
  ]
}

# Filestore
fileshare_capacity = 8000
