# Project
environment                 = "int"
application_name            = "science-platform-firestore"
folder_id                   = "19762437767"
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

gafaelfawr_project_id = "science-platform-int-dc5d"
gafaelfawr_sa         = "gafaelfawr@science-platform-int-dc5d.iam.gserviceaccount.com"

# If you didn't make any other changes to this file, increase this number to
# force Terraform to update this environment. You may need to do this if you
# changed .tf files in this environment, or if you changed any modules that
# this environment uses, but you didn't change any variables in this file.
# Serial: 10

