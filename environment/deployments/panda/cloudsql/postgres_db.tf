module "panda-idds" {
  source = "../../../../modules/cloudsql/postgres-private_50"
  authorized_networks = [
    {
      "name" : "panda-dev-ip-address-1",
      "value" : "188.184.0.0/16"
    },
    {
      "name" : "panda-dev-ip-address-2",
      "value" : "188.185.0.0/16"
    }
  ]
  database_version    = var.database_version
  db_name             = var.db_name_2
  tier                = var.tier
  database_flags      = var.database_flags
  names               = ["panda-idds-service-account"]
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
