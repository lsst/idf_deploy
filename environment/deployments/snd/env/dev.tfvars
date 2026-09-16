# Project
environment                 = "dev"
application_name            = "snd"
folder_id                   = "850770437583"
budget_amount               = 100
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]

# VPC
network_name = "snd-dev-vpc"
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

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 1
