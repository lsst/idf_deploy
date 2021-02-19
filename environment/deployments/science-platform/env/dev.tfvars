# Project
environment                 = "dev"
application_name            = "science-platform"
folder_id                   = "985686879610"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "science-platform-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.128.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
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
fileshare_capacity = 3000
#fileshare_tier = "BASIC_SSD"

# FIREWALL
#
# This allows the Kubernetes master to talk to validation controllers
# running inside the GKE cluster.  The IP range must match
# master_ipv4_cidr_block in the GKE configuration.
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

# Enable Google Artifact Registry in addition to our standard APIs
activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com",
    "artifactregistry.googleapis.com"
]
