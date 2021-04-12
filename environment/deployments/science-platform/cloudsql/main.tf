module "private-postgres" {
  source = "../../../../modules/cloudsql/postgres-private"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    }
  ]
  database_version    = var.butler_database_version
  db_name             = var.butler_db_name
  tier                = var.butler_tier
  database_flags      = var.butler_database_flags
  names               = ["service-account"]
  project_roles       = ["${var.project_id}=>roles/cloudsql.client"]
  project_id          = var.project_id
  vpc_network         = var.network
  require_ssl         = var.butler_require_ssl
  deletion_protection = false
}
