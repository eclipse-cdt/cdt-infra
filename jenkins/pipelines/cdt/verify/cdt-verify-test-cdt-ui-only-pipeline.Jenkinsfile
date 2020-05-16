pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps()
  }
  stages {
    stage('Git Clone') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh 'git version'
            sh 'git config remote.origin.url https://git.eclipse.org/r/cdt/org.eclipse.cdt.git'
            sh 'git fetch --no-tags --force -- https://git.eclipse.org/r/cdt/org.eclipse.cdt.git $GERRIT_REFSPEC'
            sh 'git checkout --force FETCH_HEAD'
          }
        }
      }
    }
    stage('Run build and test cdt.ui') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -P build-standalone-debugger-rcp \
                      -P skip-tests-except-cdt-ui \
                      -DskipDoc=true \
                      -Ddsf.gdb.tests.timeout.multiplier=50 \
                      -Dindexer.timeout=300 \
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
      container('cdt') {
        junit '*/*/target/surefire-reports/*.xml'
        archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
      }
    }
  }
}
