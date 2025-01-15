module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = module.project.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

}