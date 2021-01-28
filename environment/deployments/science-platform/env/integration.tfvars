# Project
environment                 = "int"
application_name            = "science-platform"
folder_id                   = "19762437767"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "science-platform-int-vpc"
subnets = [
  {
    "subnet_ip" : "10.130.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1",
    "subnet_private_access" = "true"    
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

# Filestore
#fileshare_capacity = 2600

# FIREWALL
custom_rules = {
  cert-manager-terraform = {
    description          = "cert manager rule created by terraform"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["172.16.0.0/28"]
    sources              = []
    targets              = ["gke-science-platform-int"]
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
