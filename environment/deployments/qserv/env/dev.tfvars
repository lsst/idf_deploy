# Project
environment                 = "dev"
application_name            = "qserv"
folder_id                   = "195355585008"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "qserv-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.134.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
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


# Firewalls
custom_rules = {
  qserv = {
    description          = "Deployed with Terraform"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.128.0.0/23", "10.128.16.0/20", "10.129.0.0/16"]
    sources              = []
    targets              = ["gke-qserv-dev"]
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

custom_rules_2 = {
  olm-connectivity = {
    description          = "Deployed with Terraform. OLM Connectivity"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["172.20.0.0/28"]
    sources              = []
    targets              = ["gke-qserv-dev"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["5443"]
      }
    ]

    extra_attributes = {
      disabled           = false
      flow_logs          = false
      flow_logs_metadata = ""
    }
  }
}

custom_rules_3 = {
  operator-connectivity = {
    description          = "Deployed with Terraform. QServ Operator Connectivity"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["172.20.0.0/28"]
    sources              = []
    targets              = ["gke-qserv-dev"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["9443"]
      }
    ]

    extra_attributes = {
      disabled           = false
      flow_logs          = false
      flow_logs_metadata = ""
    }
  }
}


# NAT
address_count                       = 3
nat_name                            = "cloud-nat"
enable_endpoint_independent_mapping = false

# Increase this number to force Terraform to update the dev environment.
# Serial: 2
