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

resource "random_password" "gafaelfawr" {
  length  = 24
  number  = true
  upper   = true
  special = false
}

data "google_compute_network" "network" {
  name    = var.network
  project = var.project_id
}

module "db_science_platform" {
  source = "../../../../modules/cloudsql/postgres-sql"

  authorized_networks             = []
  database_version                = var.database_version
  db_name                         = "${var.application_name}-${var.environment}"
  deletion_protection             = true
  enable_default_db               = false
  enable_default_user             = false
  maintenance_window_day          = var.db_maintenance_window_day
  maintenance_window_hour         = var.db_maintenance_window_hour
  maintenance_window_update_track = var.db_maintenance_window_update_track
  project_id                      = var.project_id
  random_instance_name            = true
  ipv4_enabled                    = false
  private_network                 = data.google_compute_network.network.self_link

  additional_databases = [
    {
      name      = "gafaelfawr"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
  ]

  additional_users = [
    {
      name     = "gafaelfawr"
      password = random_password.gafaelfawr.result
    }
  ]

  database_flags = [
    {
      name  = "password_encryption"
      value = "scram-sha-256"
    }
  ]
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"

  project_id    = var.project_id
  display_name  = "PostgreSQL client"
  description   = "Terraform-managed service account for PostgreSQL access"
  names         = ["gafaelfawr"]
  project_roles = ["${var.project_id}=>roles/cloudsql.client"]
}
