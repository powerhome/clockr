#!/bin/bash

mix do deps.get
yarn install
mix do compile, release
