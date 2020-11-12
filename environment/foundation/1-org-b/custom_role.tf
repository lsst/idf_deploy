locals {
  members = "domain:${data.google_organization.org.domain}"
}

resource "google_organization_iam_custom_role" "my-custom-role" {
  role_id     = var.custom_role_id
  org_id      = module.constants.values.org_id
  title       = var.custom_role_name
  description = "A folder tree view"
  permissions = ["resourcemanager.folders.get", "resourcemanager.folders.list"]
}

resource "google_folder_iam_binding" "custom_binding" {
  folder = data.google_active_folder.custom_role_bind.name
  role   = google_organization_iam_custom_role.my-custom-role.id
  members = [
    local.members,
  ]
}