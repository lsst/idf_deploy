activate_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "stackdriver.googleapis.com",
  "file.googleapis.com",
  "storage.googleapis.com"
]
application_name        = "science-platform" # name is also used for IAM
billing_account         = "01122E-72D62B-0B0581"
cost_centre             = "0123456789"
default_region          = "us-central1"
default_service_account = "keep"
environment             = "prod"
folder_id               = "370233560583"
network_name            = "custom-vpc"
org_id                  = "288991023210"
project_prefix          = "gke-splatform" # min. 4 characters
routing_mode            = "REGIONAL"
secondary_ranges = {
  "subnet-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.129.0.0/16"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "10.128.2.0/20"
    },
  ]
}
skip_gcloud_download = true
subnets = [
  {
    "subnet_ip" : "10.128.0.0/23",
    "subnet_name" : "subnet-01",
    "subnet_region" : "us-central1"
  }
]
vpc_type = ""