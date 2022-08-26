---
description: Setting up on premise instances of the Datafold Github app
---

# On-prem Github

> This section is only for companies that selected an on-prem (single-tenant) deployment of Datafold. If you are on the SaaS deployment, follow [this](./) manual.


On-prem clients of Datafold need to create their own GitHub app. This is because we can't expose the credential of the public Datafold app in the customers deployment.

We've made this process easier from the main _Global Settings_ page in Datafold. All that is needed is to fill in the full URL to the Datafold installation and the name of the organization on GitHub, then click _Create GitHub App_. This will redirect the admin to GitHub, where they may need to authenticate. The GitHub user must be an admin of the GitHub organization.&#x20;

![](<../../../../.gitbook/assets/image (117).png>)

After entering the Github Organization, and clicking Create Github app, it will ask Github for confirmation:

![](<../../../../.gitbook/assets/image (154).png>)

Once the admin agrees to the creation of the GitHub App, the admin is returned to the Datafold settings screen. The button should then have disappeared and the details for the GitHub App should be available at the bottom of the screen.

![](<../../../../.gitbook/assets/image (228).png>)

If you see this screen with all the details, you've successfully created a GitHub App! Now the app is created, you have to install it using the [instructions](./) that also apply for SaaS Datafold.
