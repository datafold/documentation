---
description: >-
  The preparations required to deploy Datafold in your own Amazon Web Services
  (AWS) Account
---

# AWS

### Domain name

Create a DNS A-record for the domain (for example, datafold.domain.tld) where Datafold is going to be hosted. For the DNS record there are two options:

* **Public-facing** When the domain is publicly available, we will provide an SSL certificate for the endpoint.
* **Internal** It is also possible to have Datafold disconnected from the internet. This would require an internal DNS (for example, AWS Route 53) record that points to the Datafold instance. It is possible to provide your own certificate for setting up the SSL connection.

Once the deployment is complete, you will point that A-record to the IP address of the Datafold service.

### Allow Datafold access to the AWS Account

For setting up Datafold, it is required to set up a separate account within your organization where we can deploy Datafold. We're following the [best practices of AWS to allow third-party access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id\_roles\_common-scenarios\_third-party.html).

#### Create a separate AWS account for Datafold

First, create a new account for Datafold. Go to My Organization to add an account to the organization:

![](<../../.gitbook/assets/image (196).png>)

Add an AWS Account:

![](<../../.gitbook/assets/image (142).png>)

We call the account name "Datafold". Make sure that the email address of the owner isn't used by another account.

![](<../../.gitbook/assets/image (61).png>)

When you hit the "Create AWS Account" button, you'll be returned back the organization screen, and see the notification that the new account is being created. After you refresh a couple of times, the account should appear in the list:

![](<../../.gitbook/assets/image (209).png>)

#### Grant Third-Party access to Datafold

To make sure that deployment runs as expected, your Datafold Customer Engineer may need access to the Datafold-specific AWS account that you created. The access can be revoked after the deployment if needed. To grant access, log into the account created in the previous step. You can switch to the newly created account using the [Switch Role page](https://signin.aws.amazon.com/switchrole):

![](<../../.gitbook/assets/image (103).png>)

By default the role name is **OrganizationAccountAccessRole**.

Now you're logged in into the Account of Datafold:

![](<../../.gitbook/assets/image (220).png>)

#### Grant Access to Datafold

Next, we need to allow Datafold to access the account. We do this by allowing the Datafold AWS account to access your AWS workspace. Go to the [IAM page](https://console.aws.amazon.com/iam/home) to add a role:

![](<../../.gitbook/assets/image (33).png>)

Go to the Roles page, and hit Create role:

![](<../../.gitbook/assets/image (239).png>)

Select Another AWS Account, and use account ID **710753145501** which is the one of Datafold. Make sure to Require MFA.

![](<../../.gitbook/assets/image (212).png>)

Let's get back to the previous tab, and make sure to select **AdministratorAccess** gives us control over the resources within the account.

![](<../../.gitbook/assets/image (188).png>)

Next, you can set Tags; however, they are not a requirement.&#x20;

Finally, give the role a name of your choice and in line with your organization's naming conventions. Avoid calling it "Datafold" as in the pictures below:&#x20;

![](<../../.gitbook/assets/image (215).png>)

Now the role is created, which marks Datafold as a trusted entity:

![](<../../.gitbook/assets/image (130).png>)

Please provide the link referenced in"_Give this link to users who can switch roles in the console"_  to Datafold:

![](<../../.gitbook/assets/image (126).png>)

That's is, and we'll take it from there. After validating the deployment, and making sure that everything works as it should, we can revoke the credentials.
