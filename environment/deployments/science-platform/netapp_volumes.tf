# Service accounts/WI for Netapp Cloud Volumes
# Will be needed for Trident operator

resource "google_service_account" "netapp_admin_sa" {
  account_id   = "netapp-admin"
  display_name = "Netapp Cloud Volume admin service account"
  description  = "Terraform-managed service account for Netapp Cloud Volume access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "netapp_admin_sa_wi" {
  service_account_id = google_service_account.netapp_admin_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[netapp-backup/netapp-backup]"
}

resource "google_project_iam_member" "netapp_admin_sa_file" {
  role       = "roles/netapp.admin"
  member     = "serviceAccount:${google_service_account.netapp_admin_sa.email}"
  project    = module.project_factory.project_id
}

locals {
  # Extract allowable IP ranges for NetApp clients.  We need the primary subnet
  # range and any secondary ranges.
  flat_allow_2dry_ips = flatten(
    values(
      var.secondary_ranges
    )
  )
  allowed_ip_list = concat([var.subnets[0]["subnet_ip"]],[ for subnet in local.flat_allow_2dry_ips: subnet.ip_cidr_range ])

  # General labels
  labels = {
    project          = module.project_factory.project_id
    environment      = var.environment
    application_name = var.application_name
  }
}

resource "google_netapp_backup_vault" "instance" {
  # Singleton per location, only exists if netapp_definitions is not empty
  count = length(var.netapp_definitions) == 0 ? 0 : 1

  name       = "netapp-backup-vault"
  location   = var.subnets[0].subnet_region
  project    = module.project_factory.project_id
  labels     = local.labels
}

module "netapp-volumes" {
  for_each = tomap({
    for voldef in var.netapp_definitions : "${voldef.name}" => voldef
  })
  source   = "../../../modules/netapp_volumes"
  network  = module.project_factory.network.network_id
  project  = module.project_factory.project_id
  location = var.subnets[0].subnet_region
  labels = {
    project          = module.project_factory.project_id
    environment      = var.environment
    application_name = var.application_name
    netapp_volume    = each.value.name
  }
  allowed_ips = join(",",local.allowed_ip_list)
  definition  = each.value
}
