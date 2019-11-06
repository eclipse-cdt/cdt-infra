pipeline {
  agent {
    kubernetes {
      label 'cdt-verify-code-cleanliness-pipeline-149df18'
      yamlFile 'jenkins/pod-templates/cdt-platform-sdk.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Code Formatting Checks') {
      steps {
        container('platform-sdk') {
          timeout(20) {
            checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
            sh './releng/scripts/check_code_cleanliness.sh'
          }
        }
      }
    }
  }
}
