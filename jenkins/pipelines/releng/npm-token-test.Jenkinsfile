pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('publish') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withCredentials([string(credentialsId: 'npmjs-token', variable: 'NPMJSTOKEN')]) {
              sh '''
                echo "//registry.npmjs.org/:_authToken=${NPMJSTOKEN}" >> ~/.npmrc
                echo "email eclipse-cdt-bot@eclipse.org" > ~/.yarnrc
                echo "username eclipse-cdt-bot" >> ~/.yarnrc
                npm whoami
              '''
            }
          }
        }
      }
    }
  }
  post {
    always {
      container('cdt') {
        archiveArtifacts '/home/vnc/.npm/_logs'
      }
    }
  }
}
