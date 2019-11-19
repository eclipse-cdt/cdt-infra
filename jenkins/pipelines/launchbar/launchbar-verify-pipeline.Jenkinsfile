pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Git Clone') {
      steps {
        container('platform-sdk') {
          checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.launchbar.git']]])
        }
      }
    }
    stage('Code Formatting Checks') {
      steps {
        container('platform-sdk') {
          timeout(activity: true, time: 20) {
            sh './check_code_cleanliness.sh'
          }
        }
      }
    }
    stage('Launchbar Verify') {
      steps {
        container('platform-sdk') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
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
      container('platform-sdk') {
        junit '**/TEST-*.xml'
        archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
      }
    }
  }
}
