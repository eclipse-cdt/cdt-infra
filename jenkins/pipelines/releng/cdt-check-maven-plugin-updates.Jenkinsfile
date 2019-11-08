pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
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
          git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git'
        }
      }
    }
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
              sh './releng/scripts/check_mvn_plugin_versions.sh'
            }
          }
        }
      }
    }
  }
}
