# SAML

SAML (Security Assertion Markup Language) is a protocol for authenticating users with arbitrary Identity Providers to access arbitrary Service Providers. In this case, the Service Provider is Datafold (either SaaS or on-premise). The Identity Providers can be anything used by the organization, e.g. Google, Okta, Duo, etc.

The SAML functionality has to be enabled for your organization before this functionality can be used.

## Generic SAML Identity Providers

To configure SAML Single Sign-On with a generic Identity Provider, follow these steps (for several specific Identity Providers, see below):

**Step 1.** In the organization's Identity Provider, create a "SAML application" (sometimes, a "single sign-on method").

The Identity Provider will show the "Identity Provider metadata XML". Sometimes, it is a raw XML; sometimes, a URL to the XML; sometimes, it is an XML file to download — this can vary.

_The Identity Providers sometimes provide additional parameters, such as SSO URLs, ACS URLs, SLO URLs, etc. Safely ignore those fields — we take them all from the metadata XML._

**Step 2.** Open the Organisation Settings in Datafold, and copy-paste the Identity Provider metadata XML into the same-named field. Alternatively, copy-paste the metadata URL — and Datafold will download the XML.

![](<../../.gitbook/assets/image (190).png>)

Click "Save". The XML will be validated and saved. Once saved, a few read-only fields will show the Service Provider URLs specific to your organization.

![](<../../.gitbook/assets/image (255).png>)

**Step 3.** Copy-paste the generated Service Provider URLs (of Datafold) into the Identity Provider's application setup. The only two mandatory fields are "Service Provider Entity ID" and the "Service Provider ACS URL".

If you have a choice, enabled the SAML Response signature; in some cases, it implies either the whole-response signing or the assertion-only signing. Use the whole-response signing.

**Step 4.** Optionally, configure the following attribute mappings as expected by Datafold (this is not required but highly recommended): `first_name` and `last_name`, and/or `display_name`. The one to use depends on how the IdP is structured.

If the attribute mappings are not provided, Datafold will still auto-create users, if that is configured, but only use the email address as display name.

**Step 5.** In some Identity Providers, activate the SAML application for all users or for selected groups/units.

Since now, the SAML Login button will be available for the users of your organization. For SaaS, the users must be pre-created in Datafold — they will be identified by their email address.

For on-premise setups, the organization admins can turn on the "Auto-create users for SAML logins" checkbox. If enabled, the SAML login button will be enabled always, and all authenticated users will be automatically created in Datafold.

![](<../../.gitbook/assets/image (44).png>)

## Google as a SAML Identity Provider

Please follow this Google manual: [Set up your own custom SAML application](https://apps.google.com/supportwidget/articlehome?hl=en\&article\_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F6087519%3Fhl%3Den\&product\_context=6087519\&product\_name=UnuFlow\&trigger\_context=a). You need to be a _super-admin_ in the Google Workspace. Use the "Basic Information > Primary email" as the Name ID.

![](<../../.gitbook/assets/image (295).png>)

Configure the attribute mapping as follows:

![](<../../.gitbook/assets/image (296).png>)

To get the Identity Provider metadata after the application is created, click on the "Download Metadata" button on the left, and then click the "Download Metadata" button in the "Option 1" section:

![](<../../.gitbook/assets/image (175).png>)

## Okta as a SAML Identity Provider

A short walkthrough:

{% embed url="https://www.loom.com/share/8affd8d0b28b4b87bca1be5bf50c1f92" %}

### Step by step instructions

Log into your Okta admin console and open "Applications / Applications".&#x20;

Click "Create App Integration".

![](<../../.gitbook/assets/image (218).png>)

In the modal dialog, select "SAML 2.0" and click "Next".

![](<../../.gitbook/assets/image (178).png>)

Give the application a descriptive name, e.g. "Datafold SAML", then click "Next".

> Datafold expects the Identity Provider's metadata first and generates the Service Provider URLs later. Unlike other SAML applications, Okta expects it in reverse order: the Service Provider's URLs first and generates the Identity Provider's metadata afterward.
>
> This inconvenience will be fixed as soon as possible to adapt to Okta's flow.


To configure Okta, a little trick is needed:&#x20;

Set the Single Sign-On URL and Audience URI (SP Entity ID) to a fake URL, e.g. `https://x` (literally this or anything else).

Set the "Name ID format" to "EmailAddress".

Set the "Application username" to "Email".

Map the attributes as follows:

| Datafold attribute | Okta attribute   |
| ------------------ | ---------------- |
| `email`            | `user.email`     |
| `first_name`       | `user.firstName` |
| `last_name`        | `user.lastName`  |

![](<../../.gitbook/assets/image (278).png>)

Click "Next". On the feedback step, say that you are an Okta customer and integrate an app for yourselves. These answers affect nothing functional — you can keep them empty.

Click "Finish". The SAML application's page will open.

Locate the "Identity Provider metadata" link.

![](<../../.gitbook/assets/image (123).png>)

Copy the link of the metadata XML, go back to the Datafold Org Settings, and insert the link into the "SAML Identity Provider metadata URL" field. Click "Save" — the XML will be downloaded and shown in the XML field.

Alternatively (instead of the previous step), get the raw XML at that link and insert it into the "SAML Identity Provider metadata XML" text area. Click "Save".

Either way, after you save the URL or the XML, a few URLs will be provided from the Service Provider side (i.e. by Datafold). The most important and the most required URLs are:

* "SAML Service Provider ACS URL" ("ACS" stands for "Assertion Consumer Service");
* "SAML Service Provider Entity ID" (which usually looks like an URL).&#x20;

Other URLs are not used in Okta and can be ignored.

![](<../../.gitbook/assets/image (275).png>)

Go back to Okta, click "Edit" on the "Sign On" tab of the SAML integration and replace the fake URLs (entered at the first step) with the proper ones from Datafold. Click "Save".

Assign individuals or groups (units, teams, departments) to your new SAML integration as desired. Okta's permission system is out of the scope of Datafold's SAML configuration.

The configuration is finished. You can try to log in using Okta SAML.

## Mapping SAML user groups

> This feature is disabled by default. Please contact support if you are interested in enabling it.


If you want users from certain groups of your SSO provider to be mapped to certain Datafold groups automatically, you can configure such mapping on the group page. For example, if you want all users from `Development` group to become `admin` in Datafold automatically, you can configure the  `admin` group as follows.

![](<../../.gitbook/assets/image (129).png>)

The next thing is to configure SAML IDP to pass group membership information to the `groups` attribute in the SAML response. In Okta this can be configured under the  `Configure SAML` tab.

![](<../../.gitbook/assets/image (166).png>)

That's it. From now on, the group membership for each user of the `Development` group will be updated automatically after the next login/sign-up, even for existing Datafold users.
