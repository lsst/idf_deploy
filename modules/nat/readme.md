# Terraform Cloud Router Module

This module handles opinionated Google Cloud Platform routing.

## Usage

Simple example using the defaults and only the required inputs in the module.
```terraform
module "router" {
    source  =  "./modules/nat"
    project = "<PROJECT ID>"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the router | `string` | `"example-router"` | no |
| nats | NATs to deploy on this router. | `any` | `[]` | no |
| network | A reference to the network to which this router belongs | `string` | `"default"` | no |
| project | The project ID to deploy to | `string` | n/a | yes |
| region | Region where the router resides | `string` | `"us-central1"` | no |        

## Outputs

| Name | Description |
|------|-------------|
| router | The created router |
| router\_region | The region of the created router |