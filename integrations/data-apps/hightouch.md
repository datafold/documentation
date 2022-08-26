# Hightouch

First, you'll need your Hightouch API key and workspace name to set up the integration.

#### In Hightouch

Go to your Hightouch workspace ([https://app.hightouch.io/](https://app.hightouch.io/))  -> Settings -> API Keys -> Add API Key

> Your API key will appear only once, so please copy and save it to your password manager for further use.


![Add API Key in Hightouch Settings ](<../../.gitbook/assets/Screenshot 2022-06-21 at 09.06.23.png>)

Grab your workspace URL, by navigating to Settings -> Workspace -> Workspace URL

![](<../../.gitbook/assets/Screenshot 2022-07-05 at 15.53.09.png>)

#### In Datafold

To set up the integration with Hightouch, as an admin, go to Settings -> Data apps -> Add new data app.

Then select Hightouch as an integration type.

Create a name, paste in your Hightouch workspace URL, API key and wait for the list of Hightouch sources to load.

![](<../../.gitbook/assets/Screenshot 2022-07-05 at 16.08.31.png>)

At this stage, we have to match Hightouch sources (on the left) and data sources in Datafold (on the right).

Just hit Submit after you're done with matching.

It will take some time to sync all the Hightouch entities to Datafold and for Lineage to do its job, but your Hightouch models and sync will appear in Catalog as search results, and Hightouch sources in data sources filter.

![](<../../.gitbook/assets/Screenshot 2022-07-06 at 16.46.31.png>)

Also, you'll be able to see Hightouch models and syncs as a part of your Lineage. Models will contain columns and syncs will contain destination names.

![](<../../.gitbook/assets/Screenshot 2022-06-21 at 09.20.31.png>)
