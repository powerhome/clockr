# Clockr

## Building

In order to build Clocker, you need only Docker, and to run the following commands:

* To build the app builder image: `make build_builder`
* To execute the test suite: `make test` or `make watch`
* To run a development server: `make serve`. Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
* To build a production node: `make build`

## Usage in production

```bash
docker run --publish 8888:8888 --env DATA_SOURCE="http://example.com/clocks" powerhome/clockr
```

### Data source API

Clockr consults a data source API in order to determine which clocks it should control and what should be displayed on them. It will make an HTTP GET request to the URL specified in the `DATA_SOURCE_URL` environment variable every 30 seconds and expects a response formatted according to the specification in `doc/data_source_api.yaml`, like the following example:

```json
{
  "clocks" : [
    {
      "id" : "abc123",
      "name" : "Conference Room 3",
      "ip" : "10.0.0.76",
      "mode" : "countdown",
      "target" : "2018-01-01 00:00:00 -0500"
    }
  ]
}
```

`DATA_SOURCE_URL` may specify HTTP Basic Auth credentials in the format `http://username:password@example.com/clocks`.

If no data source URL is provided, Clockr will UDP broadcast the current time to `237.252.0.0`.

## Credits

Copyright 2017 Power Home Remodelling Group, LLC. See the LICENSE file for more information.
