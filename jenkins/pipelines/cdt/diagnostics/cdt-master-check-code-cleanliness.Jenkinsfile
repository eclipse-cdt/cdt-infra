pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
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
    stage('Code Formatting Checks') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh 'MVN="/usr/share/maven/bin/mvn -Dmaven.repo.local=/home/jenkins/.m2/repository \
                      --settings /home/jenkins/.m2/settings.xml" ./releng/scripts/check_code_cleanliness.sh'
          }
        }
      }
    }
  }
  post {
    always {
      container('cdt') {
        archiveArtifacts allowEmptyArchive: true, artifacts: '*.log'
      }
    }
  }
}
