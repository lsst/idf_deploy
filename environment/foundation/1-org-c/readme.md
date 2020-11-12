# Manual Steps

These are the steps that cannot be automated.

## Managing default organization roles

When an Organization is created, all users in your domain are granted the <b>Billing Account Creator</b> and <b>Project Creator</b> roles by default.

The <b>Project Creator</b> role needs to be removed and re-applied to a different GCP folder to allow project creation.

Because these roles are deployed before Terraform can manage the environment, a manual step needs to be performed.

### Steps

* At the organization level, edit the `@domain.com` and remove the <b>Project Creator</b> role.
* Automation should have created a custom role, normally this will be named something like `[Custom] Folder Viewer` and applied to the desired GCP folder
* Lastly, on the desired GCP folder, add a new IAM role and assign the `@domain.com` and assign the <b>Project Creator</b> role.

## Setting up Security Command Center

[Here's the best link to follow](https://cloud.google.com/security-command-center/docs/quickstart-security-command-center#org-setup)

To set up Security Command Center for your organization, choose the Security Command Center tier you want, enable the services or security sources that you want to display findings in the Security Command Center dashboard, select the resources or assets to monitor, and then grant permissions for the Security Command Center service account

## Create a Security Command Center Notification Channel

Enable the Security Command Center API notifications feature. Notifications send information to a Pub/Sub topic to provide findings updates and new findings within minutes. Because Security Command Center works at the organization level, Security Command Center API notifications include all of the finding information that is displayed in the Security Command Center dashboard.

### Setting up Pub/Sub Topic

[Here's the best link to follow](https://cloud.google.com/security-command-center/docs/how-to-notifications#create-notification-config)

In this step, you create and subscribe to the Pub/Sub topic that you want to send notifications to. This configuration should already be configured and setup during the [1-org](../1-org) step. To confirm the topic and subscription have been created, use the following `gcloud` command or confirm through the UI.
```gcloud
gcloud pubsub topics list
```

If it a pub/sub topic and subscription are not there re-run the [1-org](../1-org) step.

### Creating a NotificationConfig

Create the `NotificationConfig` using the `gcloud` command:
```gcloud
  # The numeric ID of the organization
  ORGANIZATION_ID=organization-id

  # The topic to which the notifications are published
  PUBSUB_TOPIC="projects/project-id/topics/topic-id"

  # The description for the NotificationConfig
  DESCRIPTION="Notifies for active findings"

  # Filters for active findings
  FILTER="state=\"ACTIVE\""

  gcloud scc notifications create notification-name \
    --organization "$ORGANIZATION_ID" \
    --description "$DESCRIPTION" \
    --pubsub-topic $PUBSUB_TOPIC \
    --filter "$FILTER"
```

## Sharing G Suite data

[Here's the best link to follow](https://cloud.google.com/logging/docs/audit/gsuite-audit-logging#getting-started)

To enable sharing of G Suite data with Cloud Audit Logs from your G Suite, Cloud Identity, or Drive Enterprise account, see the instructions in this [G Suite Admin Help article](https://support.google.com/a/answer/9320190).

### Share data with Google Cloud Platform services

1. Log into the [G Suite Admin console](https://admin.googlecom).
1. From the Admin console Home page, go to Account settingsand thenLegal & compliance.
1. Click <b>Sharing options</b>.
  * To share data, click <b>Enabled</b>.
  * To turn off sharing, click <b>Disabled</b>. No new data is shared with GCP services. Existing shared data is deleted according to the GCP Admin Activity Audit log retention period.
1. Click <b>Save</b>.