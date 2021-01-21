# Project
environment                 = "dev"
application_name            = "panda"
folder_id                   = "133576577272"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "panda-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.138.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.139.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.138.16.0/20"
    },
  ]
}

# Firewall
custom_rules = {
  panda = {
    description          = "Deployed with Terraform"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.128.0.0/23", "10.128.16.0/20", "10.129.0.0/16"]
    sources              = []
    targets              = ["gke-panda-dev"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["4040"]
      }
    ]

    extra_attributes = {
      disabled           = false
      flow_logs          = true
      flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

# NAT
address_count = 1
nat_name      = "cloud-nat"
