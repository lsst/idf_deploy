label_application_name = "org-shared-services-prod"

// Shared VPC Network Name

network_name           = "shared-vpc-prod"

// Subnets for Shared VPC

subnets = [
  {
    subnet_name           = "us-central1-prod-0"
    subnet_ip             = "10.128.0.0/16"
    subnet_region         = "us-central1"
    subnet_private_access = "true"
    subnet_flow_logs      = "false"
    // Uncomment below to set VPC Flow Logs sampling
    # description               = "Prod subnet 0."
    # subnet_flow_logs_interval = "INTERVAL_1_MIN"
    # subnet_flow_logs_sampling = ".3"
    # subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
  }
]
