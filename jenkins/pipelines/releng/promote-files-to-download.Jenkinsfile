pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  parameters {
    booleanParam(defaultValue: true, description: 'Do a dry run of the build. All commands will be echoed.First run with this on, then when you are sure it is right, choose rebuild in the passing job and uncheck this box', name: 'DRY_RUN')
  }
  options {
    timestamps()
  }
 stages {
    stage('Upload') {
      steps {
        container('cdt-releng') {
            sshagent ( ['projects-storage.eclipse.org-bot-ssh']) {
              sh './scripts/promote-files-to-download.sh'
            }
        }
      }
    }
  }
}
