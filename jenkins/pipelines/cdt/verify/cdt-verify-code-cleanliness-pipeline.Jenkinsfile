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
        container('cdt') {
          /* Unlike other veify jobs, this one does baseline-compare-and-replace, which means it needs full depth on git clone */
          checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CheckoutOption', timeout: 20], [$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']], [$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', timeout: 20]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
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
