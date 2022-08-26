# Slack integration

## Installing the Slack App for Datafold

> You must be a **Slack admin** with permission to install apps for your workspace in order to complete this integration.

To install the Slack App, open _Settings / Integrations_, click _New integration_, select _Slack_, click _Create_.

![](<../../../.gitbook/assets/image (99).png>)

After clicking _Create,_ you will be forwarded to Slack's website for approval. If you have permission to add applications to your workspace, click _Allow_. Select the proper one in the upper right corner if you have access to multiple namespaces.

![](<../../../.gitbook/assets/image (141).png>)

Once allowed, you will be redirected back to Datafold, and the new integration will be seen in the list. It can now be used in alerts.

![](<../../../.gitbook/assets/image (80).png>)

#### Application approval

If your Slack workspace requires approval of applications, fill in the form and send the request for approval instead of the Allow button. Contact your Slack administrators for approval.

![](<../../../.gitbook/assets/image (72).png>)

Once the approval is granted, you will receive a direct message in Slack from Slackbot. To install the application repeat the steps from the beginning — now, you will see the _Allow_ button.

## Reinstalling the Datafold Slack App

Optionally, an admin can reinstall the Slack App by opening the existing Slack App integration and clicking the _Reinstall_ button. This will upgrade all the granted scopes (if they have changed), refresh the access credentials, reload the names, channels, groups, and users — as if the application is newly installed — except that it will remain the same integration with the existing subscriptions.

_Note: If you created a Slack App integration before Feb'2022, to use Slack groups, you have to reinstall the integration — a new permission scope will be requested to scan the workspace groups. Otherwise, Slack groups will not be available. The rest will continue working as before._

![](<../../../.gitbook/assets/image (132).png>)

## Uninstalling the Datafold Slack App

To uninstall the application:

* Remove the Slack App subscriptions from all alerts.
* Remove the integration from Datafold ("Settings / Integrations").
* Remove the Slack App from your Slack workspace

## Subscribing to alerts

Users can subscribe to alerts themselves or be subscribed by others. However, only those Slack users that are mapped to Datafold users can be subscribed. The mapping is performed by a fully matched email address. Unmapped users will not be present in the selection.

Besides, Slack groups or special Slack handles `@here` & `@channel` can be subscribed to alerts to notify everyone in that channel (or only those online at the moment).

![](<../../../.gitbook/assets/image (267).png>)

The subscribed users are _mentioned_ in the alert notifications when they trigger:

![](<../../../.gitbook/assets/image (263).png>)
