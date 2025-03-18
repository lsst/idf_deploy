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

resource "google_organization_iam_member" "org_billing_admins_group" {
  for_each = toset(var.org_billing_administrator_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.billing_admins}"
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

resource "google_organization_iam_member" "org_monitoring_admins" {
  for_each = toset(var.org_monitoring_admins_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.monitoring_admins}"
}

resource "google_organization_iam_member" "org_monitoring_viewer" {
  for_each = toset(var.org_monitoring_viewer_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.monitoring_viewer}"
}

resource "google_organization_iam_member" "org_cloudsql_admins" {
  for_each = toset(var.org_cloudsql_admins_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.cloudsql_admins}"
}
  
resource "google_organization_iam_member" "dns_validator_sa" {
 org_id   = module.constants.values.org_id
 role     = "roles/compute.viewer"
 member   = "serviceAccount:dns-validator-wi@science-platform-int-dc5d.iam.gserviceaccount.com"
}
