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
  for_each      = tomap({
                    for voldef in var.definitions: "${voldef.name}" => voldef
                  })
  project       = var.project
  location      = var.location
  name          = "pool-${each.value.name}"
  network       = var.network
  labels        = var.labels
  
  service_level = each.value.service_level
  capacity_gib  = each.value.capacity_gib
}

resource "google_netapp_backup_vault" "instance" {
  # Singleton per location
  name = "backupVault"
  location = var.location
  project = var.project
  labels = var.labels
}

resource "google_netapp_volume" "instance" {
  for_each           = tomap({
                          for voldef in var.definitions: "${voldef.name}" => voldef
                       })
  location           = var.location
  labels             = var.labels
  project            = var.project
  # allowed_ips        = module.vpc.subnets_ips
  
  capacity_gib       = each.value.capacity_gib
  name               = each.value.name
  share_name         = "${each.value.name}-share"
  storage_pool       = "pool-${each.value.name}"  // Maybe need the path?
  protocols          = each.value.protocols
  deletion_policy    = each.value.deletion_policy
  unix_permissions   = each.value.unix_permissions
  snapshot_directory = each.value.snapshot_directory
  large_capacity     = ((each.value.capacity_gib >= 15360) &&  ((each.value.service_level == "PREMIUM") || (each.value.service_level == "EXTREME"))) ? true : false
  security_style     = "UNIX"
  kerberos_enabled   = false
  
  # An argument named "snapshot_policy" is not expected here. Did you mean to
  # define a block of type "snapshot_policy"?
  # I don't know, did I?
  #
  # Comment these out for now...
  snapshot_policy    {
    enabled = each.value.snapshot_policy.enabled
    hourly_schedule {
      snapshots_to_keep = each.value.snapshot_policy.hourly_schedule.snapshots_to_keep
      minute = each.value.snapshot_policy.hourly_schedule.minute
    }
    daily_schedule {
      snapshots_to_keep = each.value.snapshot_policy.daily_schedule.snapshots_to_keep
      minute = each.value.snapshot_policy.daily_schedule.minute
      hour = each.value.snapshot_policy.daily_schedule.hour
    }
    weekly_schedule {
      snapshots_to_keep = each.value.snapshot_policy.weekly_schedule.snapshots_to_keep
      minute = each.value.snapshot_policy.weekly_schedule.minute
      hour = each.value.snapshot_policy.weekly_schedule.hour
      day = each.value.snapshot_policy.weekly_schedule.day
    }
  }
  restricted_actions = each.value.restricted_actions
  # export_policy = ## Uh oh, here's where we need a nested loop over rules
  backup_config {
    scheduled_backup_enabled = each.value.backup_policy.enabled
    backup_policies = [ "projects/${var.project}/locations/${var.location}/backupPolicies/backup_${each.value.name}" ]
    backup_vault = "projects/${var.project}/locations/${var.location}/backupVaults/backupVault"
  }
}

resource "google_netapp_backup_policy" "instance" {
  depends_on           = [google_netapp_volume.instance]  // needs each?
  location             = var.location
  for_each             = tomap({
                           for voldef in var.definitions: "${voldef.name}" => voldef
                         })

  labels               = var.labels
  project              = var.project

  name                 = "backup_${each.value.name}"
  enabled              = each.value.backup_policy.enabled
  daily_backup_limit   = each.value.backup_policy.daily_backup_limit
  weekly_backup_limit  = each.value.backup_policy.weekly_backup_limit
  monthly_backup_limit = each.value.backup_policy.monthly_backup_limit
}

resource "google_netapp_volume_quota_rule" "default_user_quota" {
  // default user quota rule
  for_each             = tomap({
                           for voldef in var.definitions: "${voldef.name}" => voldef
                         })

  name                 = "${each.value.name}-default-quota"
  depends_on           = [ google_netapp_volume.instance ]  // needs each?
  type                 = "DEFAULT_USER_QUOTA"
  labels               = var.labels
  disk_limit_mib       = each.value.default_user_quota_mib
  volume_name          = each.value.name
  description          = "Default user quota for ${each.value.name}"
}
