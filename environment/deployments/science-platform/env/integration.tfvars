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

# NetApp Cloud Volumes
#
# Each item in netapp_definitions is what we need to create
# a storage pool/volume pair.
#
netapp_definitions = [
  { name                   = "home"
    service_level          = "PREMIUM"
    capacity_gib           = 5000
    unix_permissions       = "0775"
    snapshot_directory     = true
    backups_enabled        = true
    has_root_access        = true
    access_type            = "READ_WRITE"
    default_user_quota_mib = 35000
  },
  { name                   = "rubin"
    service_level          = "PREMIUM"
    capacity_gib           = 2048
    unix_permissions       = "1777"
    snapshot_directory     = false
    backups_enabled        = true
    has_root_access        = true
    access_type            = "READ_WRITE"
  },
  { name               = "firefly"
    service_level      = "PREMIUM"
    capacity_gib       = 2048
    unix_permissions   = "0755"
    snapshot_directory = false
    backups_enabled    = false
    has_root_access    = true
    access_type        = "READ_WRITE"
  },
  { name               = "delete-weekly"
    service_level      = "PREMIUM"
    capacity_gib       = 2048
    unix_permissions   = "1777"
    snapshot_directory = false
    backups_enabled    = false
    has_root_access    = true
    access_type        = "READ_WRITE"
  },
]


# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# and Cloud SQL Admin (required for the Cloud SQL Auth Proxy) in addition to
# our standard APIs.
activate_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "containerfilesystem.googleapis.com",
  "gkebackup.googleapis.com",
  "stackdriver.googleapis.com",
  "file.googleapis.com",
  "storage.googleapis.com",
  "artifactregistry.googleapis.com",
  "billingbudgets.googleapis.com",
  "servicenetworking.googleapis.com",
  "serviceusage.googleapis.com",
  "sqladmin.googleapis.com",
  "iap.googleapis.com"
]

atlantis_monitoring_admin_service_account_member = "serviceAccount:atlantis@roundtable-prod-f6fd.iam.gserviceaccount.com"

ingress_ip_address = {
  name = "nginx-load-balancer"

  # This description was already on the resource when we imported it
  description = "data-int.lsst.cloud"
}

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 22
