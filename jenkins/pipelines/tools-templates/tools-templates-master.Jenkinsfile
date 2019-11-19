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
        container('platform-sdk') {
          git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.tools.templates.git'
        }
      }
    }
    stage('Code Formatting Checks') {
      steps {
        container('platform-sdk') {
          timeout(activity: true, time: 20) {
            sh './check_code_cleanliness.sh'
          }
        }
      }
    }
    stage('Main Build') {
      steps {
        container('platform-sdk') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -P production \
                      -Dmaven.repo.local=/home/jenkins/.m2/repository \
                      --settings /home/jenkins/.m2/settings.xml \
                      "
            }
          }
        }
      }
    }
  }
  post {
    always {
      container('platform-sdk') {
        junit allowEmptyResults: true, testResults: '**/TEST-*.xml'
        archiveArtifacts 'repo/target/repository/**,repo/target/*.zip'
      }
    }
  }
}
