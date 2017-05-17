#!/usr/bin/env groovy

node('docker') {
  stage('Setup') {
    checkout scm
    sh "docker build --tag powerhome/clockr-builder --file Dockerfile.builder ."
  }

  stage('Test') {
    echo "Testing ${env.BRANCH_NAME}..."
    sh 'docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=test powerhome/clockr-builder mix do deps.get, test, credo'
  }

  stage('Release') {
    sh 'docker run --interactive --rm --volume $(pwd):/src/clockr --env MIX_ENV=prod powerhome/clockr-builder'
    sh "docker build --tag powerhome/clockr --file Dockerfile.run ."
  }
}
