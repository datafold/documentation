# Error handling

All Datafold API endpoints return the errors as per [RFC-7807](https://datatracker.ietf.org/doc/html/rfc7807).&#x20;

```
{
  "type": "/errors/integrity",
  "title": "Uniqueness violation",
  "status": 409,
  "detail": "The resource with email=hello@example.com already exists.",
  "instance": "2022-02-08T14:30:55.851512Z/gs8ueabo/11840"
}
```

The fields `type`, `status`, and `instance` are always present. Other fields can be omitted depending on the error.

The "instance" field is a unique identifier of the problem. Please do not parse or interpret it — its format can change without warnings. Consider this as a string only. If possible, provide it to Datafold engineers when asking for help — this will help us to locate the issue and its circumstances in the logs.

The MIME type is always `application/problem+json`, so it can be parsed in almost all cases (except when the errors come from an intermediate reverse proxy or a load balancer).

The status codes are always 4xx or 5xx on errors. Specifically, the following convention is used:

* 401 — an authentication is needed, anonymous operations are not allowed.
* 403 — you have no access to this resource referred by the URL or to this operation.
* 404 — the resource referred to by the URL does not exist.
* 409 — there is already a conflicting object for the one you try to create (e.g. a user with the same email).
* 422 — the input values are malformed or do not pass the validation. In most cases, the extra field "errors" is added with an explanation of what is wrong with the inputs. This also covers the resources referred to by the payload fields (contrary to 404) — e.g. absent notification destinations when an alert query is created/modified.
* 400 — all other cases when the error is on the client-side and can be fixed by the client. Mostly, this happens when the requested action cannot be performed even if the inputs are correct — e.g. due to the organization's configuration (can be fixed by the admins), or when a third-party service responds with errors to Datafold (can be fixed by the admins of that service).
* 500 — all other cases when the error happened on the server-side and cannot be fixed by the client without involving a Datafold engineer.
