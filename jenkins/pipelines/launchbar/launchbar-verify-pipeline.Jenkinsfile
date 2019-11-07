pipeline {
  agent {
    kubernetes {
      label 'launchbar-verify-pipeline-940ea19'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Launchbar Verify') {
      steps {
        container('cdt') {
          timeout(120) {
            checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.launchbar.git']]])
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh """/usr/share/maven/bin/mvn \
clean verify -B -V \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml"""
            }

            junit '**/TEST-*.xml'
            archiveArtifacts '**/screenshots/*.jpeg,**/target/**/*.log'
          }
        }
      }
    }
  }
}
