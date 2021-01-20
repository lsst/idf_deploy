# Terraform Module for Identity-Aware Proxy (IAP) Tunneling

This module will create firewall rules and IAM bindings to allow TCP forwarding using Identity-Aware Proxy (IAP) Tunneling.

This module will:

* Create firewall rules to allow connections from IAP's TCP forwarding IP addresses to the TCP port of your resource's admin service.
* Create IAM bindings to allow IAP from specified members.

## Usage
Basic usage of this module is as follows:
```terraform
module "iap_tunneling" {
    source = "./"

    project = "rubin-shared-services-71ec"
    network = "https://www.googleapis.com/compute/v1/projects/rubin-shared-services-71ec/global/networks/shared-vpc-prod"

    instances = [{
        name = "instance-simple-001"
        zone = "us-central1"
    }]

    members = [
        "group:gcp-admins@lsst.cloud",
        "user:me@lsst.cloud",
    ]
}
```

This module ties in very nicely with the [compute instance](../compute/readme.md) resource. Below is an example using the default values for both modules. This will deploy a single VM instance and enable Identity Aware-Proxy.

```terraform
module "compute" {
    source     = "../compute"
    project_id = "rubin-shared-services-71ec"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/rubin-shared-services-71ec/regions/us-central1/subnetworks/us-central1-prod-0"

}

module "iap_tunneling" {
    source = "./"

    project = "rubin-shared-services-71ec"
    network = "https://www.googleapis.com/compute/v1/projects/rubin-shared-services-71ec/global/networks/shared-vpc-prod"

    instances = [{
        name = module.compute.self_link
        zone = "us-central1-a"
    }]

    members = [
        "group:gcp-admins@lsst.cloud",
        "user:me@lsst.cloud",
    ]
}
```

## Example
Working example
```terraform
data "google_compute_network" "my-network" {
    name = "shared-vpc-prod"
    project = var.project_id
}

data "google_compute_subnetwork" "my-subnetwork" {
  name   = "us-central1-prod-0"
  region = "us-central1"
  project = var.project_id
}

module "iap_tunnel" {
    source = "../../modules/iap"

    project = var.project_id
    network = data.google_compute_network.my-network.self_link
    members = ["user:astrong@lsst.cloud"]
    instances = [{
        name = "instance-simple-001"
        zone = "us-central1-a"
    }]

    depends_on = [ module.vm ]
}

module "vm" {
    source = "../../modules/compute"
    project_id = var.project_id
    subnetwork = data.google_compute_subnetwork.my-subnetwork.self_link
}

variable "project_id" {
    default = "rubin-shared-services-71ec"  
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_ports | A list of additional ports/ranges to open access to on the instances from IAP. | `list(string)` | `[]` | no |
| fw\_name\_allow\_ssh\_from\_iap | Firewall rule name for allowing SSH from IAP. | `string` | `"allow-ssh-from-iap-to-tunnel"` | no |
| host\_project | The network host project ID. | `string` | `""` | no |
| instances | Names and zones of the instances to allow SSH from IAP. | <pre>list(object({<br>    name = string<br>    zone = string<br>  }))</pre> | n/a | yes |
| members | List of IAM resources to allow using the IAP tunnel. | `list(string)` | n/a | yes |
| network | Self link of the network to attach the firewall to. | `any` | n/a | yes |
| network\_tags | Network tags associated with the instances to allow SSH from IAP. Exactly one of service\_accounts or network\_tags should be specified. | `list(string)` | `[]` | no |
| project | The project ID to deploy to. | `any` | n/a | yes |
| service\_accounts | Service account emails associated with the instances to allow SSH from IAP. Exactly one of service\_accounts or network\_tags should be specified. | `list(string)` | `[]` | no |

## Outputs

No output.