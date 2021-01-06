# Foundations

The foundations logic is located in the [environment/foundation](../environment/foundation) directory. Anything in this directory is used to help manage and govern the GCP platform. Services like org level IAM permissions, folder structures, and shared services projects.



## Overview

The foundations contains serveral distinct Terraform projects each within their own directory that were deployed separately, but in sequence. Each of these Terraform projects are layered on top of each other, running in the following order. Each step has its own `tfstate` file to keep things separated and isolated. These `tfstate` files live in a bucket located in the `rubin-automation` project.

---

### [1-org](../environment/foundation/1-org)
The purpose of this step is to setup top level shared folders, monitoring & networking projects, org level logging and set baseline security settings through organizational policy.

### [1-org-b](../environment/foundation/1-org-b)
The purpose of this step is to setup any sub-level folders for environments like `dev`, `integration` and `stable` under each primary application that was deployed in the previous steps.

### [1-org-c](../environment/foundation/1-org-c)
These are the documented steps performed manually that could not be automated at the time of deployment.

### [2-network](../environment/foundation/2-networks)
The purpose of this step is to setup shared VPCs with default DNS, NAT, and baseline firewall rules.

---

## Update Foundations

Each one of these steps has its own `tfstate` but also its own pipeline. There are three pipelines, one for each step (except manual). The pipelines are set to monitor for any push and for any changes to the modules corresponding directory.

### Example of IAM Update
To add an additional role, like `roles/project.viewer`, to the `Org Admins` group must be done in the [1-org](../environment/foundation/1-org) directory. The IAM permissions are listed in the `variables.tf` file and this must be updated.
```diff
variable "org_admins_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/billing.user",
    "roles/resourcemanager.organizationAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
+   "roles/iam.organizationRoleAdmin",
+   "roles/project.Viewer
  ]
}
```


### Example of Folder Update
If you have a new environment and you need to create a new top-level folder plus subfolder for `dev`, `int` and `stable`. This must be done in two steps.

1. Update the `1-org` module because this holds all the top level folder modules.
2. Update the `1-org-b` moulde because this holds all the subfolder modules.

Step 1 - Update the `terraform.tvfars` file and commit your changes.
```diff
-   folder_names = ["QServ", "SQuaRE", "Science Platform", "Processing"]
+   folder_names = ["QServ", "SQuaRE", "Science Platform", "Processing", "PaNDA"]
```

Step 2 - Once `Step 1` completed successfully, update the `variables.tf`, `data.tf` and the `sub_folders.tf` files. Commit the changes.

variables.tf - Create a new variable with value.
```diff
variable "panda_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "PaNDA"
}
```

data.tf - Create a new data block to lookup the new folder name
```diff
data "google_active_folder" "panda_sub_folder" {
  parent       = local.parent
  display_name = var.panda_display_name
}
```

sub_folders.tf - Create  subfolders under the new folder
```diff
// Build Sub Folders for PaNDA
module "sub_folders_panda" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.panda_sub_folder.name
  names  = var.sub_folder_names
}
```