# Project
environment                 = "dev"
application_name            = "panda"
folder_id                   = "133576577272"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]
activate_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "stackdriver.googleapis.com",
  "file.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
  "servicenetworking.googleapis.com",
  "iap.googleapis.com"
]

# VPC
network_name = "panda-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.138.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.142.0.0/23",
    "subnet_name"           = "subnet-us-central1-02",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.144.0.0/23",
    "subnet_name"           = "subnet-us-central1-03",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.139.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.138.16.0/20"
    },
  ],
  "subnet-us-central1-02" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.143.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.142.16.0/20"
    },
  ],
  "subnet-us-central1-03" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.145.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.144.16.0/20"
    },
  ]
}

# Firewall
custom_rules = {
  panda = {
    description          = "Deployed with Terraform"
    direction            = "INGRESS"
    action               = "allow"
    ranges               = ["10.128.0.0/23", "10.128.16.0/20", "10.129.0.0/16"]
    sources              = []
    targets              = ["gke-panda-dev"]
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

custom_rules2 = {
  allow-ssh = {
    description = "Deployed with Terraform"
    direction   = "INGRESS"
    action      = "allow"
    #   ranges              = ["69.119.24.0/22", "130.199.0.0/16"]
    ranges = ["0.0.0.0/0"]

    sources              = []
    targets              = ["allow-ssh"]
    use_service_accounts = false
    rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]

    extra_attributes = {
      disabled = false
      priority = 900
    }
  }
}

# NAT
address_count          = 1
nat_name               = "cloud-nat"
nat_ip_allocate_option = "AUTO_ONLY"
min_ports_per_vm       = 4096

# IAP
members = ["group:gcp-panda-administrators@lsst.cloud"]

# INSTANCE
machine_type  = "n2-highmem-4"
num_instances = "1"
size          = 100
image         = "centos-7-v20210316"
tags          = ["allow-ssh"]
type          = "pd-standard"
# source_image_family  = "centos-7"
# source_image_project = "centos-cloud"

bucket_policy_only = {
  "drp-us-central1-containers" = false
}