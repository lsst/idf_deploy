# GKE Node Pools Terraform


## Increasing or Decreasing Node Counts
Below are instructions for increasing or decreasing the GKE node count.  The GKE node count in dev or integration clusters can be reduced when not used to reduce costs.

* Navigate to the [terraform deployments directory](../environment/deployments)
* Open either qserv or science platform. Then go into env directory.
* Modify the tfvars file.  The naming syntax is `<env>-<gke>.tfvars`.  For development clusters open dev-gke.tfvars.  For integration open int-gke.tfvars.
* Perform a pull request to a new branch to edit the gke tfvars file
* Edit the node count value for each node pool you want to increase or decrease. To turn down node pool completely enter 0 for node count.  Snippet below.

```
node_pools = [
  {
    .....
    node_count         = 0
  }
```
* Save and check in the file to GitHub.  An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change. The GitHub Actions for GKE end with GKE.  Example is QServ DEV GKE. Navigate to the [Actions](https://github.com/lsst/idf_deploy/actions) to watch that status.
* Once the GitHub Action worklow runs successfully approve the pull request.  The same GitHub Action will now run with terraform apply.

##  Adding Node Pools

This is an example of how to modify existing node pools by adding additonal node pools. 

**Steps**

* Navigate to the [terraform deployments directory](../environment/deployments)

* Update the `.tfvars` file for GKE. For development clusters open dev-gke.tfvars.  For integration open int-gke.tfvars. 

In the below example, the czar-pool and worker-pool already existed and now a new pool, utility-pool is being added. 
```diff
-   node_pools = [
- {
-    name               = "czar-pool"
-    machine_type       = "n2-standard-32"
-    node_locations     = "us-central1-c"
-    local_ssd_count    = 0
-    auto_repair        = true
-    auto_upgrade       = true
-    preemptible        = false
-    image_type         = "cos_containerd"
-    enable_secure_boot = true
-    disk_size_gb       = "200"
-    disk_type          = "pd-ssd"
-    autoscaling        = "false"
-    node_count         = 1
-  },
-  {
-    name               = "worker-pool"
-    machine_type       = "n2-standard-16"
-    node_locations     = "us-central1-c"
-    local_ssd_count    = 0
-    auto_repair        = true
-   auto_upgrade       = true
-    preemptible        = false
-    image_type         = "cos_containerd"
-    enable_secure_boot = true
-    disk_size_gb       = "200"
-    disk_type          = "pd-standard"
-    autoscaling        = "false"
--    node_count         = 5
-  }
+   {
+    name               = "utility-pool"
+    machine_type       = "n1-standard-4"
+    node_locations     = "us-central1-c"
+    local_ssd_count    = 0
+    auto_repair        = true
+    auto_upgrade       = true
+    preemptible        = false
+    image_type         = "cos_containerd"
+    enable_secure_boot = true
+    disk_size_gb       = "100"
+    disk_type          = "pd-standard"
+    autoscaling        = "false"
+    node_count         = 1
+  }
```
* Commit and push the changes onto the main branch. 

* Merge the pull request.

* Save and check in the file to GitHub. An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change. The GitHub Actions for GKE end with GKE. 
  * Example is QServ DEV GKE. 

* Navigate to the Actions to watch that status.Once the GitHub Action worklow runs s uccessfully approve the pull request. The same GitHub Action will now run with terraform apply.