pipeline {
  agent {
    kubernetes {
      label 'cdt-9.9-standalone-debugger-35cfe16'
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
          git branch: 'cdt_9_9', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git'
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
clean verify -B -V \
-P production \
-P build-standalone-debugger-rcp \
-P baseline-compare-and-replace \
-DuseSimrelRepo \
-f debug/org.eclipse.cdt.debug.application.product \
-Ddsf.gdb.tests.timeout.multiplier=50 \
-Dindexer.timeout=300 \
-Dmaven.repo.local=/home/jenkins/.m2/repository \
--settings /home/jenkins/.m2/settings.xml"
            }

            archiveArtifacts 'debug/org.eclipse.cdt.debug.application.product/target/product/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/products/*.zip,debug/org.eclipse.cdt.debug.application.product/target/products/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/repository/**'
          }
        }
      }
    }
  }
}
