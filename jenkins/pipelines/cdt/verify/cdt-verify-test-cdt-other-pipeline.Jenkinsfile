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
            /* Running the git fetch command manually is a workaround. See https://bugs.eclipse.org/bugs/show_bug.cgi?id=560283#c16  */
            sh 'git config remote.origin.url https://git.eclipse.org/r/cdt/org.eclipse.cdt.git'
            /* Workaround for Bug 568904 */
            sh 'git config protocol.version 1'
            sh 'git fetch --no-tags --force --progress -- https://git.eclipse.org/r/cdt/org.eclipse.cdt.git +refs/heads/*:refs/remotes/origin/*'
          }
          checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']], [$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'https://git.eclipse.org/r/cdt/org.eclipse.cdt.git']]])
        }
      }
    }
    stage('Run build and test cdt other than ui and DSF-GDB') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -Dmaven.test.failure.ignore=true \
                      -P skip-tests-except-cdt-other \
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
        junit '*/*/target/surefire-reports/*.xml,terminal/plugins/org.eclipse.tm.terminal.test/target/surefire-reports/*.xml'
        /* Unlike other veify jobs, this one archives the p2 repos and standalone debugger, the
         * same archive as the master job. This enables testing a fully built project without
         * having to merge
         */
        archiveArtifacts '*/*/target/surefire-reports/**,terminal/plugins/org.eclipse.tm.terminal.test/target/surefire-reports/**,**/target/work/data/.metadata/.log,releng/org.eclipse.cdt.repo/target/org.eclipse.cdt.repo.zip,releng/org.eclipse.cdt.repo/target/repository/**,releng/org.eclipse.cdt.testing.repo/target/org.eclipse.cdt.testing.repo.zip,releng/org.eclipse.cdt.testing.repo/target/repository/**,debug/org.eclipse.cdt.debug.application.product/target/product/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/products/*.zip,debug/org.eclipse.cdt.debug.application.product/target/products/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/org.eclipse.lsp4e.cpp.repo.zip'
      }
    }
  }
}
