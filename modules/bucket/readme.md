# Terraform Module for GCS Buckets

This module makes it easy to create one or more GCS buckets, and assign basic permissions on them to arbitrary users.

The resources/services/activations/deletions that this module will create/trigger are:

* One or more GCS buckets
* Zero or more IAM bindings for those buckets

## Usage

Basic usage of this module is as follows:

```terraform
module "storage_bucket" {
  source      = "../../modules/bucket"
  project_id  = "rubin-shared-services-71ec"
  suffix_name = ["first", "second"]
  prefix_name = "a-unique-suffix"
  versioning = {
    first  = true
    second = false
  }
  force_destroy = {
    first  = true
    second = true
  }
  labels = {
    environment = "test"
    application = "shared_services"
  }
}
```

## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admins | IAM-style members who will be granted role/storage.objectAdmins for all buckets. | `list(string)` | `[]` | no |
| bucket\_admins | Map of lowercase unprefixed name => comma-delimited IAM-style bucket admins. | `map` | `{}` | no |
| bucket\_creators | Map of lowercase unprefixed name => comma-delimited IAM-style bucket creators. | `map` | `{}` | no |
| bucket\_viewers | Map of lowercase unprefixed name => comma-delimited IAM-style bucket viewers. | `map` | `{}` | no |
| creators | IAM-style members who will be granted roles/storage.objectCreators on all buckets. | `list(string)` | `[]` | no |
| encryption\_key\_names | Optional map of lowercase unprefixed name => string, empty strings are ignored. | `map` | `{}` | no |
| folders | Map of lowercase unprefixed name => list of top level folder objects. | `map` | `{}` | no |
| force\_destroy | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map` | `{}` | no |
| labels | Labels to be attached to the buckets | `map` | `{}` | no |
| location | Bucket location. | `string` | `"US"` | no |
| prefix\_name | The prefix/beginning used to generate the bucket. | `string` | `"unique-suffix"` | no |
| project\_id | Bucket project id | `string` | n/a | yes |
| set\_admin\_roles | Grant roles/storage.objectAdmin role to admins and bucket\_admins. | `bool` | `false` | no |
| set\_creator\_roles | Grant roles/storage.objectCreator role to creators and bucket\_creators. | `bool` | `false` | no |
| set\_viewer\_roles | Grant roles/storage.objectViewer role to viewers and bucket\_viewers. | `bool` | `false` | no |
| storage\_class | Bucket storage class. Supported values include: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE. | `string` | `"MULTI_REGIONAL"` | no |
| suffix\_name | The suffix/ending name for the bucket. | `list(string)` | `[]` | no |
| versioning | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map` | `{}` | no |
| viewers | IAM-style members who will be granted roles/storage.objectViewer on all buckets. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket | Bucket resource (for single use). |
| buckets | Bucket resources as list. |
| name | Bucket name (for single use). |
| names\_list | List of bucket names. |
| url | Bucket URL (for single use). |
| urls\_list | List of bucket URLs. |