# Sets up a connection from the VPC to Google services, to allow the use of a
# private IP.
module "private-service-access" {
  source = "../../../../modules/cloudsql/private_service_access"

  project_id  = var.project_id
  vpc_network = var.network
}

moved {
  from = module.private-postgres
  to   = module.private-postgres[0]
}
moved {
  from = module.private-postgres[0].module.private-service-access
  to   = module.private-service-access
}

# Butler Registry DP02
module "db_butler_registry_dp02" {
  count  = var.butler_registry_dp02_enable ? 1 : 0
  source = "../../../../modules/cloudsql/postgres-sql"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    }
  ]
  database_version                = var.butler_registry_dp02_database_version
  db_name                         = var.butler_registry_dp02_db_name
  tier                            = var.butler_registry_dp02_tier
  database_flags                  = var.butler_registry_dp02_database_flags
  disk_size                       = var.butler_registry_dp02_disk_size
  enable_default_db               = false
  enable_default_user             = false
  edition                         = var.butler_registry_dp02_edition
  maintenance_window_day          = var.butler_registry_dp02_db_maintenance_window_day
  maintenance_window_hour         = var.butler_registry_dp02_db_maintenance_window_hour
  maintenance_window_update_track = var.butler_registry_dp02_db_maintenance_window_update_track
  random_instance_name            = false
  project_id                      = var.project_id
  private_network                 = data.google_compute_network.network.self_link
  ipv4_enabled                    = var.butler_registry_dp02_ipv4_enabled
  ssl_mode                        = var.butler_registry_dp02_ssl_mode
  deletion_protection             = true

  backup_configuration = {
    enabled                        = var.butler_registry_dp02_backups_enabled
    start_time                     = var.butler_registry_dp02_backups_start_time
    location                       = "us-central1"
    point_in_time_recovery_enabled = var.butler_registry_dp02_backups_point_in_time_recovery_enabled
  }
}

moved {
  # The 'count' parameter to this module was added after it was already
  # deployed to dev.
  from = module.db_butler_registry_dp02
  to   = module.db_butler_registry_dp02[0]
}

# Butler Registry for Data Preview 1
module "db_butler_registry_dp1" {
  count  = var.butler_registry_dp1_enabled ? 1 : 0
  source = "../../../../modules/cloudsql/postgres-sql"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    }
  ]
  database_version = "POSTGRES_16"
  db_name          = "butler-registry-dp1-${var.environment}"
  tier             = var.butler_registry_dp1_tier
  database_flags = [
    { name = "max_connections", value = "400" },
    { name = "password_encryption", value = "scram-sha-256" }
  ]
  disk_size                       = 20
  enable_default_db               = false
  enable_default_user             = false
  edition                         = "ENTERPRISE"
  maintenance_window_day          = 4
  maintenance_window_hour         = 23
  maintenance_window_update_track = "stable"
  random_instance_name            = false
  project_id                      = var.project_id
  private_network                 = data.google_compute_network.network.self_link
  ipv4_enabled                    = false
  ssl_mode                        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  deletion_protection             = true

  backup_configuration = {
    enabled                        = var.butler_registry_dp1_backups_enabled
    start_time                     = "09:00"
    location                       = "us-central1"
    point_in_time_recovery_enabled = false
    backup_retention_settings = {
      retained_backups = 2
    }
  }
}

# AlloyDB Butler Registry for Data Preview 0.2 and Data Preview 1.
# This is being explored as a more-scalable alternative to Cloud SQL.
module "alloydb_butler_data_preview" {
  source = "../../../../modules/alloydb"
  count  = var.butler_registry_alloydb_enabled ? 1 : 0

  cluster_id = "butler-data-preview-${var.environment}"
  location   = "us-central1"
  network_id = data.google_compute_network.network.id
  project_id = var.project_id
  database_version = "POSTGRES_16"
}

