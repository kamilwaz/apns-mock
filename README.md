# APNSMock

A simple mock of Apple Push Notification service (APNs) for testing purposes.

## Running

To start the server, run the following command:

```bash
docker run --port 2197:2197 kamilwaz/apns-mock-server
```

## API

The endpoints are served over HTTP/2 and HTTPS.

APNs endpoints:

* `GET /3/device/:device_token` - sends a notification request (mocked)

Mock endpoints:

- `GET /mock/error-tokens` - returns error tokens
- `POST /mock/error-tokens` - add a new error token or update the existing one
- `POST /mock/reset` - clears error tokens and activity
- `GET /mock/activity`- returns a list of APNs requests

Error token defines what status and reason should be send in reply for the given device token.

Example:

```json
{
  "device_token": "eaf5a5fb-00ca-47f1-b6ad-0c5573a2251f",
  "status": 401,
  "reason": "Unauthorized"
}
```
