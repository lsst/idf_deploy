# Terraform Module for Cloud SQL Public - PostgreSQL
CloudSQL provides disk autoresize feature which can cause a Terraform configuration drift due to the value in disk_size variable, and hence any updates to this variable is ignored in the Terraform lifecycle.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorized\_networks | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | <pre>[<br>  {<br>    "name": "sample-gcp-health-checkers-range",<br>    "value": "130.211.0.0/28"<br>  }<br>]</pre> | no |
| backup\_configuration | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    binary_log_enabled = bool<br>    enabled            = bool<br>    start_time         = string<br>    location           = string<br>  })</pre> | <pre>{<br>  "binary_log_enabled": false,<br>  "enabled": false,<br>  "location": null,<br>  "start_time": null<br>}</pre> | no |
| database\_flags | List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | value | `string` | `"MYSQL_5_6"` | no |
| db\_name | The name of the SQL Database instance | `string` | `"example-mysql-public"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| disk\_autoresize | Configuration to increase storage size | `bool` | `true` | no |
| disk\_size | The disk size for the master instance | `number` | `10` | no |
| disk\_type | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| pricing\_plan | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| project\_id | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `true` | no |
| region | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| tier | The tier for the master instance. | `string` | `"db-n1-standard-1"` | no |
| user\_host | The host for the default user | `string` | `"%"` | no |
| user\_labels | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| mysql\_conn | The connection name of the master instance to be used in connection strings |
| mysql\_user\_pass | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. |
| name | The name for Cloud SQL instance |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| project\_id | The project to run tests against |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |


