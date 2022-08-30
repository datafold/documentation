# Okta

### Configuring authentication with Okta

Okta SSO is available for both SaaS and on-premise installs. You need to setup this under Org Settings:

![](<../../.gitbook/assets/image (102).png>)

To set up Okta integration, log in to Okta interface, go to Applications -> Applications and click "Create App Integration" button:

![](<../../.gitbook/assets/image (25).png>)

&#x20;In the popup select OIDC option. In the additional menu select "Web Application":

![](<../../.gitbook/assets/image (54).png>)

Set sign-in redirect URI, replace the domain name with domain where Datafold app is installed. There is one small difference for SaaS or on-premise installs:

![](<../../.gitbook/assets/image (277).png>)

* For on-premise, the redirect URL should be: `https://<install-hostname>/oauth/okta`
* For SaaS, the redirect URL should be `https://app.datafold.com/oauth/okta/<client-id>`, where client-id is the Client ID of the configuration. In the first screen, you don't have the client-id yet, but you need update the URL in the screen afterwards.
* Configure user assignments to the app as needed.

On the next screen you'll be presented with Client ID and Client Secret. Copy them:

![](<../../.gitbook/assets/image (95).png>)

In Datafold app, go to Settings -> Org Settings and fill in the details. If you want to auto-create users that are authorized to use the app, tick the "Autocreate Users" checkbox.

![](<../../.gitbook/assets/image (94).png>)

The metadata URI of Okta OAuth server, e.g.: `https://<okta-server-name>/.well-known/openid-configuration` where okta-server-name is your Okta domain.

Organization admins will always be able to log in with either password or Okta. Other users will be required to log in through Okta once configured.

### Okta initiated login

Users in your organization can log in to the application directly from the Okta end-user dashboard. To enable this feature, configure the integration as follows.

1. Set `Login initiated by` to `Either Okta or App`.
2. Set `Application visibility` to `Display application icon to users`.
3. Set `Login flow` to `Redirect to app to initiate login (OIDC Compliant).`
4. Set `Initiate login URI`:
   * For on-premise deployment to `https://<install-hostname>/login/sso/<client-id>?action=<action>`, where client-id is the Client ID of the configuration and action is `signup` if you enabled users auto-creation and `login` otherwise.
   * For SaaS to `https://app.datafold.com/login/sso/<client-id>?action=<action>,` where client-id is the Client ID of the configuration and action is `signup` if you enabled users auto-creation and `login` otherwise.

![IDP initiated login configuration example for SaaS deployment](<../../.gitbook/assets/Screenshot 2022-05-25 at 12.08.38.png>)
