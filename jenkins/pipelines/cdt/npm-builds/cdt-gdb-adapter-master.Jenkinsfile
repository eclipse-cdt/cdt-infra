pipeline {
    agent {
        kubernetes {
            label 'cdt-gdb-adapter-master-df43bbc'
            yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
        }
    }
    options {
        timestamps
        disableConcurrentBuilds()
    }
    stages {
        stage('Run build') {
            steps {
                container('cdt') {
                    git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-gdb-adapter'
                    timeout(activity: true, time: 20) {
                        sh '''
yarn
yarn build
yarn test

#yarn publish --patch

yarn pack
                        '''
                        junit 'test-reports/*.xml'
                        archiveArtifacts 'cdt-gdb-adapter-*.tgz'
                    }
                }
            }
        }
    }
}