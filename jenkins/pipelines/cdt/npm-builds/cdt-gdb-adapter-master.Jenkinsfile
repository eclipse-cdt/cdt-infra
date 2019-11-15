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
    stage('Git Clone') {
      steps {
        container('cdt') {
          git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-gdb-adapter'
        }
      }
    }
    stage('build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh '''
              yarn
            '''
          }
        }
      }
    }
    stage('test') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh '''
              yarn test
            '''
          }
        }
      }
    }
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
                yarn pack
                yarn version  --no-git-tag-version --prerelease --preid=next.$(git rev-parse --short HEAD)
                yarn publish --non-interactive --tag next
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
        junit 'test-reports/*.xml'
        archiveArtifacts 'cdt-gdb-adapter-*.tgz'
      }
    }
  }
}