#!/usr/bin/env groovy

node('docker') {
  stage('Setup') {
    checkout scm
    sh "make build_builder"
  }

  stage('Test') {
    echo "Testing ${env.BRANCH_NAME}..."
    sh "make test"
  }

  stage('Release') {
    sh "make build"
  }
}
