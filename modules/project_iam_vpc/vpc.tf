module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.5"

  project_id   = module.project.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode

  subnets = [
    {
      subnet_name               = var.subnet_name
      subnet_ip                 = var.subnet_ip
      subnet_region             = var.default_region
      subnet_flow_logs          = var.subnet_flow_logs
      subnet_flow_logs_interval = var.subnet_flow_logs_interval
      subnet_flow_logs_sampling = var.flow_logs_sampling
      subnet_flow_logs_metadata = var.flow_logs_metadata
    }
  ]
}