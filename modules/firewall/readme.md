# Terraform Google Cloud VPC Firewall

This module allows creation of a minimal VPC firewall.

## Usage
Simple example using the defaults and only the required inputs in the module.
```terraform
module "net-firewall" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = "my-project"
  network                 = "my-vpc"
  internal_ranges_enabled = true
  internal_ranges         = ["10.0.0.0/0"]
  internal_target_tags    = ["internal"]
  custom_rules = {
    ingress-sample = {
      description          = "Dummy sample ingress rule, tag-based."
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["192.168.0.0"]
      sources              = ["spam-tag"]
      targets              = ["foo-tag", "egg-tag"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = []
        }
      ]
      extra_attributes = {}
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_rules | List of custom rule definitions (refer to variables file for syntax). | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string # (allow|deny)<br>    ranges               = list(string)<br>    sources              = list(string)<br>    targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br>  }))</pre> | `{}` | no |
| network | Name of the network this set of firewall rules applies to. | `string` | `"default"` | no |
| project\_id | Project id of the project that holds the network. | `any` | n/a | yes |

## Outputs

No output.