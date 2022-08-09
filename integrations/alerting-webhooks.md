# Alerting webhooks

Datafold can send alert notifications to arbitrary endpoints of arbitrary applications with arbitrary payloads (not only JSON) when an alert violates the thresholds or an anomaly appears.

{% hint style="info" %}
This feature is only available on request. Please contact Datafold to enable it for your organization.
{% endhint %}

Only the organization admins can configure the endpoints to which the notifications are sent. The users can use the pre-configured endpoints in alerts, but they cannot modify the URLs or payloads.

To create a webhook destination, open Admin / Settings / Integrations, click "New integration". Fill the form with the webhook URL, HTTP method, and the payload.

![](<../.gitbook/assets/image (194).png>)

In the payload, you can use the following placeholders:

| Placeholder                                                                                       | Description                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `{{id}}`                                                                                          | The id of the alert query.                                                                                                                                    |
| `{{url}}`                                                                                         | The URL of the alert query.                                                                                                                                   |
| `{{name}}`                                                                                        | The name of the alert query.                                                                                                                                  |
| `{{status}}`                                                                                      | <p>The status of the alert query:</p><ul><li>"triggered" (the violation or anomaly was detected).</li><li>"error" (the query execution has failed).</li></ul> |
| `{{secret1}}` & `{{secret2}}`                                                                     | The value of the secret fields in the webhook setup (hidden from the view for safety and stored encrypted). Use for API tokens, passwords, or similar things. |
| <p><code>{{threshold_events|json}}</code><br><code>{{threshold_events|json|str}}</code></p>       | A string with a JSON-serialized object describing the violated thresholds.                                                                                    |
| <p><code>{{missing_data_events|json}}</code><br><code>{{missing_data_events|json|str}}</code></p> | A string with a JSON-serialized object describing the missing data.                                                                                           |

The difference between `|json` and |`json|str` is that the former is just a JSON-serialized object, and the latter is an escaped string with the JSON-serialized object (i.e. double-serialized). The former can be used as the whole payload or in non-JSON payloads, while the latter can be put as a field value in a JSON payload. The raw non-serialized object is not provided.

Once the integration is finished, it will be available for all users to use in the alert subscriptions:

![](<../.gitbook/assets/image (172).png>)

