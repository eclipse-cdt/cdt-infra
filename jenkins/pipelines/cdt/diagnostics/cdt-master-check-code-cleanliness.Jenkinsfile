pipeline {
  agent {
    kubernetes {
      label 'cdt-master-check-code-cleanliness-92a2d1e'
      yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Code Formatting Checks') {
      steps {
        container('platform-sdk') {
          timeout(20) {
            git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git'
            sh './releng/scripts/check_code_cleanliness.sh'
          }
        }
      }
    }
  }
}
