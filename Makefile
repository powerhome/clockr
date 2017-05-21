PWD = `pwd`

default: build_builder test

build_builder:
	docker build --tag powerhome/clockr-builder --file Dockerfile.builder .

test:
	docker run --interactive --rm --volume $(PWD)\:/src/clockr --env MIX_ENV=test powerhome/clockr-builder mix do deps.get, test, credo

watch:
	docker run --interactive --rm --volume $(PWD)\:/src/clockr --env MIX_ENV=test powerhome/clockr-builder mix do deps.get, test.watch

serve:
	docker run --interactive --rm --volume $(PWD)\:/src/clockr --publish 4000:4000 powerhome/clockr-builder ./dev.sh

build:
	docker run --interactive --rm --volume $(PWD):/src/clockr --env MIX_ENV=prod powerhome/clockr-builder
	docker build --tag powerhome/clockr --file Dockerfile.run .

.PHONY: build_builder test serve
