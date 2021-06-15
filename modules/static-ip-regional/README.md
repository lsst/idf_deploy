# Terraform Module to create a regioanl static ip address

This module will create a reserved external IP address that's a regional resource.

## Usage

Here's a simple example to create the resource

```terraform
module "create_static_ip" {
    source = "./"

    project_id  = "my-project-id"
    static_name = "my-resource-name"
    region      = "us-central1
    labels      = {
        "environment" = "dev"
        "owner"       = "example_owner"
    }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.static](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | The type of address to reserve. Default value is `EXTERNAL`. Possible values are `INTERNAL` and `EXTERNAL`. | `string` | `"EXTERNAL"` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. | `string` | `"Created by Terraform."` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to this address. | `map(string)` | `{}` | no |
| <a name="input_network_tier"></a> [network\_tier](#input\_network\_tier) | The networking tier used for configuring this address.Possible values are `PREMIUM` and `STANDARD`. | `string` | `"PREMIUM"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The Region in which the created address should reside. | `string` | `"us-central1"` | no |
| <a name="input_static_name"></a> [static\_name](#input\_static\_name) | The name of the resource | `string` | `"ipv4-external-address"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_static_address"></a> [static\_address](#output\_static\_address) | The static external IP address of the resource |
| <a name="output_static_self_link"></a> [static\_self\_link](#output\_static\_self\_link) | The URI of the created resource. |