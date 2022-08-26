---
description: Configuring authentication with Google for On-Prem setups
---

# Google OAuth

Go to the Google admin console: [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials?authuser=1\&folder=\&project=datadiff-273119\&supportedpurview=project).

![](<../../.gitbook/assets/image (90).png>)

Fill the form:

* Application type: "Web application"
* Authorized JavaScript origins: `https://<your.domain.name>`
* Authorized redirect URIs: `https://<your.domain.name>/oauth/google`

![](<../../.gitbook/assets/image (45).png>)

1. Click "Create" and copy credentials.
2. In Datafold UI go to Settings -> Global settings enter credentials and click "Save"

![](<../../.gitbook/assets/image (199).png>)