# AlloyDB used as Butler registry for serving prompt data products.
module "alloydb_butler_prompt_data_products" {
  source = "../../../../modules/alloydb"
  count  = var.butler_prompt_data_products_enabled ? 1 : 0

  cluster_id = "butler-prompt-${var.environment}"
  location   = "us-central1"
  network_id = data.google_compute_network.network.id
  project_id = var.project_id
  database_version = "POSTGRES_17"
  enable_public_ip_for_primary = true
}

resource "google_dns_managed_zone" "sql_private_zone" {
  name        = "sql-private-zone-${var.environment}"
  dns_name    = "rsp-sql-${var.environment}.internal."
  description = "DNS Zone containing domain names used to access internal databases."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.network.id
    }
  }
}

resource "google_dns_record_set" "dp02" {
  count = var.butler_registry_dp02_enable ? 1 : 0

  managed_zone = google_dns_managed_zone.sql_private_zone.name
  name         = "dp02.${google_dns_managed_zone.sql_private_zone.dns_name}"
  type         = "A"
  rrdatas      = [module.db_butler_registry_dp02[0].private_ip_address]
  ttl          = 1800
}

resource "google_dns_record_set" "dp1" {
  count = var.butler_registry_dp1_enabled ? 1 : 0

  managed_zone = google_dns_managed_zone.sql_private_zone.name
  name         = "dp1.${google_dns_managed_zone.sql_private_zone.dns_name}"
  type         = "A"
  rrdatas      = [module.db_butler_registry_dp1[0].private_ip_address]
  ttl          = 1800
}

resource "google_dns_record_set" "alloydb_dp" {
  count = var.butler_registry_alloydb_enabled ? 1 : 0

  managed_zone = google_dns_managed_zone.sql_private_zone.name
  name         = "alloydb-dp.${google_dns_managed_zone.sql_private_zone.dns_name}"
  type         = "A"
  rrdatas      = [module.alloydb_butler_data_preview[0].read_pool_private_ip]
  ttl          = 1800
}

resource "google_dns_record_set" "alloydb_butler_prompt" {
  count = var.butler_prompt_data_products_enabled ? 1 : 0

  managed_zone = google_dns_managed_zone.sql_private_zone.name
  name         = "alloydb-butler-prompt.${google_dns_managed_zone.sql_private_zone.dns_name}"
  type         = "A"
  rrdatas      = [module.alloydb_butler_prompt_data_products[0].read_pool_private_ip]
  ttl          = 1800
}


resource "random_password" "gafaelfawr" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "grafana" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "nublado" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "times-square" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "vo-cutouts" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "wobbly" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "ssotap" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

resource "random_password" "tap" {
  length  = 24
  numeric = true
  upper   = true
  special = false
}

data "google_compute_network" "network" {
  name    = var.network
  project = var.project_id
}

# Science Platform Database
module "db_science_platform" {
  source = "../../../../modules/cloudsql/postgres-sql"

  authorized_networks             = []
  database_version                = var.science_platform_database_version
  db_name                         = "${var.application_name}-${var.environment}"
  deletion_protection             = true
  enable_default_db               = false
  enable_default_user             = false
  maintenance_window_day          = var.science_platform_db_maintenance_window_day
  maintenance_window_hour         = var.science_platform_db_maintenance_window_hour
  maintenance_window_update_track = var.science_platform_db_maintenance_window_update_track
  project_id                      = var.project_id
  random_instance_name            = true
  ipv4_enabled                    = false
  private_network                 = data.google_compute_network.network.self_link
  tier                            = var.science_platform_database_tier

  backup_configuration = {
    enabled                        = var.science_platform_backups_enabled
    start_time                     = var.science_platform_backups_start_time
    location                       = "us-central1"
    point_in_time_recovery_enabled = false
  }

