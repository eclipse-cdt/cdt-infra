pipeline {
    agent {
        kubernetes {
            label 'cdt-gdb-adapter-verify-940ea19'
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
                    checkout([
                        $class: 'GitSCM',
                        branches:
                        [[name: '${sha1}']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        submoduleCfg: [],
                        userRemoteConfigs: [[refspec: '+refs/pull/*:refs/remotes/origin/pr/*',
                        url: 'https://github.com/eclipse-cdt/cdt-gdb-adapter']]])
                    timeout(activity: true, time: 20) {
                        sh '''
yarn
yarn build
yarn test
                        '''
                        junit 'test-reports/*.xml'
                    }
                }
            }
        }
    }
    post {
        always {
            container('cdt') {
                archiveArtifacts '**'
            }
        }
    }
}