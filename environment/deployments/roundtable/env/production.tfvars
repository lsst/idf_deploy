# Project
environment      = "prod"
application_name = "roundtable"
folder_id        = "445517661944"

# VPC
network_name = "roundtable-prod-vpc"
subnets = [
  {
    "subnet_ip" : "10.164.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1",
    "subnet_private_access" : "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.165.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.164.16.0/20"
    },
  ]
}

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
    ranges               = ["172.30.0.0/28"]
    sources              = []
    targets              = ["gke-roundtable-prod"]
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

# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# and Cloud SQL Admin (required for the Cloud SQL Auth Proxy) in addition to
# our standard APIs.
activate_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "containerfilesystem.googleapis.com",
  "stackdriver.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
  "servicenetworking.googleapis.com",
  "sqladmin.googleapis.com"
]

vault_server_bucket_suffix = "vault-server"

prodromos_terraform_state_bucket_suffix = "prodromos-terraform"
# Increase this number to force Terraform to update the prod environment.
# Serial: 11
