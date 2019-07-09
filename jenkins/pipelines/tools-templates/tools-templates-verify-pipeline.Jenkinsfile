pipeline {
  agent {
    kubernetes {
      label 'tools-templates-agent-pod'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
    }
  }
  options {
    timestamps()
  }
  stages {
    stage('Launchbar Verify') {
      steps {
        container('cdt') {
          timeout(120) {
            checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.tools.templates.git']]])
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh """/usr/share/maven/bin/mvn \
clean verify --batch-mode \
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
