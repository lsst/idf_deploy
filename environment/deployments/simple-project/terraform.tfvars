activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com"
  ]
application_name        = "science_platform"
billing_account         = "01122E-72D62B-0B0581"
cost_centre             = "0123456789"
default_region          = "us-central1"
default_service_account = "keep"
environment             = "prod"
folder_id               = "370233560583"
group_name              = "gcp-science-platform-gke-cluster-admins@lsst.cloud"
group_name_binding      = "roles/editor"
mode                    = "additive"
network_name            = "custom-vpc"
org_id                  = "288991023210"
project_prefix          = "gke"
routing_mode            = "REGIONAL"
secondary_ranges = {
  "subnet-01" : [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "192.168.0.0/18"
    },
    {
      range_name    = "kubernetes-services"
      ip_cidr_range = "192.168.64.0/18"
    },
  ]
}
skip_gcloud_download = true
subnets = [
  {
    "subnet_ip" : "10.10.10.0/24",
    "subnet_name" : "subnet-01",
    "subnet_region" : "us-central1"
  }
]
vpc_type = ""