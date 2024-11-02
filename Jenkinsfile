#!/usr/bin/env groovy
//  vim:ts=4:sts=4:sw=4:et:filetype=groovy:syntax=groovy
//

// ========================================================================== //
//                        J e n k i n s   P i p e l i n e
// ========================================================================== //

// Epic Jenkinsfile template:
//
// https://github.com/nholuongut/templates/blob/master/Jenkinsfile


// Official Documentation:
//
// https://jenkins.io/doc/book/pipeline/syntax/
//
// https://www.jenkins.io/doc/pipeline/steps/
//
// https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/


pipeline {
  // to run on Docker or Kubernetes, see the master Jenkinsfile template listed at the top
  agent any

  options {
    timestamps()

    timeout(time: 2, unit: 'HOURS')
  }

  triggers {
    cron('H 10 * * 1-5')
    pollSCM('H/2 * * * *')
  }

  stages {
    stage ('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/nholuongut/DevOps-Bash-tools']]])
      }
    }

    stage('Build') {
      steps {
        echo "Running ${env.JOB_NAME} Build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        echo 'Building...'
        timeout(time: 10, unit: 'MINUTES') {
          retry(3) {
//            sh 'apt update -q'
//            sh 'apt install -qy make'
//            sh 'make init'
            sh """
              setup/ci_bootstrap.sh &&
              make init
            """
          }
        }
        timeout(time: 180, unit: 'MINUTES') {
          sh 'make ci'
        }
      }
    }

    stage('Test') {
      options {
        retry(2)
      }
      steps {
        echo 'Testing...'
        timeout(time: 120, unit: 'MINUTES') {
          sh 'make test'
        }
      }
    }
  }
}
