# Project
environment                 = "dev"
application_name            = "alert-prod"
folder_id                   = "410727518766"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "alert-dev-vpc"
subnets = [
  {
    "subnet_ip"             = "10.150.0.0/23",
    "subnet_name"           = "subnet-us-central1-01",
    "subnet_region"         = "us-central1",
    "subnet_private_access" = "true"
  }
]
secondary_ranges = {
  "subnet-us-central1-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.151.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.150.16.0/20"
    },
  ]
}

# Google Group
id           = "gcp-alert-prod-administrators@lsst.cloud"
display_name = "GCP Alert Production Administrators"
description  = "GCP Alert Production Administrators"
customer_id  = "C01q23ze7"
owners       = ["hchiang-admin@lsst.cloud"]
members      = ["nsedaghat@lsst.cloud","swnelson@lsst.cloud"]

# NAT
nats = [{ name = "cloud-nat" }]
