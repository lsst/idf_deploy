# Terraform GCP Foundation and Deployment

This code repo is intended to deploy a solid Google Cloud Platform foundation based off of [Google's Cloud security foundation guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf). This guide provides our opinionated security foundations blueprint and captures a step-by-step view of how to configure and deploy your Google Cloud estate. This document can provide a good reference and starting point because we highlight key topics to consider. In each topic, we provide background and discussion of why we made each of our choices.

## Where to Begin

To start, you will need to go into the [foundation](./environment/foundation) directory. This directoy is the building block to deploying a solid and secure GCP foundation. The foundation directory has it's own [readme](./environment/foundation/readme.md) with steps.

## Where to Continue

After all the steps have been completed from the [foundation](./environment/foundation) directory, next is day-to-day operations. Most of the time, deployments are decentralized meaning a project is created and handed over to a PI or researcher to be used for their initiatives. Terraform may never be used again to manage the project, but is used for consistency and repeatability.

To build new projects with new infrastructure, these should be built under the [modules](./modules) directory. To seperate out different inputs or to have different environments these will go under the [deployments](./environment/deployments/projects) directory. Additional folders under deployments can be used if desired.

### Repo Structure

#### [cloudbuild](./cloudbuild)
The [cloudbuild](./cloudbuild) directory contains the Cloud Build steps used when a Cloud Build trigger is initiated.

#### [custom-image](./custom-image)
The [custom-image](./custom-image) directory contains the steps to create a custom container for Cloud Build. A custom container at times may be needed when code from a container needs to access `gcloud` commands and `terraform`.

#### [deployments under environment](./environment/deployments/projects)
The [deployments](./environment/deployments/projects) directory is used for the `*.tfvars` files. These files help differentiate between projects and supply the inputs for the different modules.

#### [modules](./modules)
The [modules](./modules) directory is where the blueprints of the infrastructure are stored.
