# Terraform backend access only. Members also need infrastructure permissions
# through gcp-ppdb-administrators@lsst.cloud.
locals {
  terraform_apply_members = var.ppdb_dev_terraform_apply_members
  terraform_state_prefixes = [
    "ppdb/dev",
    "ppdb/dev/cloudsql",
    "ppdb/dev/services",
    "science-platform/dev/cloudsql",
  ]
  terraform_apply_prefixes = slice(local.terraform_state_prefixes, 0, 3)
}

resource "google_storage_bucket_iam_member" "terraform_dependency_state" {
  for_each = local.terraform_apply_members
  bucket   = var.ppdb_dev_terraform_state_bucket
  role     = "roles/storage.objectViewer"
  member   = each.value

  condition {
    title       = "ppdb-dev-terraform-dependency-read"
    description = "Read only the Science Platform dependency state"
    expression = join(" || ", [
      for prefix in slice(local.terraform_state_prefixes, 3, 4) :
      "resource.name == 'projects/_/buckets/${var.ppdb_dev_terraform_state_bucket}/objects/${prefix}/default.tfstate'"
    ])
  }
}

resource "google_storage_bucket_iam_member" "terraform_apply_state" {
  for_each = local.terraform_apply_members
  bucket   = var.ppdb_dev_terraform_state_bucket
  role     = "roles/storage.objectAdmin"
  member   = each.value

  condition {
    title       = "ppdb-dev-terraform-state-and-locks"
    description = "Manage only PPDB dev default workspace state and locks"
    expression = join(" || ", [
      for object in flatten([for prefix in local.terraform_apply_prefixes : ["${prefix}/default.tfstate", "${prefix}/default.tflock"]]) :
      "resource.name == 'projects/_/buckets/${var.ppdb_dev_terraform_state_bucket}/objects/${object}'"
    ])
  }
}

# The GCS backend lists workspaces during init. Object-name conditions cannot
# limit storage.objects.list to a prefix. This grants bucket metadata/list
# access, without granting reads of any additional object contents.
resource "google_storage_bucket_iam_member" "terraform_workspace_list" {
  for_each = local.terraform_apply_members
  bucket   = var.ppdb_dev_terraform_state_bucket
  role     = "roles/storage.legacyBucketReader"
  member   = each.value
}

