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

module "db_roundtable" {
  source = "../../../../modules/cloudsql/postgres-private_50"

  authorized_networks             = []
  database_version                = var.database_version
  db_name                         = "${var.application_name}-${var.environment}"
  deletion_protection             = true
  enable_default_db               = false
  enable_default_user             = false
  maintenance_window_day          = var.db_maintenance_window_day
  maintenance_window_hour         = var.db_maintenance_window_hour
  maintenance_window_update_track = var.db_maintenance_window_update_track
  project_roles                   = ["${var.project_id}=>roles/cloudsql.client"]
  names                           = ["service-account"]
  project_id                      = var.project_id
  random_instance_name            = true
  ipv4_enabled                    = false
  vpc_network                     = data.google_compute_network.network.name
  tier                            = var.database_tier
  insights_config                 = var.insights_config

  backup_configuration = {
    enabled                        = var.backups_enabled
    start_time                     = "09:00"
    location                       = "us-central1"
    point_in_time_recovery_enabled = false
  }

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
      name  = "max_connections"
      value = 100
    },
    {
      name  = "password_encryption"
      value = "scram-sha-256"
    }
  ]
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id    = var.project_id
  display_name  = "PostgreSQL client"
  description   = "Terraform-managed service account for PostgreSQL access"
  names         = ["gafaelfawr"]
  project_roles = ["${var.project_id}=>roles/cloudsql.client"]
}

resource "google_service_account_iam_member" "gafaelfawr_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["gafaelfawr"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[gafaelfawr/gafaelfawr]"
}

resource "google_service_account_iam_member" "gafaelfawr_schema_update_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["gafaelfawr"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[gafaelfawr/gafaelfawr-schema-update]"
}
