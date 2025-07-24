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
# 20250516: remove once data migrated to Netapp
filestore_definitions = []

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
  },
  allow-ingress-from-iap = {
    description          = "Allow ingress from IAP CIDR ranges."
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["35.235.240.0/20"]
    sources              = []
    targets              = ["gke-science-platform-dev"]
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
nats = [{ name = "cloud-nat" }]

# NetApp Cloud Volumes
#
# Each item in netapp_definitions is what we need to create
# a storage pool/volume pair.
#
# In dev, to save money, we are just packing everything onto one filesystem.
netapp_definitions = [
  {
    name                   = "home-tiered"
    service_level          = "PREMIUM"
    capacity_gib           = 2048
    unix_permissions       = "0775"
    snapshot_directory     = true
    backups_enabled        = true
    has_root_access        = true
    access_type            = "READ_WRITE"
    default_user_quota_mib = 5000
    allow_auto_tiering     = true
    enable_auto_tiering    = true
    cooling_threshold_days = 7
    override_user_quotas = [
      {
        username       = "bot-mobu-user"
        uid            = 100001
        disk_limit_mib = 6000
      },
      {
        username       = "bot-mobu-tutorial"
        uid            = 100024
        disk_limit_mib = 10000
      },
      {
        username       = "firefly"
        uid            = 91
        disk_limit_mib = 500000
      }
    ]
  }
]



# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# and Cloud SQL Admin (required for the Cloud SQL Auth Proxy) in addition to
# our standard APIs.
activate_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "containerfilesystem.googleapis.com",
  "stackdriver.googleapis.com",
  "file.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
  "artifactregistry.googleapis.com",
  "servicenetworking.googleapis.com",
  "sqladmin.googleapis.com",
  "iap.googleapis.com",
  "netapp.googleapis.com"
]

atlantis_monitoring_admin_service_account_member = "serviceAccount:atlantis@roundtable-prod-f6fd.iam.gserviceaccount.com"

# Increase this number to force Terraform to update the dev environment.
# Serial: 49
