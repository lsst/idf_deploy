github_owner = "Burwood"

github_name = "terraform-gcp-greenfield"

branch = "^gcp-onboarding-rubin$"

project_labels = {
    envrionment  = "prod"
    owner        = "its"
    billing_code = "012345"
}

seed_folder_name = "Rubin-Shared-Services"

cloudbuild_org_iam_permissions = [
    "roles/resourcemanager.organizationAdmin",
    "roles/billing.admin",
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

//Optional - for development.  Will place all resources under a specific folder instead of org root
//parent_folder = "01234567890"