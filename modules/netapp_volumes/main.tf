# A given RSP instance at the IDF will have an arbitrary number of NetApp
# Cloud Volumes.
#
# We expect each instance to have at least three, corresponding to home,
# project, and scratch space.
#
# If the number of volumes is greater than zero, the RSP instance will have
# a single backup vault.  That is configured in the RSP instance definition
# rather than here.  What is configured in this module is the set of objects
# created for a single volume definition, which is passed in as var.definition.
#
# Each volume will have its own storage pool defined: the volume-to-pool
# mapping is one-to-one.  Unless we go to individual user volumes (which we
# could do with "FLEX" volumes and the Trident operator), we will not need
# volumes smaller than the minimum pool size, so it is simpler to manage
# single-volume pools whose entire storage is dedicated to that volume.
#
# Each volume can enable or disable backups and snapshots.  If enabled, these
# will have standard retention policies, rather than per-volume configuration
# settings.  This is a (reversible) choice made to simplify configuration.
#
# Each volume may have a default user quota.  In practice, the home and
# project volumes should certainly have a quota, and the scratch volume
# probably should.
#
# Each volume may additionally have zero or more override user quotas
# specified.  Whether the username matches the UID is not checked, and in
# fact the username is only given to make quota identification easier; the
# implementation relies only on the UID.
#
# We currently do not implement tiered storage, user key management, or
# volume replication.  We assume UNIX/NFS rather than AD/SMB as our identity
# and file sharing protocol implementation.

# This could be simplified, probably, if we used
# https://github.com/GoogleCloudPlatform/terraform-google-netapp-volumes
# However, that provider does not yet support quotas, which are the entire
# reason we need to move to NetApp volumes.

# Per-volume storage pool
resource "google_netapp_storage_pool" "instance" {
  project  = var.project
  location = var.location
  name     = "pool-${var.definition.name}"
  network  = var.network
  labels   = var.labels

  service_level = var.definition.service_level
  capacity_gib  = var.definition.capacity_gib
}

# Volume
resource "google_netapp_volume" "instance" {
  location = var.location
  labels   = var.labels
  project  = var.project

  capacity_gib       = var.definition.capacity_gib
  name               = var.definition.name
  share_name         = "${var.definition.name}-share"
  storage_pool       = "pool-${var.definition.name}"
  unix_permissions   = var.definition.unix_permissions
  snapshot_directory = var.definition.snapshot_directory

  # Opinionated choices not exposed to users
  protocols          = ["NFSV3", "NFSV4"]
  deletion_policy    = "DEFAULT"
  restricted_actions = ["DELETE"]
  large_capacity     = ((var.definition.capacity_gib >= 15360) && ((var.definition.service_level == "PREMIUM") || (var.definition.service_level == "EXTREME"))) ? true : false
  security_style     = "UNIX"
  kerberos_enabled   = false

  snapshot_policy {
    enabled = var.definition.snapshot_directory
    hourly_schedule {
      snapshots_to_keep = 24
      minute            = 3
    }
    daily_schedule {
      snapshots_to_keep = 7
      minute            = 6
      hour              = 3
    }
    weekly_schedule {
      snapshots_to_keep = 5
      minute            = 9
      hour              = 6
      day               = "Sunday"
    }
  }

  backup_config {
    scheduled_backup_enabled = var.definition.backups_enabled
    backup_policies          = var.definition.backups_enabled ? ["projects/${var.project}/locations/${var.location}/backupPolicies/backup_${var.definition.name}"] : null
    backup_vault             = var.definition.backups_enabled ? "projects/${var.project}/locations/${var.location}/backupVaults/netapp-backup-vault" : null
  }

  export_policy {
    rules {
      allowed_clients = var.allowed_ips # The "kubernetes-pods" range
      has_root_access = var.definition.has_root_access
      access_type     = var.definition.access_type
    }
  }
}

# Backup policy (if needed); highly opinionated
resource "google_netapp_backup_policy" "instance" {

  count = var.definition.backups_enabled ? 1 : 0

  location = var.location
  labels   = var.labels
  project  = var.project

  name    = "backup_${var.definition.name}"
  enabled = var.definition.backups_enabled

  # We may want to make this configurable again sometime.

  daily_backup_limit   = 7
  weekly_backup_limit  = 5
  monthly_backup_limit = 12

}

# Disabled if the default quota is not set
resource "google_netapp_volume_quota_rule" "default_user_quota" {

  count = var.definition.default_user_quota_mib == null ? 0 : 1

  name           = "${var.definition.name}-default-quota"
  depends_on     = [google_netapp_volume.instance]
  type           = "DEFAULT_USER_QUOTA"
  labels         = var.labels
  disk_limit_mib = var.definition.default_user_quota_mib == null ? 0 : var.definition.default_user_quota_mib
  volume_name    = var.definition.name
  description    = "Default user quota for ${var.definition.name}"
}

# Listed in configuration; username is not checked.
resource "google_netapp_volume_quota_rule" "individual_user_quota" {

  for_each = tomap({
    for quota in var.definition.override_user_quotas : "${quota.uid}" => quota
  })

  depends_on     = [google_netapp_volume.instance]
  type           = "INDIVIDUAL_USER_QUOTA"
  labels         = var.labels
  volume_name    = var.definition.name
  name           = "user-quota-${var.definition.name}-${each.value.uid}"
  disk_limit_mib = each.value.disk_limit_mib
  target         = each.value.uid
  description    = "User quota for ${each.value.username}[${each.value.uid}]: ${each.value.disk_limit_mib} MiB"
}
