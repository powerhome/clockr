#!/usr/bin/env groovy

node('docker') {
  stage('Setup') {
    checkout scm
    sh "docker build --tag clockr/bulder --file Dockerfile.builder ."
  }

  stage('Build') {
    sh "docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=prod clockr/builder"
    sh "docker build --tag clockr/node --file Dockerfile.run ."
  }

  stage('Test') {
    echo "Testing ${env.BRANCH_NAME}..."
    sh "docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=test clockr/builder mix do deps.get, test"
  }
}
