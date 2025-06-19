# Project
environment      = "stable"
application_name = "science-platform"
folder_id        = "719717645081"

# VPC
network_name = "science-platform-stable-vpc"
subnets = [
  {
    "subnet_ip" : "10.132.0.0/23",
    "subnet_name" : "subnet-us-central1-01",
    "subnet_region" : "us-central1",
    "subnet_private_access" : "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.133.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.132.16.0/20"
    },
  ]
}

# LEGACY filestore, to be removed once new volumes are in place and
# data has been copied.
fileshare_capacity = 24000

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
    ranges               = ["172.30.0.0/28"]
    sources              = []
    targets              = ["gke-science-platform-stable"]
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

# NetApp Cloud Volumes
#
# Each item in netapp_definitions is what we need to create
# a storage pool/volume pair.
#
netapp_definitions = [
  { name                   = "home"
    service_level          = "PREMIUM"
    capacity_gib           = 100000
    unix_permissions       = "0775"
    snapshot_directory     = true
    backups_enabled        = true
    has_root_access        = true
    allow_auto_tiering     = true
    access_type            = "READ_WRITE"
    default_user_quota_mib = 35000
  },
  { name               = "rubin"
    service_level      = "PREMIUM"
    capacity_gib       = 8000
    unix_permissions   = "0755"
    snapshot_directory = false
    backups_enabled    = true
    has_root_access    = true
    allow_auto_tiering = true
    access_type        = "READ_WRITE"
  },
  { name               = "firefly"
    service_level      = "PREMIUM"
    capacity_gib       = 5000
    unix_permissions   = "0755"
    snapshot_directory = false
    backups_enabled    = false
    has_root_access    = true
    access_type        = "READ_WRITE"
  },
  { name               = "deleted-sundays"
    service_level      = "PREMIUM"
    capacity_gib       = 8000
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
  "stackdriver.googleapis.com",
  "file.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
  "artifactregistry.googleapis.com",
  "servicenetworking.googleapis.com",
  "sqladmin.googleapis.com"
]

# Increase this number to force Terraform to update the production environment.
# Serial: 5
