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
        stage('Run build') {
            steps {
                container('cdt') {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '${sha1}']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        submoduleCfg: [],
                        userRemoteConfigs: [[refspec: '+refs/pull/*:refs/remotes/origin/pr/*',
                        url: 'https://github.com/eclipse-cdt/cdt-gdb-vscode']]])
                    timeout(activity: true, time: 20) {
                        sh '''
yarn
yarn build

export JUNIT_REPORT_PATH=test-reports/integration.xml
export JUNIT_REPORT_PACKAGES=1
export JUNIT_REPORT_STACK=1
# no tests yet
#yarn test
                        '''
                    }
                }
            }
        }
    }
}