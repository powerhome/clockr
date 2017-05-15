#!/bin/bash

mix deps.get
yarn install
iex -S mix phoenix.server
