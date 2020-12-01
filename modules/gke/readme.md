# Terraform Google Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.

This module illustrates how to create a simple private cluster.

## Usage
Simple example using the defaults and only the required inputs in the module.
```terraform
module "gke" {
    source  =  "./modules/gke"
    project_id = "my-exmaple-123"
    network = "default"
    subnetwork = "subnet-01"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authenticator\_security\_group | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `"lsst.cloud"` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | <pre>{<br>  "environment": "environment",<br>  "owner": "owner_here"<br>}</pre> | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | `bool` | `true` | no |
| enable\_intranode\_visibility | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `true` | no |
| enable\_private\_nodes | n/a | `bool` | `true` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | `bool` | `false` | no |
| enable\_shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster. | `bool` | `true` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon | `bool` | `true` | no |
| ip\_range\_pods | The VPC network to host the cluster in (required) | `string` | `"kubernetes-pods"` | no |
| ip\_range\_services | The name of the secondary subnet range to use for services | `string` | `"kubernetes-services"` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_ipv4\_cidr\_block | n/a | `string` | `"172.16.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | A prefix to the default cluster name | `string` | `"simple"` | no |
| network | The VPC network to host the cluster in (required) | `string` | n/a | yes |
| network\_policy | Enable network policy addon | `bool` | `true` | no |
| node\_pool\_1\_auto\_repair | n/a | `bool` | `true` | no |
| node\_pool\_1\_auto\_upgrade | n/a | `bool` | `true` | no |
| node\_pool\_1\_disk\_size\_gb | n/a | `number` | `100` | no |
| node\_pool\_1\_disk\_type | n/a | `string` | `"pd-standard"` | no |
| node\_pool\_1\_image\_type | n/a | `string` | `"COS"` | no |
| node\_pool\_1\_initial\_node\_count | n/a | `number` | `1` | no |
| node\_pool\_1\_local\_ssd\_count | n/a | `number` | `0` | no |
| node\_pool\_1\_machine\_type | n/a | `string` | `"g1-small"` | no |
| node\_pool\_1\_max\_count | n/a | `number` | `15` | no |
| node\_pool\_1\_min\_count | n/a | `number` | `1` | no |
| node\_pool\_1\_name | n/a | `string` | `"core-pool"` | no |
| node\_pool\_1\_oauth\_scope | n/a | `string` | `"https://www.googleapis.com/auth/cloud-platform"` | no |
| node\_pool\_1\_preemptible | n/a | `bool` | `false` | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {<br>    "environment": "environment_here",<br>    "owner": "owner_here"<br>  }<br>}</pre> | no |
| project\_id | The project ID to host the cluster in (required) | `string` | n/a | yes |
| region | Region to deploy cluster | `string` | `"us-central1"` | no |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |   
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | `bool` | `true` | no |
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `true` | no |
| subnetwork | The subnetwork to host the cluster in (required) | `string` | n/a | yes |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | `list(string)` | <pre>[<br>  "us-central1-a"<br>]</pre> | no |    

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| kubernetes\_endpoint | n/a |
| location | Cluster location (region if regional cluster zone if zonal cluster) |
| master\_version | Current master kubernetes version |
| name | Cluster name |
| region | Cluster region |
| service\_account | The default service account used for running nodes. |
| zones | List of zones in which the cluster resides |