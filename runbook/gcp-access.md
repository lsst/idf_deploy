# GCP Access
Below is information on accessing GCP instances and GKE remotely.

## IAP

## kubectl

To connect to a GKE cluster with kubectl run `gcloud container clusters get-credentials <cluster-name> --region us-central1 --project <project-id>`.  Replace cluster-name and project-id.

If you are not authenticated to gcp run `gcloud init` to set your GCP project and login.  If you are logged in and just need to change project run`gcloud config set projec <project-id>`