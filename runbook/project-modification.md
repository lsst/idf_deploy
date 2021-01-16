# Overview

This example demonstartes how to modify projects by addings new modules and how to  make smaller modifications, such as updating budgeting. 

**Adding a New Module**

Step 1 - Navigate to the [terraform deployments directory](../environment/deployments).

Step 2 - Open either qserv or science platform. Then go into env directory.

Step 3 - Modify the .tfvars file for production, intergration or dev with the new module from the [modules directory](../modules). 

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


Step 4 - Perform a pull request to a new branch to edit the project tfvars file. 

Step 5 - Commit and push the changes onto the main branch. 

Step 6 - Save and check in the file to GitHub. An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change.

Step 7 - Navigate to the Actions to watch that status.Once the GitHub Action worklow runs successfully approve the pull request. The same GitHub Action will now run with terraform apply.

**Changing Project Budget Amount**
