# Clockr

## Building

In order to build Clocker, you need only Docker, and to run the following commands:

### To build the app builder image

```bash
docker build --tag powerhome/clockr-builder --file Dockerfile.builder .
```

### To execute the test suite

```bash
docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=test powerhome/clockr-builder mix do deps.get, test, credo
```

### To run a development server

```bash
docker run --interactive --rm --volume $(pwd):/src/clockr --publish 4000:4000 powerhome/clockr-builder ./dev.sh
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### To build a production node

```bash
docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=prod powerhome/clockr-builder
docker build --tag powerhome/clockr --file Dockerfile.run .
```

## Usage in production

```bash
docker run --publish 8888:8888 powerhome/clockr
```

## Credits

Copyright 2017 Power Home Remodelling Group, LLC. See the LICENSE file for more information.
