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
                    git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-vscode'
                    timeout(activity: true, time: 20) {
                        sh '''
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