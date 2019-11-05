pipeline {
  agent {
    kubernetes {
      label 'debug-remote-tests-master-gdb-8.3-040826d'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Run build') {
      steps {
        container('cdt') {
          git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git'
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn clean verify -B -V \
-Pskip-tests-except-dsf-gdb \
-Dcdt.tests.dsf.gdb.versions=gdbserver.8.3 \
-DskipDoc=true \
-Ddsf.gdb.tests.timeout.multiplier=50 \
-Dindexer.timeout=300 \
-Dmaven.repo.local=/home/jenkins/.m2/repository \
--settings /home/jenkins/.m2/settings.xml \
"
            }

            junit '*/*/target/surefire-reports/*.xml'
          }
        }
      }
    }
  }
}
