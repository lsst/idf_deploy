module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 1.3"

  name    = var.name
  project = var.project
  region  = var.region
  network = var.network
  nats    = var.nats
}