  additional_databases = [
    {
      name      = "gafaelfawr"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "grafana"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "nublado"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "times-square"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "vo-cutouts"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "wobbly"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "ssotap"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "tap"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
  ]

  additional_users = [
    {
      name            = "gafaelfawr"
      password        = random_password.gafaelfawr.result
      random_password = false
    },
    {
      name            = "grafana"
      password        = random_password.grafana.result
      random_password = false
    },
    {
      name            = "nublado"
      password        = random_password.nublado.result
      random_password = false
    },
    {
      name            = "times-square"
      password        = random_password.times-square.result
      random_password = false
    },
    {
      name            = "vo-cutouts"
      password        = random_password.vo-cutouts.result
      random_password = false
    },
    {
      name            = "ssotap"
      password        = random_password.ssotap.result
      random_password = false
    },
    {
      name            = "tap"
      password        = random_password.tap.result
      random_password = false
    },
    {
      name            = "wobbly"
      password        = random_password.wobbly.result
      random_password = false
    },
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

module "cutouts_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = var.project_id
  storage_class = "STANDARD"
  location      = "us-central1"
  prefix_name   = "rubin-cutouts-${var.environment}-us-central1"
  suffix_name   = ["output"]

  # This bucket is used for temporary output from cutout jobs and all
  # objects should be automatically deleted after some period of time.
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      },
      condition = {
        age = var.maximum_cutouts_age
      }
    }
  ]
}

locals {
  cutout_service_account = module.service_accounts.service_accounts_map["vo-cutouts"].email
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = ">= 4.0"

  project_id   = var.project_id
  display_name = "PostgreSQL client"
  description  = "Terraform-managed service account for PostgreSQL access"
  names = [
    "gafaelfawr",
    "grafana",
    "nublado",
    "ssotap",
    "tap-service",
    "times-square",
    "vo-cutouts",
    "wobbly",
  ]
  project_roles = ["${var.project_id}=>roles/cloudsql.client"]
}

resource "google_storage_bucket_iam_binding" "cutouts-bucket-ro-iam-binding" {
  bucket = module.cutouts_bucket.name
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${local.cutout_service_account}",
  ]
}

resource "google_storage_bucket_iam_binding" "cutouts-bucket-rw-iam-binding" {
  bucket = module.cutouts_bucket.name
  role   = "roles/storage.legacyBucketWriter"
  members = [
    "serviceAccount:${local.cutout_service_account}"
  ]
}

resource "google_service_account_iam_member" "gafaelfawr_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["gafaelfawr"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[gafaelfawr/gafaelfawr]"
}

resource "google_service_account_iam_member" "grafana_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["grafana"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[grafana/grafana]"
}

resource "google_service_account_iam_member" "gafaelfawr_operator_wi" {
  service_account_id = module.service_accounts.service_accounts_map["gafaelfawr"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[gafaelfawr/gafaelfawr-operator]"
}

resource "google_service_account_iam_member" "nublado_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["nublado"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[nublado/cloud-sql-proxy]"
}

resource "google_service_account_iam_member" "times_square_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["times-square"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[times-square/times-square]"
}

resource "google_service_account_iam_member" "vo_cutouts_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["vo-cutouts"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[vo-cutouts/vo-cutouts]"
}

resource "google_service_account_iam_member" "wobbly_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["wobbly"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[wobbly/wobbly]"
}

resource "google_service_account_iam_member" "ssotap_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["ssotap"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[ssotap/ssotap]"
}

resource "google_service_account_iam_member" "tap_sa_wi" {
  service_account_id = module.service_accounts.service_accounts_map["tap-service"].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[tap/tap]"
}

# The vo-cutouts service account must be granted the ability to generate
# tokens for itself so that it can generate signed GCS URLs starting from
# the GKE service account token without requiring an exported secret key
# for the underlying Google service account.
resource "google_service_account_iam_member" "vo_cutouts_sa_token" {
  service_account_id = module.service_accounts.service_accounts_map["vo-cutouts"].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.cutout_service_account}"
}
