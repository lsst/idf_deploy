# The idea here is:
#
# A given science-platform instance will have an arbitrary number of
# NetApp Cloud Volumes.  Each one of these will have its own storage pool,
# so the volume-to-pool mapping is one-to-one.
#
# That instance will have a single backup vault.  Each volume will have its
# own backup and snapshot policy, which could be null (for instance, the
# scratch volume likely does not need backups).
#
# Each instance will also get its own default user quota.  Terraforming
# additions to the user quotas is not yet supported; the ID mapping is the
# difficult part.
#
# At this point we're not implementing tiered storage, user key management,
# or volume replication, and we are assuming UNIX/NFS rather than AD/SMB.


# References I'm going to need
# https://discuss.hashicorp.com/t/how-to-deal-with-nested-for-each-loops-in-dependent-ressources/50551/2
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

resource "google_netapp_storage_pool" "instance" {
  # Each volume gets its own pool, at least for now.
  for_each      = var.definitions
  project       = var.project
  location      = var.location
  name          = "pool-${each.name}"
  network       = var.network
  labels        = var.labels
  
  service_level = each.service_level
  description   = each.description
  capacity_gib  = each.capacity_gib
}

resource "google_netapp_backup_vault" "instance" {
  # Singleton per location
  name = "backupVault"
  location = var.location
  project = var.project
  labels = var.label
}

resource "google_netapp_volume" "instance" {
  for_each           = var.definitions
  location           = var.location
  labels             = var.labels
  project            = var.project
  
  capacity           = each.capacity_gib
  name               = each.name
  share_name         = "${each.name}-share"
  storage_pool       = "pool-${each.name}"  // Maybe need the path?
  protocols          = each.protocols
  deletion_policy    = each.deletion_policy
  unix_permissions   = each.unix_permissions
  description        = each.description
  snapshot_directory = each.snapshot_directory
  snapshot_policy    = each.snapshot_policy
  restricted_actions = each.restricted_actions
  export_policy      = each.export_policy
  backup_config      = { backup_policies = "projects/${var.project}/locations/${var.location}/backupPolicies/backup_${name}"
                         backup_vault = "projects/${var.project}/locations/${var.location}/backupVaults/backupVault"
                       }
  large_capacity     = ((each.capacity_gib >= 15360) &&  ((each.service_level == "PREMIUM") || (each.service_level == "EXTREME"))) ? true : false
  security_style     = "UNIX"
  kerberos_enabled   = false
}

resource "google_netapp_backup_policy" "instance" {
  depends_on           = [google_netapp_volume.instance]  // needs each?
  location             = var.location
  for_each             = var.definitions
  labels               = var.labels
  project              = var.project

  name                 = "backup_${each.name}"
  enabled              = each.backup_policy.enabled
  daily_backup_limit   = each.backup_policy.daily_backup_limit
  weekly_backup_limit  = each.backup_policy.weekly_backup_limit
  monthly_backup_limit = each.backup_policy.monthly_backup_limit
}

resource "google_netapp_volume_quota_rule" "default_user_quota" {
  // default user quota rule
  for_each             = var.definitions
  depends_on           = [ google_netapp_volume.instance ]  // needs each?
  type                 = "DEFAULT_USER_QUOTA"
  labels               = var.labels
  disk_limit_mib       = each.default_user_quota_mib
  volume_name          = each.name
  description          = "Default user quota for ${each.name}"
}

