pipeline {
  agent {
    kubernetes {
      label 'cdt-verify-test-cdt-ui-only-pipeline-940ea19'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('CDT UI') {
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
-P skip-tests-except-cdt-ui \
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
        archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
      }
    }
  }
}
