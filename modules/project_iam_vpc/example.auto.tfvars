activate_apis = [
  "compute.googleapis.com"
]
application_name        = ""
billing_account         = ""
cost_centre             = ""
default_region          = "us-west1"
default_service_account = "keep"
environment             = ""
folder_id               = ""
group_name              = ""
group_name_binding      = "roles/editor"
mode                    = "additive"
network_name            = "custom-vpc"
org_id                  = ""
project_prefix          = ""
routing_mode            = "REGIONAL"
secondary_ranges = {
  "subnet-01": [
    {
      "ip_cidr_range": "192.168.64.0/24",
      "range_name": "subnet-01-secondary-01"
    }
  ]
}
skip_gcloud_download = true
subnets = [
  {
    "subnet_ip": "10.10.10.0/24",
    "subnet_name": "subnet-01",
    "subnet_region": "us-central1"
  }
]
vpc_type = ""