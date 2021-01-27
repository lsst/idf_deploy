# Project
environment                 = "int"
application_name            = "qserv"
folder_id                   = "506501599000"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "qserv-int-vpc"
subnets = [
  {
    "subnet_ip"             = "10.136.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.137.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.136.16.0/20"
    },
  ]
}

# Filestore
fileshare_capacity = 2000

# Firewall
custom_rules = {
  qserv-qserv = {
    description          = "qserv-qserv"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.130.0.0/23", "10.131.0.0/16", "10.130.16.0/20"]
    sources              = []
    targets              = ["gke-qserv-int"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["4040"]
      }
    ]

    extra_attributes = {
      disabled  = false
      flow_logs = "INCLUDE_ALL_METADATA"
    }
  }
}

# NAT
address_count = 1
nat_name      = "cloud-nat"
