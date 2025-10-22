# Project
environment                 = "dev"
application_name            = "roundtable"
folder_id                   = "631904369379"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "roundtable-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.162.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.163.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.162.16.0/20"
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
    ranges               = ["172.16.0.0/28"]
    sources              = []
    targets              = ["gke-roundtable-dev"]
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
  "gkebackup.googleapis.com",
  "stackdriver.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
  "servicenetworking.googleapis.com",
  "sqladmin.googleapis.com"
]

vault_server_bucket_suffix = "vault-server-dev"

prodromos_terraform_state_bucket_suffix = "prodromos-terraform-dev"

atlantis_monitoring_admin_service_account_member = "serviceAccount:atlantis@roundtable-prod-f6fd.iam.gserviceaccount.com"

ingress_ip_address = {
  # This was already on the resource when we imported it
  name = "public-ip"
  description = null
}

# Increase this number to force Terraform to update the dev environment.
# Serial: 18
