# Sets up a connection from the VPC to Google services.  It's unclear what is
# still using this, but terraform is refusing to delete it, claiming that it is
# in use. Possibly something in the GKE setup is relying on it?
module "private-service-access" {
  source = "../../../../modules/cloudsql/private_service_access"

  project_id    = var.project_id
  vpc_network   = var.network
}

moved {
  from = module.private-postgres.module.private-service-access
  to = module.private-service-access
}