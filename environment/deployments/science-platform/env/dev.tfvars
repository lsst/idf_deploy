# Project
environment      = "dev"
application_name = "science-platform"
folder_id        = "985686879610"

# VPC
network_name = "science-platform-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.128.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1"
    "subnet_private_access" = "true"
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
#fileshare_capacity = 2600
#fileshare_tier = "BASIC_SSD"

# FIREWALL
custom_rules = {
  cert-manager-terraform = {
    description          = "cert manager rule created by terraform"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["172.16.0.0/28"]
    sources              = []
    targets              = ["gke-science-platform-dev"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["8443"]
      }
    ]
    extra_attributes = {}
  }
}


# NAT
nats = [{ name = "cloud-nat" }]
