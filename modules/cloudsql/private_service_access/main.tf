module "private-service-access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = ">= 19.0.0"

  project_id    = var.project_id
  vpc_network   = var.vpc_network
  address       = var.address
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  labels        = var.labels

}
