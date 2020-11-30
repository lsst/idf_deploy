resource "google_project_iam_member" "project" {
  for_each = toset(var.project_iam_permissions)
  project  = var.project
  role     = each.value
  member   = "group:${var.member}"
}