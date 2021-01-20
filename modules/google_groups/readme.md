# Terraform Google Groups

This module manages Cloud Identity Groups and Memberships using Cloud Identity Group API.

There is a base folder located under `environment\foundation\google_groups` where new modules for new groups can be appended with a subdirectory (`.\env`) with a `tfvars` file. There is a GitHub Action pipeline created to monitor for changes to this `tfvars` file.

## Usage
The example below shows a basic usage of this module.
* Append the new group to in `main.tf`
* Append the new input variables to the `variables.tf`
* Append the new values to the `tfvars` file

```terraform
module "foo_group" {
  source  = "../../../modules/google_groups"
  
  id           = var.foo_id
  display_name = var.foo_display_name
  description  = var.foo_description
  domain       = var.foo_domain
  owners       = var.foo_owners
  managers     = var.foo_managers
  members      = var.foo_members
}
// Additional Google Groups
module "bar_group" {
    <...>
}
```
After a new module has been appended, those new input variables need to be declared in the `variables.tf` file.
```terraform
variable "foo_id" {}
variable "foo_display_name" {}
variable "foo_description" {}
variable "foo_domain" {}
variable "foo_owners" {}
variable "foo_managers" {}
variable "foo_members" {}
```
After the new input variables has been appended, a new set of distint values must be added to the `tfvars` under the subdirectory of `.\env`. These new values will trigger our CI pipeline.
```tfvars
foo_id           = "example-group@example.com"
foo_display_name = "example-group"
foo_description  = "Example Group"
foo_domain       = "example.com"
foo_owners       = ["owner@example.com"]
foo_managers     = ["manager@example.com"]
foo_members      = ["user1@example.com","user2@example.com"]
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| customer\_id | Customer ID of the organization to create the group in. One of domain or customer\_id must be specified | `string` | `""` | no |
| description | Description of the group | `string` | `""` | no |
| display\_name | Display name of the group | `string` | `""` | no |
| domain | Domain of the organization to create the group in. One of domain or customer\_id must be specified | `string` | `""` | no |
| id | ID of the group. For Google-managed entities, the ID must be the email address the group | `any` | n/a | yes |
| managers | Managers of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | `list` | `[]` | no |
| members | Members of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | `list` | `[]` | no |
| owners | Owners of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the group. For Google-managed entities, the ID is the email address the group |
| resource\_name | Resource name of the group in the format: groups/{group\_id}, where group\_id is the unique ID assigned to the group. |

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

* [Terraform][terraform] v0.12
* [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Permissions

A service account or user account needs the following roles to provision the
resources of this module:

#### Google Cloud IAM roles

* Service Usage Consumer: `roles/serviceusage.serviceUsageConsumer` on the
    billing project
* Organization Viewer: `roles/resourcemanager.organizationViewer` if using
    `domain` instead of `customer_id`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a service
account with the necessary roles applied.

#### Google Workspace (formerly known as G Suite) roles

* [Group Admin role](https://support.google.com/a/answer/2405986?hl=en)

To make the service account a Group Admin, you must have Google Workspace Super
Admin access for your domain. Follow
[Assigning an admin role to the service account](https://cloud.google.com/identity/docs/how-to/setup#assigning_an_admin_role_to_the_service_account)
for instructions.

To create groups as an end user, the caller is required to authenticate as a
member of the domain, i.e. you cannot use this module to create a group under
`bar.com` with a `foo.com` user identity.

After the groups have been created, the organization’s Super Admin, Group Admin
or any custom role with Groups privilege can always modify and delete the groups
and their memberships. In addition, the group’s OWNER and MANAGER can edit
membership, and OWNER can delete the group. Documentation around the three group
default roles (OWNER, MANAGER and MEMBER) can be found
[here](https://support.google.com/a/answer/167094?hl=en).

### APIs

A project with the following APIs enabled must be used to host the resources of
this module:

* Cloud Identity API: `cloudidentity.googleapis.com`

The [Project Factory module][project-factory-module] can be used to provision a
project with the necessary APIs enabled.

To use the Cloud Identity Groups API, you must have Google Groups for Business
enabled for your domain and allow end users to create groups.