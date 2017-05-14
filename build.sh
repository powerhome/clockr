#!/bin/bash

yarn install
mix do deps.get, compile, release
