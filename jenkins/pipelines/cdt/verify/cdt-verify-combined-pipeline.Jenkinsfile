pipeline {
  agent none
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Verify Build') {
      failFast false
      parallel {
        stage('Code Formatting Checks') {
          agent {
          kubernetes {
              yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
            }
          }
          steps {
            container('platform-sdk') {
              timeout(20) {
                checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
                sh './releng/scripts/check_code_cleanliness.sh'
              }
            }
          }
        } //End Code Formatting Checks
        stage('CDT UI') {
          agent {
          kubernetes {
              yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
            }
          }
          steps {
            container('cdt') {
              timeout(120) {
                checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
                withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                    sh '''/usr/share/maven/bin/mvn clean verify -V -B -DskipDoc=true \
-Ddsf.gdb.tests.timeout.multiplier=50 \
-Dindexer.timeout=500 \
-Dorg.eclipse.cdt.ui.testplugin.DisplayHelper.TIMEOUT_MULTIPLIER=5 \
-f pom.xml \
-P skip-tests-except-cdt-ui \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml'''
                }

                junit '*/*/target/surefire-reports/*.xml'
                archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
              }
            }
          }
        } //End CDT UI
        stage('CDT Other') {
          agent {
          kubernetes {
              yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
            }
          }
          steps {
            container('cdt') {
              timeout(120) {
                checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
                withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                    sh '''/usr/share/maven/bin/mvn clean verify -V -B -DskipDoc=true \
-Ddsf.gdb.tests.timeout.multiplier=50 \
-Dindexer.timeout=500 \
-Dorg.eclipse.cdt.ui.testplugin.DisplayHelper.TIMEOUT_MULTIPLIER=5 \
-f pom.xml \
-P skip-tests-except-cdt-other \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml'''
                }

                junit '*/*/target/surefire-reports/*.xml'
                archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
              }
            }
          }
        } //End CDT Other
        stage('DSF GDB') {
          when {
            anyOf {
              changeset "dsf-gdb/**"
              changeset "dsf/**"
              changeset "debug/**"
            }
          }
          agent {
          kubernetes {
              yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
            }
          }
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
-P skip-tests-except-dsf-gdb \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml'''
                }

                junit '*/*/target/surefire-reports/*.xml'
                archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
              }
            }
          }
        } //End DSF GDB
      }
    }
  }
}
