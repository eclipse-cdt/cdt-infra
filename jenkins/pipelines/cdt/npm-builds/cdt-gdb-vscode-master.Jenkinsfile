pipeline {
    agent {
        kubernetes {
            label 'cdt-gdb-vscode-master-df43bbc'
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
                    git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-gdb-vscode'
                    timeout(activity: true, time: 20) {
                        sh '''
yarn upgrade cdt-gdb-adapter
yarn
yarn version --patch --no-git-tag-version
npm run vsce:package
                        '''
                        archiveArtifacts '*.vsix'
                    }
                }
            }
        }
    }
}