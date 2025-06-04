# NetApp Cloud Volumes
#
# Each item in netapp_definitions is what we need to create
# a storage pool/volume pair.
#
netapp_definitions = [
  { name                   = "home"
    service_level          = "PREMIUM"
    capacity_gib           = 2048
    unix_permissions       = "0775"
    snapshot_directory     = true
    backups_enabled        = true
    has_root_access        = true
    access_type            = "READ_WRITE"
    default_user_quota_mib = 5000
    override_user_quotas = [
      {
        username       = "bot-mobu-user"
        uid            = 100001
        disk_limit_mib = 6000
      }
    ]
  },
  { name                   = "rubin"
    service_level          = "PREMIUM"
    capacity_gib           = 2048
    unix_permissions       = "1777"
    snapshot_directory     = true
    backups_enabled        = true
    has_root_access        = true
    access_type            = "READ_WRITE"
    default_user_quota_mib = 5000
  },
  { name             = "firefly"
    service_level    = "PREMIUM"
    capacity_gib     = 2048
    unix_permissions = "0755"
    has_root_access  = true
    access_type      = "READ_WRITE"
  },
  { name             = "deleted-weekly"
    service_level    = "PREMIUM"
    capacity_gib     = 2048
    unix_permissions = "1777"
    has_root_access  = true
    access_type      = "READ_WRITE"
  }
]

# Increase this number to force Terraform to update the dev environment.
# Serial: 0
