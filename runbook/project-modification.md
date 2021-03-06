# Overview

This example demonstrates how to modify projects by adding new modules and how to  make smaller modifications, such as updating project budgets. 

**Adding a New Module**

* Navigate to the [terraform deployments directory](../environment/deployments).

* Open either qserv or science platform. Then go into env directory.

* Modify the .tfvars file for production, intergration or dev with the new module from the [modules directory](../modules). 

For example, to add a GCS Bucket use the bucket module:
```diff
+ module "storage_bucket" {
+    source     = "./"
+    project_id = "rubin-shared-services-71ec"
+    names      = ["first","second"]
+    prefix     = "a-unique-suffix"
+    versioning = {
+        first  = true
+        second = false
+    }
+    force_destroy = {
+        first  = true
+        second = false
+    }
+    labels = {
+        environment = "test"
+        application = "shared_services"
+    }
+}
```


* Perform a pull request to a new branch to edit the project tfvars file. 

* Commit and push the changes onto the main branch. 

* Save and check in the file to GitHub. An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change.

* Navigate to the Actions to watch that status.Once the GitHub Action worklow runs successfully approve the pull request. The same GitHub Action will now run with terraform apply.

<br>

**Changing Project Budget Amount**

* Navigate to the [terraform deployments directory](../environment/deployments).

* Open either qserv or science platform. Then go into env directory.

* Modify the .tfvars file for production, intergration or dev.

For example, the budget was previously set to 1000 and now it will be modified to 5000.

```diff
- budget_amount = 1000
+ budget_amount = 5000
```
* Perform a pull request to a new branch to edit the project tfvars file. 

* Commit and push the changes onto the main branch. 

* Save and check in the file to GitHub. An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change.

* Navigate to the Actions to watch that status.Once the GitHub Action worklow runs successfully approve the pull request. The same GitHub Action will now run with terraform apply.