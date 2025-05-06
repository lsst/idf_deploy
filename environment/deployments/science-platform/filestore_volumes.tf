resource "google_service_account" "filestore_tool_sa" {
  account_id   = "filestore-tool"
  display_name = "filestore tool account"
  description  = "Terraform-managed service account for Filestore access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "filestore_tool_sa_wi" {
  service_account_id = google_service_account.filestore_tool_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[filestore-backup/filestore-backup]"
}

resource "google_project_iam_member" "filestore_tool_sa_file" {
  role    = "roles/file.editor"
  member  = "serviceAccount:${google_service_account.filestore_tool_sa.email}"
  project = module.project_factory.project_id
}

module "filestore" {
  for_each = tomap({
    for voldef in var.filestore_definitions : "{voldef.name}" => voldef
  })
  source = "../../../modules/filestore"
  network  = module.project_factory.network.network_id
  project  = module.project_factory.project_id
  location = var.subnets[0].subnet_region
  capacity = each.value.capacity
  name = each.value.name
  modes = each.value.modes
  tier = each.value.tier
  labels = {
    project          = module.project_factory.project_id
    environment      = var.environment
    application_name = var.application_name
    filestore_volume = each.value.name
  }
}
