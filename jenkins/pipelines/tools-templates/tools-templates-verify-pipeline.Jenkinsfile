pipeline {
  agent {
    kubernetes {
      label 'tools-templates-verify-pipeline-92a2d1e'
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
            checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.tools.templates.git']]])
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh """/usr/share/maven/bin/mvn \
clean verify -B -V \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml"""
            }

            junit allowEmptyResults: true,  testResults: '**/TEST-*.xml'
            archiveArtifacts allowEmptyArchive: true, artifacts: '**/screenshots/*.jpeg,**/target/**/*.log'
          }
        }
      }
    }
  }
}
