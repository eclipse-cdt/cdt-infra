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
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CheckoutOption', timeout: 20], [$class: 'CloneOption', depth: 0, noTags: true, reference: '', shallow: false]], submoduleCfg: [], userRemoteConfigs: [[url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
        }
      }
    }
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -Dmaven.test.failure.ignore=true \
                      -P build-standalone-debugger-rcp \
                      -P baseline-compare-and-replace \
                      -DuseSimrelRepo \
                      -f debug/org.eclipse.cdt.debug.application.product \
                      -Ddsf.gdb.tests.timeout.multiplier=50 \
                      -Dindexer.timeout=300 \
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
      container('cdt') {
        archiveArtifacts 'debug/org.eclipse.cdt.debug.application.product/target/product/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/products/*.zip,debug/org.eclipse.cdt.debug.application.product/target/products/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/repository/**'
      }
    }
  }
}
