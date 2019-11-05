pipeline {
  agent {
    kubernetes {
      label 'tools-templates-master-040826d'
      yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Run build') {
      steps {
        container('cdt') {
            git branch: 'master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.tools.templates.git'
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh """/usr/share/maven/bin/mvn clean verify -B -V -Pproduction \
-Dmaven.repo.local=/home/jenkins/.m2/repository --settings /home/jenkins/.m2/settings.xml"""
            }

            archiveArtifacts 'repo/target/repository/**,repo/target/org.eclipse.tools.templates.repo.zip'
        }
      }
    }
  }
}
