# Onprem Slack

Before setting up the Slack integration we need to create the Slack app. This step is required for on-prem credentials, since we cannot ship it with the Datafold app because that would include shipping the Slack App secrets.

![](<../../.gitbook/assets/image (129).png>)

First, we go to Global settings within your Datafold deployment. If you scroll down you'll see the Slack settings:

![](<../../.gitbook/assets/image (212).png>)

We click the **Create a Slack app configuration token**:

![](<../../.gitbook/assets/image (235).png>)

This token gives admin permissions for the Datafold API to set up the Slack integration. Select the workspace, and copy the Access Token:

![](<../../.gitbook/assets/image (178).png>)

We paste the token into the top input box, and hit **Create Slack App**:

![](<../../.gitbook/assets/image (19).png>)

Now you'll see the client id, secret and signing secret being set up:

![](<../../.gitbook/assets/image (256).png>)

Now you're ready to follow the steps in [Slack integration](./). If you want to know more about the Slack App itself, you can refresh the Slack page, and the Datafold app will appear:

![](<../../.gitbook/assets/image (223).png>)

The Slack App is set to **Not distributed,** meaning that it is only accessible to the Datafold instance running on-prem.
