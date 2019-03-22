pipeline {
  agent {
    kubernetes {
      label 'cdt-agent-pod'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  stages {
    stage('Run build') {
      steps {
        container('cdt') {
          git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git'
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn clean verify -Pproduction -Pbuild-standalone-debugger-rcp \
-Ddsf.gdb.tests.timeout.multiplier=50 -Dindexer.timeout=300 \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml"
            }

            junit '*/*/target/surefire-reports/*.xml'
            archiveArtifacts 'releng/org.eclipse.cdt.repo/target/org.eclipse.cdt.repo.zip,releng/org.eclipse.cdt.repo/target/repository/**,releng/org.eclipse.cdt.testing.repo/target/org.eclipse.cdt.testing.repo.zip,releng/org.eclipse.cdt.testing.repo/target/repository/**,debug/org.eclipse.cdt.debug.application.product/target/product/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/products/*.zip,debug/org.eclipse.cdt.debug.application.product/target/products/*.tar.gz,debug/org.eclipse.cdt.debug.application.product/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/repository/**,lsp4e-cpp/org.eclipse.lsp4e.cpp.site/target/org.eclipse.lsp4e.cpp.repo.zip'
          }
        }
      }
    }
  }
}