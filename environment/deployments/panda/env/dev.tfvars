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

project_iam_sa_gcs_access = [
  "roles/logging.logWriter",
  "roles/storage.objectViewer",
  "roles/artifactregistry.writer"
]

# VPC
network_name = "panda-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.138.0.0/18",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.142.0.0/18",
    "subnet_name"           = "subnet-us-central1-02",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.144.0.0/18",
    "subnet_name"           = "subnet-us-central1-03",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.146.0.0/18",
    "subnet_name"           = "subnet-us-central1-04",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.148.0.0/18",
    "subnet_name"           = "subnet-us-central1-05",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.150.0.0/23",
    "subnet_name"           = "subnet-us-central1-06",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.158.0.0/23",
    "subnet_name"           = "subnet-us-central1-07",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  },
  {
    "subnet_ip"             = "10.160.0.0/23",
    "subnet_name"           = "subnet-us-central1-08",
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
      ip_cidr_range = "10.138.128.0/20"
    },
  ],
  "subnet-us-central1-02" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.143.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.142.128.0/20"
    },
  ],
  "subnet-us-central1-03" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.145.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.144.128.0/20"
    },
  ],
  "subnet-us-central1-04" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.147.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.146.128.0/20"
    },
  ],
  "subnet-us-central1-05" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.149.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.148.128.0/20"
    },
  ],
  "subnet-us-central1-06" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.151.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.150.16.0/20"
    },
  ],
  "subnet-us-central1-07" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.159.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.158.16.0/20"
    },
  ],
  "subnet-us-central1-08" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.161.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.160.16.0/20"
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

# 2-1-2022 by Aaron Strong
# The module nat block has been commented out because we're using new tech preview features
# that are not available to the API. This block is failing our build pipeline.

# NAT
# address_count          = 0 # Do not need an address if using `AUTO_ONLY`
# nat_name               = "cloud-nat"
# nat_ip_allocate_option = "AUTO_ONLY"
# min_ports_per_vm       = 4096 

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
  "containers" = false
}

# Increase this number to force Terraform to update the dev environment.
# Serial: 2

