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
    stage('Run build') {
      steps {
        container('cdt') {
            git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.tools.templates.git'
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh """/usr/share/maven/bin/mvn clean verify -Pproduction \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml"""
            }

            archiveArtifacts 'repo/target/repository/**,repo/target/org.eclipse.tools.templates.repo.zip'
        }
      }
    }
  }
}