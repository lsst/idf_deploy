# Compute Dashboards

Full metrics for compute [here](https://cloud.google.com/monitoring/api/metrics_gcp#gcp-compute)

Note that for memory usage, disk swap, and application level montiroing the Monitoring Agent needs to be installed.

| GCE VM Instance Monitoring |
|:-------------------------- |
|Filename: [gce-vm-instance-monitoring.json](gce-vm-instance-monitoring.json)|
|Dashboards for CPU utilization, uptime, disk read and write by packets and bytes, received and sent packets by packets and bytes|

| Autoscaler Monitoring |
|:-------------------------- |
|Filename: [autoscaler-monitoring.json](autoscaler-monitoring.json)|
|Dashboards for Autoscaler utilization and capacity|

| Windows Server |
|:-------------------------- |
|Filename: [windows-server-monitoring.json](windows-server-monitoring.json)|
|Dashboards for IIS Connection Monitoring, SQL Server Connections and transactions, Pagefile utilization, and VM Disk, Memory, and CPU utilization|

| Active Directory |
|:-------------------------- |
|Filename: [active-directory-monitoring.json](active-directory-monitoring.json)|
|Dashboards obtained from metrics from Blue Medora for Active Directory health and connections|
