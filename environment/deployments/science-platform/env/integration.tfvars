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

# NetApp Cloud Volumes
#
# Each item in netapp_definitions is what we need to create
# a storage pool/volume pair.
#
netapp_definitions = [
  { name = "home"
    service_level = "PREMIUM"
    capacity_gib = 5000
    unix_permissions = "0770"
    snapshot_directory = true
    backups_enabled = true
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 10000
    # These are empirically determined, rounded up to the next 10GB, except
    # for Firefly, which keeps a week's worth of uploads and is currently
    # about 500GB.
    override_user_quotas = [
      {
        username = "firefly",
	uid = 91,
	disk_limit_mib = 1000000
      },
      {
        username = "mgower",
	uid = 3000009,
	disk_limit_mib = 20000
      },
      {
        username = "wguan",
	uid = 30000023,
	disk_limit_mib = 20000
      },
      {
        username = "plazas",
	uid = 30000051,
	disk_limit_mib = 20000
      },
      {
        username = "douglasleetucker",
	uid = 30000026,
	disk_limit_mib = 30000
      },
      {
        username = "cadair",
	uid = 30000038,
	disk_limit_mib = 30000
      },
      {
        username = "hlin730",
	uid = 3000007,
	disk_limit_mib = 30000
      },
      {
        username = "yanny",
	uid = 30000012,
	disk_limit_mib = 40000
      }
    ]
  },
  { name = "project"
    service_level = "PREMIUM"
    capacity_gib = 3000
    unix_permissions = "1777"
    snapshot_directory = true
    backups_enabled = true
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 5000  # Mostly owned by root.
    # Do we even need Gaia DR2?
  },
  { name = "scratch"
    service_level = "PREMIUM"
    capacity_gib = 5000
    unix_permissions = "1777"
    has_root_access = true
    access_type = "READ_WRITE"
    default_user_quota_mib = 10000
    override_user_quotas = []
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
  "artifactregistry.googleapis.com",
  "billingbudgets.googleapis.com",
  "servicenetworking.googleapis.com",
  "serviceusage.googleapis.com",
  "sqladmin.googleapis.com",
  "iap.googleapis.com"
]

# Increase this number to force Terraform to update the int environment.
# Serial: 9


