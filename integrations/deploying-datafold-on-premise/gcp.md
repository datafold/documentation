---
description: Deploying Datafold within your Google Cloud Platform
---

# GCP

## Create a new Project

This guide will take you through the steps to create a new project to set up datafold within your own Cloud environment. For isolation reasons, it is best practice to [create a new project](https://console.cloud.google.com/projectcreate) within your GCP organization. Please call it something like `yourcompany-datafold` to make it easily identifiable for us both:

![](<../../.gitbook/assets/image (96).png>)

It takes a minute to create the project. Afterward, you should be able to see the new project:

![](<../../.gitbook/assets/image (57).png>)

Navigate to the IAM tab to invite Datafold to the project:

![](<../../.gitbook/assets/image (22).png>)

Add a new user to the project:

![](<../../.gitbook/assets/image (243).png>)

Invite the Datafold solution engineer (\<user>@datafold.com) to the project, and assign him as an owner of the project:

![](<../../.gitbook/assets/image (70).png>)

The Owner is required, because of the IAM permissions to create a service account, which will be used to run Datafold. After setting up Datafold, the permission can be revoked. The service account will run under “Project/Editor”, “Service Networking/Service Networking Admin” permissions. We'll enable the following GCP APIs to run Datafold:

1. [Cloud Resource Manager API](https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com)
2. [Cloud Billing API](https://console.cloud.google.com/apis/library/cloudbilling.googleapis.com)
3. [Identity and Access Management (IAM) API](https://console.cloud.google.com/apis/library/iam.googleapis.com)
4. [Kubernetes Engine API](https://console.cloud.google.com/apis/library/container.googleapis.com)
5. [Service Networking API](https://console.cloud.google.com/apis/library/servicenetworking.googleapis.com)
6. [Compute Engine API](https://console.cloud.google.com/apis/library/compute.googleapis.com)
7. [Service Management API](https://console.cloud.google.com/apis/library/servicemanagement.googleapis.com)
8. [Cloud SQL Admin API](https://console.cloud.google.com/apis/library/sqladmin.googleapis.com)
9. [Google Cloud Memorystore for Redis API](https://console.cloud.google.com/apis/library/redis.googleapis.com?q=memor\&id=306efa89-7b50-4186-ba99-29c960fb6289\&project=rapidsql\&authuser=2\&folder\&organizationId)

Once the access has been granted, make sure to notify Datafold, so we can initiate the deployment.
