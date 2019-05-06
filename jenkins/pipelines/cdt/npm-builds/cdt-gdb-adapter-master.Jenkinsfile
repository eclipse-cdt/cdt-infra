pipeline {
    agent {
        kubernetes {
            label 'cdt-agent-pod'
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
                    git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-gdb-adapter'
                    timeout(activity: true, time: 20) {
                        sh '''
yarn
yarn build

export JUNIT_REPORT_PATH=test-reports/integration.xml
export JUNIT_REPORT_PACKAGES=1
export JUNIT_REPORT_STACK=1
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