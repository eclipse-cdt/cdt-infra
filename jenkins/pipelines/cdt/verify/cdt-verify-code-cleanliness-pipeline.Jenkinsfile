pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
    }
  }
  options {
    timestamps()
  }
  stages {
    stage('Git Clone') {
      steps {
        container('platform-sdk') {
          /* Unlike other veify jobs, this one does baseline-compare-and-replace, which means it needs full depth on git clone */
          timeout(activity: true, time: 20) {
            sh 'git version'
            sh 'git config remote.origin.url https://git.eclipse.org/r/cdt/org.eclipse.cdt.git'
            sh 'git fetch --no-tags --force -- https://git.eclipse.org/r/cdt/org.eclipse.cdt.git $GERRIT_REFSPEC'
            sh 'git checkout --force FETCH_HEAD'
          }
        }
      }
    }
    stage('Code Formatting Checks for CDT version < 10.0') {
      // CDT version < 10 uses Java 8
      when {
        expression { env.GERRIT_BRANCH != 'master' }
      }
      steps {
        container('platform-sdk') {
          timeout(activity: true, time: 20) {
            sh 'JAVA_HOME=$JAVA8_HOME PATH=$JAVA_HOME/bin:$PATH \
                MVN="/usr/share/maven/bin/mvn -Dmaven.repo.local=/home/jenkins/.m2/repository \
                      --settings /home/jenkins/.m2/settings.xml" ./releng/scripts/check_code_cleanliness.sh'
          }
        }
      }
    }
    stage('Code Formatting Checks for CDT version >= 10.0') {
      when {
        expression { env.GERRIT_BRANCH == 'master' }
      }
      steps {
        container('platform-sdk') {
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
