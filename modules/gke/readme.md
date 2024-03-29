# Terraform Google Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.

This module illustrates how to create a simple private cluster.

##

## Usage
Simple example using the defaults and only the required inputs in the module.
```terraform
module "gke" {
    source  =  "./modules/gke"
    project_id = "my-exmaple-123"
    network = "default"
    subnetwork = "subnet-01"
    node_pools = [
    {
        name               = "core-pool"
        machine_type       = "n1-standard-4"
        node_locations     = "us-central1-b,us-central1-c"
        min_count          = 1
        max_count          = 15
        local_ssd_count    = 0
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
        image_type         = "cos_containerd"
        enable_secure_boot = true
        disk_size_gb       = "200"
        disk_type          = "pd-ssd"
        autoscaling        = "false"
        node_count         = 3
    },
    ]
}
```

>Note: if you deploy in multiplie zones, it will take the number of zones in `node_locations` * the `node_count` value. The example would produce 6 nodes if deployed.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authenticator\_security\_group | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `"lsst.cloud"` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | <pre>{<br>  "environment": "environment",<br>  "owner": "owner_here"<br>}</pre> | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | `bool` | `true` | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `110` | no |
| enable\_intranode\_visibility | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `true` | no |
| enable\_private\_nodes | n/a | `bool` | `true` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | `bool` | `false` | no |
| enable\_shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster. | `bool` | `true` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon | `bool` | `true` | no |
| ip\_range\_pods | The VPC network to host the cluster in (required) | `string` | `"kubernetes-pods"` | no |
| ip\_range\_services | The name of the secondary subnet range to use for services | `string` | `"kubernetes-services"` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window start for maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| maintenance\_end\_time | Time window end for maintenance operations in RFC3339 format | `string` | `"09:00"` | no |
| maintenance\_recurrence | RFC 5545 RRULE for when maintenance windows occur | `string` | `"FREQ=DAILY"` | no |
| master\_ipv4\_cidr\_block | n/a | `string` | `"172.16.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | A prefix to the default cluster name | `string` | `"simple"` | no |
| network | The VPC network to host the cluster in (required) | `string` | n/a | yes |
| network\_policy | Enable network policy addon | `bool` | `true` | no |
| node\_pools | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "auto_repair": true,<br>    "auto_upgrade": true,<br>    
"disk_size_gb": "100",<br>    "disk_type": "pd-standard",<br>    "enable_secure_boot": true,<br>    "image_type": "cos_containerd",<br>    "initial_node_count": 5,<br>    "local_ssd_count": 0,<br>    "machine_type": "g1-small",<br>    "max_count": 15,<br>    "min_count": 1,<br>    "name": "core-pool",<br>    "node_locations": "us-central1-b",<br>    "preemptible": false<br>  }<br>]</pre> | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name. | `map(map(string))` | <pre>{<br>  "all": {<br>    "environment": "environment_here",<br>    "owner": "owner_here"<br>  }<br>}</pre> | no |
| project\_id | The project ID to host the cluster in (required) | `string` | n/a | yes |
| region | Region to deploy cluster | `string` | `"us-central1"` | no |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` 
| no |
| release\_channel | The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`. 
| `string` | `"STABLE"` | no |
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

## Private Cluster Requirements, restrictions and limitations

Implementing a private cluster has technical requirements, restrictions and limitations. These are outline in [this link](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#req_res_lim)

* One to be aware of is do not overlap with the range `172.17.0.0/16` as this is an IP range Google uses.
