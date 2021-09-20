module "private-postgres" {
  source = "../../../../modules/cloudsql/postgres-private_50"
  authorized_networks = [
    {
      "name" : "sample-gcp-health-checkers-range",
      "value" : "130.211.0.0/28"
    },
    {
      "name" : "science-platform-int external-nat-ip",
      "value" : "35.239.140.105/32"
    },
    {
      "name" : "panda-dev merge-external-nat-ip",
      "value" : "34.70.87.107/32"
    },
    {
      "name" : "test-docker",
      "value" : "35.223.19.106/32"
    }
  ]
  database_version    = var.database_version
  db_name             = var.db_name
  tier                = var.tier
  database_flags      = var.database_flags
  names               = ["service-account"]
  project_roles       = ["${var.project_id}=>roles/cloudsql.client"]
  project_id          = var.project_id
  vpc_network         = var.network
  require_ssl         = var.require_ssl
  deletion_protection = true
  ipv4_enabled        = true
  insights_config     = var.insights_config

  backup_configuration = {
    enabled                        = var.backups_enabled
    start_time                     = "09:00"
    location                       = "us-central1"
    point_in_time_recovery_enabled = false
  }
}
