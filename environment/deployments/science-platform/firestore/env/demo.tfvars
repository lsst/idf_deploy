# Project
environment                 = "demo"
application_name            = "science-platform-firestore"
folder_id                   = "48296113584"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]


# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# and Cloud SQL Admin (required for the Cloud SQL Auth Proxy) in addition to
# our standard APIs.
activate_apis = [
  "stackdriver.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
]

# Increase this number to force Terraform to update the demo environment.
# Serial: 1

gafaelfawr_project_id = "science-platform-demo-9e05"
gafaelfawr_sa         = "gafaelfawr@science-platform-demo-9e05.iam.gserviceaccount.com"
