# -----------------------------
# PROJECT
# -----------------------------

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "automation"
}

variable "random_project_id" {
  description = "Adds a suffix of 4 random characters to the `project_id`"
  type        = string
  default     = true
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed"
  type        = string
  default     = true
}

variable "activate_apis" {
  description = "List of APIs to enable in the seed project"
  type        = list(string)
  default = ["cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "billingbudgets.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "cloudbuild.googleapis.com",
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "storage-api.googleapis.com",
    "container.googleapis.com"
  ]
}

variable "project_labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default = {
    envrionment  = "prod"
    owner        = "its"
    billing_code = "012345"
  }
}

variable "sa_enable_impersonation" {
  description = "Allow org_admins group to impersonate service account & enable APIs required."
  type        = bool
  default     = false
}

variable "skip_gcloud_download" {
  description = "Whether to skip downloading gcloud (assumes gcloud is already available outside the module)"
  type        = bool
  default     = true
}

# -----------------------------
# FOLDER
# -----------------------------

variable "seed_folder_name" {
  description = "Name of the folder that will contain the `Cloud Control Plane` projects."
  type        = string
  default     = "Administration"
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}


# -----------------------------
# IAM
# -----------------------------

variable "org_admins_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/billing.user",
    "roles/resourcemanager.organizationAdmin"
  ]
}

variable "cloudbuild_org_iam_permissions" {
  description = "List of permissions granted to the CloudBuild service account."
  type        = list(string)
  default = [
    "roles/resourcemanager.organizationAdmin",
    "roles/billing.user",
    "roles/pubsub.admin",
    "roles/iam.organizationRoleAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/compute.xpnAdmin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    "roles/logging.admin"
  ]
}

# -----------------------------
# BUCKET
# -----------------------------

variable "storage_bucket_labels" {
  description = "Labels to apply to the storage bucket."
  type        = map(string)
  default     = {}
}

# -----------------------------
# REPOS AND TRIGGERS
# -----------------------------

variable "github_owner" {
  description = "Owner of the repository."
  type        = string
}

variable "github_name" {
  description = "Name of the repository."
  type        = string
}

variable "branch" {
  description = "What branch to pull from"
  type        = string
  default     = "^master$"
}

variable "cloud_triggers" {
  description = "Name of triggers to deploy"
  type        = list(string)

  default = [
    "1-org",
    "1-org-b",
    "2-networks",
  ]
}

variable "disable_trigger" {
  description = "To enable or disable the trigger for automatic deployment"
  type        = string
  default     = false
}

variable "terraform_tag" {
  description = "Dockerhub tag value for Terraform container"
  default     = "latest"
}

variable "filename_path" {
  description = "The file path name of where the cloudbuild yaml files are located"
  default     = "cloudbuild"
}

variable "deployment_dir" {
  description = "The directory that has the deployments / tfvars"
  type        = string
  default     = "projects"
}

variable "modules_dir" {
  description = "The directory that has the modules to deploy"
  type        = string
  default     = "project_iam_vpc"
}

variable "cloudops_triggers" {
  description = "Name of triggers to deploy"
  type        = list(string)

  default = [
    "project-apply",
  ]
}

variable "tfvars_name" {
  description = "Name of the tfvars file"
  type        = string
  default     = "new-project"
}
