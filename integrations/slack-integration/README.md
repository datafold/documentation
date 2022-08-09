# Slack integration

## Installing the Slack App for Datafold

To start working with Slack App for Datafold, an admin of your organization has to set up the Slack integration, which connects Datafold to your Slack workspace. That person has to have permission to add apps to the Slack workspace.

To install the Slack App, open _Settings / Integrations_, click _New integration_, select _Slack_, click _Create_.&#x20;

![](<../../.gitbook/assets/image (36).png>)

After clicking _Create,_ you will be forwarded to Slack's website for approval. If you have permission to add applications to your workspace, click _Allow_. Select the proper one in the upper right corner if you have access to multiple namespaces.

![](<../../.gitbook/assets/image (155).png>)

Once allowed, you will be redirected back to Datafold, and the new integration will be seen in the list. It can now be used in alerts.

![](<../../.gitbook/assets/image (76).png>)

#### Application approval

If your Slack workspace requires approval of applications, fill in the form and send the request for approval instead of the Allow button. Contact your Slack administrators for approval.&#x20;

![](<../../.gitbook/assets/image (119).png>)

Once the approval is granted, you will receive a direct message in Slack from Slackbot. To install the application repeat the steps from the beginning — now, you will see the _Allow_ button.

#### Reinstalling

Optionally, an admin can reinstall the Slack App by opening the existing Slack App integration and clicking the _Reinstall_ button. This will upgrade all the granted scopes (if they have changed), refresh the access credentials, reload the names, channels, groups, and users — as if the application is newly installed — except that it will remain the same integration with the existing subscriptions.

_Note: If you created a Slack App integration before Feb'2022, to use Slack groups, you have to reinstall the integration — a new permission scope will be requested to scan the workspace groups. Otherwise, Slack groups will not be available. The rest will continue working as before._

![](<../../.gitbook/assets/image (48).png>)

#### Uninstalling

To uninstall the application:

* Remove the Slack App subscriptions from all alerts.
* Remove the integration from Datafold ("Settings / Integrations").
* Remove the Slack App from your Slack workspace

## Sending alert notifications to Slack channels

You can configure the alert notifications to be sent to designated public or private Slack channels with an option to mention specific users. All public channels will automatically be available for reports:

![](<../../.gitbook/assets/image (91).png>)

You have to invite the Datafold bot into that channel for private channels by mentioning it as `@datafold` in the channel of interest. Within 5 minutes, the private channel will be included in the list of available channels. Otherwise, the channel will not be visible to Datafold.

![](<../../.gitbook/assets/image (134).png>)

After clicking the _Invite Them_ button:

![](<../../.gitbook/assets/image (42).png>)

To hide the private channel from the bot, remove the bot from the channel. The application will notice the change within 5 minutes.

## Subscribing to alerts

Users can subscribe to alerts themselves or be subscribed by others. However, only those Slack users that are mapped to Datafold users can be subscribed. The mapping is performed by a fully matched email address. Unmapped users will not be present in the selection.

Besides, Slack groups or special Slack handles `@here` & `@channel` can be subscribed to alerts to notify everyone in that channel (or only those online at the moment).

![](<../../.gitbook/assets/image (197).png>)

The subscribed users are _mentioned_ in the alert notifications when they trigger:

![](<../../.gitbook/assets/image (202).png>)
