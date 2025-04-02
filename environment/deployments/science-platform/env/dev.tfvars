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
netapp_definitions = [
  { name = "home"
    service_level = "PREMIUM"
    capacity_gib = 2000
    protocols = [ "NFSV3", "NFSV4" ]
    deletion_policy = "DEFAULT"
    unix_permissions = 0770
    restricted_actions = []
    snapshot_directory = true
    snapshot_policy = {
      enabled = true
      hourly_schedule = {
        snapshots_to_keep = 24
	minute = 3
      }
      daily_schedule = {
        snapshots_to_keep = 7
	minute = 5
	hour = 2
      }
      weekly_schedule = {
        snapshots_to_keep = 5
      }
    }
    backup_policy = {
      enabled = true,
      daily_backup_limit = 7
      weekly_backup_limit = 5
      monthly_backup_limit = 12
    }
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 5000
  },
  { name = "project"
    service_level = "PREMIUM"
    capacity_gib = 2000
    protocols = [ "NFSV3", "NFSV4" ]
    deletion_policy = "DEFAULT"
    unix_permissions = 01777
    restricted_actions = []
    snapshot_directory = true
    snapshot_policy = {
      enabled = true
      hourly_schedule = {
        snapshots_to_keep = 24
	minute = 3
      }
      daily_schedule = {
        snapshots_to_keep = 7
	minute = 5
	hour = 2
      }
      weekly_schedule = {
        snapshots_to_keep = 5
      }
    }
    backup_policy = {
      enabled = true,
      daily_backup_limit = 7
      weekly_backup_limit = 5
      monthly_backup_limit = 12
    }
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 5000
  },
  { name = "scratch"
    service_level = "PREMIUM"
    capacity_gib = 2000
    protocols = [ "NFSV3", "NFSV4" ]
    deletion_policy = "DEFAULT"
    unix_permissions = 01777
    restricted_actions = []
    # No snapshots or backups.
    snapshot_directory = false
    snapshot_policy = {
      enabled = false
      hourly_schedule = {
        snapshots_to_keep = 0
	minute = 0
      }
      daily_schedule = {
        snapshots_to_keep = 0
	minute = 0
	hour = 0
      }
      weekly_schedule = {
        snapshots_to_keep = 0
      }
    }
    backup_policy = {
      enabled = false
      daily_backup_limit = 0
      weekly_backup_limit = 0
      monthly_backup_limit = 0
    }    
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 5000
  }
]
  


# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# Cloud SQL Admin (required for the Cloud SQL Auth Proxy), and Netapp Cloud
# Volumes in addition to our standard APIs.
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

# Increase this number to force Terraform to update the dev environment.
# Serial: 25
