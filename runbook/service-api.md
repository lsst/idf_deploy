# GCP Service API
Information on how interact and manage GCP APIs.  GCP Services are controlled by enabling or disabling APIs.  To view APIs enabled on a project `gcloud services list`

To view available GCP APIs enter `gcloud services list --available`  This provides a list of available APIs. Snippet below.
NAME                                                               TITLE
abusiveexperiencereport.googleapis.com                             Abusive Experience Report API
acceleratedmobilepageurl.googleapis.com                            Accelerated Mobile Pages (AMP) URL API
accessapproval.googleapis.com                                      Access Approval API
accesscontextmanager.googleapis.com                                Access Context Manager API
actions.googleapis.com                                             Actions API

## Service Management Terraform

GCP Service APIs are managed by Terraform.  Using the default variables in Terraform a list of APIs is enabled for each application (Science Platform, QServ, Pandas) and associated environments.  This is set as default to keep the APIs consistent between development, integration, and production environments.

### Change Default Service APIs for all Application Environments

To change the defaults perform the following.

* In this repository navigate to the [environment deployments directory](../environment/deployments)
* Navigate to the environment folder.  Example science-platform, qserv, pandas, etc..
* Navigate to env folder.  Create a branch and perform a pull request to modify the variables.tf file.  Add in the API to the list.  Make sure a comma is added between APIs.  The `gcloud services list --available` command can be used to determine API name.

```
variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}
```
* Submit pull request so that terraform plan will run to validate the changes.  In the GitHub Actions worklow the new APis will be listed to be created under the Terraform Plan step.

![Pull request](./images/pull-req-api.PNG)

```
# module.project_factory.module.project.module.project-factory.module.project_services.google_project_service.project_services["artifactregistry.googleapis.com"] will be created
  + resource "google_project_service" "project_services" ***
      + disable_dependent_services = true
      + disable_on_destroy         = true
      + id                         = (known after apply)
      + project                    = "science-platform-dev-7696"
      + service                    = "artifactregistry.googleapis.com"
    ***

  # module.project_factory.module.project.module.project-factory.module.project_services.google_project_service.project_services["sql-component.googleapis.com"] will be created
  + resource "google_project_service" "project_services" ***
      + disable_dependent_services = true
      + disable_on_destroy         = true
      + id                         = (known after apply)
      + project                    = "science-platform-dev-7696"
      + service                    = "sql-component.googleapis.com"
    ***
```
* Approve pull request if plan successful and API will be enabled.

### Change Service APIs for a Specific Application Environments Only

For when testing or experimentation with a GCP service a variable can be added to the Terraform tfvars file for the environment.  Setting the variable in tfvars will override the default variable setting describe in the previous section. This approach is for when you do not want to also add an API to production at the same time.  Please note if you standardize on the API later refer to previous section to add to default API variable.

To change the defaults perform the following.

* In this repository navigate to the [environment deployments directory](../environment/deployments)
* Navigate to the environment folder.  Example science-platform, qserv, pandas, etc..
* Navigate to env folder.  Open variables.tf and copy the list of APIs. Example below.

```
variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}
```
* Create a branch and perform pull request to modify the dev.tfvars file (or int or production tfvar depending on environment). Create the `activate_apis` variable and add in the API to the list.  Make sure comma is added between APIs.  The `gcloud services list --available` command can be used to determine API name.  Example below.

```
activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com",
    "artifactregistry.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com"
  ]
```
* Submit pull request so that terraform plan will run to validate the changes.  In the GitHub Actions workflow the new APis will be listed to be created under the Terraform Plan step.

![Pull request](./images/pull-req-api.PNG)

```
# module.project_factory.module.project.module.project-factory.module.project_services.google_project_service.project_services["artifactregistry.googleapis.com"] will be created
  + resource "google_project_service" "project_services" ***
      + disable_dependent_services = true
      + disable_on_destroy         = true
      + id                         = (known after apply)
      + project                    = "science-platform-dev-7696"
      + service                    = "artifactregistry.googleapis.com"
    ***

  # module.project_factory.module.project.module.project-factory.module.project_services.google_project_service.project_services["sql-component.googleapis.com"] will be created
  + resource "google_project_service" "project_services" ***
      + disable_dependent_services = true
      + disable_on_destroy         = true
      + id                         = (known after apply)
      + project                    = "science-platform-dev-7696"
      + service                    = "sql-component.googleapis.com"
    ***
```
* Approve pull request if plan successful and API will be enabled.