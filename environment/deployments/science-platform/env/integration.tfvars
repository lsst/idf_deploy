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
fileshare_capacity = 4000

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
    ranges               = ["172.18.0.0/28"]
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
  },
  allow-ingress-from-iap = {
    description          = "Allow ingress from IAP CIDR ranges."
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["35.235.240.0/20"]
    sources              = []
    targets              = ["gke-science-platform-int"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    extra_attributes = {}
  }
}

# NAT

num_static_ips = 1

# Enable Service Usage API in addition to our standard APIs
activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "iap.googleapis.com"
]
