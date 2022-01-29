pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
    }
  }
  options {
    timestamps()
  }
  stages {
    stage('Git Clone') {
      steps {
        container('cdt') {
          checkout([
            $class: 'GitSCM',
            branches:
            [[name: '${sha1}']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [],
            submoduleCfg: [],
            userRemoteConfigs: [[refspec: '+refs/pull/*:refs/remotes/origin/pr/*',
            url: 'https://github.com/eclipse-cdt-cloud/cdt-gdb-adapter']]])
        }
      }
    }
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh '''
              yarn
              yarn test
              yarn pack
            '''
          }
        }
      }
    }
  }
  post {
    always {
      container('cdt') {
        junit 'test-reports/*.xml'
        archiveArtifacts 'cdt-gdb-adapter-*.tgz,src/integration-tests/testlogs/**'
      }
    }
  }
}
