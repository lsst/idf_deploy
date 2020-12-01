# Project-IAM-VPC Simple Project

This example illustrates how to use the `project_iam_vpc` module to create simple, isolate GCP projects with an attached billing account, assigned Google Group, with a single custom VPC deployment.

## Requirements

| Name | Version |      
|------|---------|      
| google | ~> 3.1 |     
| google-beta | ~> 3.1 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_name | The name of application where GCP resources relate | `string` | n/a | yes |
| billing\_account | The ID of the billing account to associated this project with | `string` | n/a | yes |
| cost\_centre | The cost centre that links to the application | `string` | n/a | yes |
| environment | The environment the single project belongs to | `string` | n/a | yes |
| folder\_id | The folder id where project will be created | `string` | n/a | yes |
| group\_name | Name of the Google Group to assign to the project. | `string` | n/a | yes |
| org\_id | The organization id for the associated services | `string` | n/a | yes |
| project\_prefix | The name of the GCP project | `string` | n/a | yes |

## Outputs

No output.