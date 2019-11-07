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
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh '''
              yarn
              yarn test

              #yarn publish --patch

              yarn pack
            '''
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