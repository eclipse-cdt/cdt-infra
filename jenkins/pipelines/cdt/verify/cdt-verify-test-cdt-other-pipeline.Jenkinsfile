pipeline {
  agent {
    kubernetes {
      label 'cdt-verify-test-cdt-other-pipeline-df43bbc'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps
    disableConcurrentBuilds()
  }
  stages {
    stage('CDT Other') {
      steps {
        container('cdt') {
          timeout(120) {
            checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh '''/usr/share/maven/bin/mvn clean verify -B -V -DskipDoc=true \
-Ddsf.gdb.tests.timeout.multiplier=50 \
-Dindexer.timeout=500 \
-Dorg.eclipse.cdt.ui.testplugin.DisplayHelper.TIMEOUT_MULTIPLIER=5 \
-f pom.xml \
-P skip-tests-except-cdt-other \
-P build-standalone-debugger-rcp \
-P baseline-compare-and-replace \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml'''
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
        /* Unlike other veify jobs, this one archives the p2 repos and standalone debugger, the
         * same archive as the master job. This enables testing a fully built project without
         * having to merge
         */
        archiveArtifacts '**/target/work/data/.metadata/.log,releng/org.eclipse.cdt.repo/target/org.eclipse.cdt.repo.zip,releng/org.eclipse.cdt.repo/target/repository/**,releng/org.eclipse.cdt.testing.repo/target/org.eclipse.cdt.testing.repo.zip,releng/org.eclipse.cdt.testing.repo/target/repository/**,debug/org.eclipse.cdt.debug.application.product/target/product/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/products/*.zip,debug/org.eclipse.cdt.debug.application.product/target/products/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/org.eclipse.lsp4e.cpp.repo.zip'
      }
    }
  }
}
