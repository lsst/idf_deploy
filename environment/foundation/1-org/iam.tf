# -----------------------------------
#   Assign org level IAM groups and permissions
#
#   This will deploy org-level groups with
#   assigned roles.
# -----------------------------------

resource "google_organization_iam_member" "org_admins_group" {
  for_each = toset(var.org_admins_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.org_admins}"
}

resource "google_organization_iam_member" "org_network_admins_group" {
  for_each = toset(var.org_network_admins_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.network_admins}"
}

resource "google_organization_iam_member" "org_security_admins_group" {
  for_each = toset(var.org_security_admins_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.security_admins}"
}

resource "google_organization_iam_member" "org_viewer_group" {
  for_each = toset(var.org_viewer_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.org_viewers}"
}