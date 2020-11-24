provider "google" {
  version = "~> 3.1"
}

provider "google-beta" {
  version = "~> 3.1"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

locals {
  impersonation_apis = distinct(concat(var.activate_apis, ["serviceusage.googleapis.com", "iamcredentials.googleapis.com"]))
  activate_apis      = var.sa_enable_impersonation == true ? local.impersonation_apis : var.activate_apis
  is_organization    = var.parent_folder == "" ? true : false
  parent_id          = var.parent_folder == "" ? module.constants.values.org_id : split("/", var.parent_folder)[1]
}

resource "random_id" "suffix" {
  byte_length = 2
}

/*************************************************
  Import Constants.
*************************************************/
module "constants" {
  source = "../constants"
}

# -----------------------------
# Bootstrap GCP Organization.
# -----------------------------
locals {
  parent = module.constants.deploy_at_root ? "organizations/${module.constants.values.org_id}" : "folders/${module.constants.values.parent_folder}"
}

resource "google_folder" "seed" {
  display_name = var.seed_folder_name
  parent       = local.parent
}

module "cloudbuild_bootstrap" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 9.0"

  name                        = var.project_prefix
  random_project_id           = var.random_project_id
  disable_services_on_destroy = var.disable_services_on_destroy
  folder_id                   = google_folder.seed.id
  org_id                      = module.constants.values.org_id
  billing_account             = module.constants.values.billing_account
  activate_apis               = local.activate_apis
  labels                      = var.project_labels
  skip_gcloud_download        = var.skip_gcloud_download
}

# -----------------------------
# GCS Bucket - Terraform State
# -----------------------------

resource "google_storage_bucket" "org_terraform_state" {
  project            = module.cloudbuild_bootstrap.project_id
  name               = format("%s-%s-%s", var.project_prefix, "tfstate", random_id.suffix.hex)
  location           = module.constants.values.default_region
  labels             = var.storage_bucket_labels
  bucket_policy_only = true
  force_destroy      = true
  versioning {
    enabled = true
  }
}

# -----------------------------
# Cloud Billing
# -----------------------------

resource "google_billing_account_iam_member" "binding" {
  billing_account_id = module.constants.values.billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${module.cloudbuild_bootstrap.project_number}@cloudbuild.gserviceaccount.com"
}

# -----------------------------
#  Organization permissions for org admins.
# -----------------------------

resource "google_organization_iam_member" "org_admins_group" {
  for_each = toset(var.org_admins_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "group:${module.constants.values.groups.org_admins}"
}

# -----------------------------
#  Organization permissions for billing admins.
# -----------------------------

resource "google_organization_iam_member" "org_billing_admin" {
  org_id = module.constants.values.org_id
  role   = "roles/billing.admin"
  member = "group:${module.constants.values.groups.billing_admins}"
}

# -----------------------------
# Organization permissions for Cloud Build Service Account
# -----------------------------

resource "google_organization_iam_member" "cloudbuild_iam" {
  for_each = toset(var.cloudbuild_org_iam_permissions)
  org_id   = module.constants.values.org_id
  role     = each.value
  member   = "serviceAccount:${module.cloudbuild_bootstrap.project_number}@cloudbuild.gserviceaccount.com"
}


# -----------------------------
#   Cloud build triggers
# -----------------------------

resource "google_cloudbuild_trigger" "foundation_trigger" {
  for_each    = toset(var.cloud_triggers)
  provider    = google-beta
  project     = module.cloudbuild_bootstrap.project_id
  description = "${each.value} - created with terraform."
  disabled    = var.disable_trigger

  github {
    owner = var.github_owner
    name  = var.github_name
    push {
      branch = var.branch
    }
  }

  included_files = ["environment/foundation/${each.value}/**"]

  substitutions = {
    #_ORG_ID          = module.constants.values.org_id
    #_BILLING_ACCOUNT = module.constants.values.billing_account
    #_DEFAULT_REGION  = module.constants.values.default_region
    _BUCKET = google_storage_bucket.org_terraform_state.name
    _TAG    = var.terraform_tag
    _PREFIX = "cloudbuild-${each.value}"
  }
  filename = "${var.filename_path}/foundations/cloudbuild-${each.value}.yaml"
}

resource "google_cloudbuild_trigger" "cloudops_trigger" {
  for_each    = toset(var.cloudops_triggers)
  provider    = google-beta
  project     = module.cloudbuild_bootstrap.project_id
  description = "${each.value} - created with terraform."
  disabled    = var.disable_trigger

  included_files = ["environment/deployments/projects/**"]

  github {
    owner = var.github_owner
    name  = var.github_name
    push {
      branch = var.branch
    }
  }

  substitutions = {
    _BUCKET         = google_storage_bucket.org_terraform_state.name
    _TAG            = var.terraform_tag
    _DEPLOYMENT_DIR = var.deployment_dir
    _MODULES_DIR    = var.modules_dir
    _TFVARS_NAME    = var.tfvars_name
  }
  filename = "${var.filename_path}/operations/${each.value}.yaml"
}