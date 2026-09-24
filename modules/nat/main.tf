module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 9.1"

  name       = var.name
  project_id = var.project
  region     = var.region
  network    = var.network
  nats       = var.nats
}
