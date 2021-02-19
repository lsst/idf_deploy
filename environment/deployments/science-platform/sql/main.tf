module "private-postgres" {
  source = "../../../modules/cloudsql/postgres-private"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    }
  ]
  database_version    = "POSTGRES_12"
  db_name             = "butler-postgresql-private"
  names               = ["service-account"]
  project_roles       = ["${module.project_factory.project_id}=>roles/cloudsql.client"]
  project_id          = module.project_factory.project_id
  vpc_network         = "butler-dev-vpc"
  deletion_protection = false
}