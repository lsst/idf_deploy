module "private-postgres" {
  source = "../../../../modules/cloudsql/postgres-private"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    }
  ]
  database_version    = var.database_version
  db_name             = var.db_name
  tier                = var.tier
  database_flags      = var.database_flags
  names               = ["service-account"]
  project_roles       = ["${module.project_factory.project_id}=>roles/cloudsql.client"]
  project_id          = module.project_factory.project_id
  vpc_network         = module.project_factory.network_name
  deletion_protection = false
}
