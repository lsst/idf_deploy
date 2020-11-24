subnets = [
  {
    subnet_name               = "us-central1-prod-0"
    subnet_ip                 = "10.68.0.0/21"
    subnet_region             = "us-central1"
    subnet_private_access     = "true"
    subnet_flow_logs          = "true"
    description               = "Prod subnet 0."
    subnet_flow_logs_interval = "INTERVAL_1_MIN"
    subnet_flow_logs_sampling = ".3"
    subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
  }
]

