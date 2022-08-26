# Alerting

In certain situations, you want to trigger alerts, for example, when a pipeline has finished. To do this, you can leverage the `datafold-sdk`. This small Python library allows you to trigger an alert in Datafold.

```
pip install datafold-sdk
```

First, we need to set the credentials using the environment variable `DATAFOLD_APIKEY`. In the case of self-hosted Datafold, you need to set the `DATAFOLD_HOST` as well:

```bash
export DATAFOLD_APIKEY=tnQrPAyIHquhx4x9LJdOHC28waU1P0FdCvabcabc
export DATAFOLD_HOST=https://datafold.company.io
```

Find the alert that you want to trigger. You can find the ID of the alert by looking at the URL:

![](<../../.gitbook/assets/image (227).png>)

Now you can run the alert:

```bash
datafold queries run --id 1429                                 
2022-02-15 09:55:33,420:WARNING:alerts: Started a run 355161 for the query 1429.
```

If the alert fails, you will get a message through the configured subscriptions (email, pagerduty, slack, etc). There is also the option to run the alert blocking:

```bash
datafold queries run --id 1429 --wait 3600 --interval 1 
2022-02-15 09:57:56,373:INFO:alerts: Finished a run 355165 for the query 1429: status=done
```

This way, the CLI will wait for the alert to finish, and you can see the result in the console.

















