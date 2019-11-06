pipeline {
  agent {
    kubernetes {
      label 'promote-a-build-149df18'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: cdt
    image: quay.io/eclipse-cdt/cdt-infra-eclipse-full@sha256:58049f0614b087c0eda4884496eab5c6e738436e42f8c6c772aa911bd105494b
    tty: true
    args: ["cat"]
    resources:
      requests:
        memory: "512Mi"
        cpu: "1"
      limits:
        memory: "512Mi"
        cpu: "1"
    volumeMounts:
    - name: settings-xml
      mountPath: /home/jenkins/.m2/settings.xml
      subPath: settings.xml
      readOnly: true
    - name: m2-repo
      mountPath: /home/jenkins/.m2/repository
    - name: volume-known-hosts
      mountPath: /home/jenkins/.ssh
  volumes:
  - name: settings-xml
    secret:
      secretName: m2-secret-dir
      items:
      - key: settings.xml
        path: settings.xml
  - name: m2-repo
    emptyDir: {}
  - name: volume-known-hosts
    configMap:
      name: known-hosts
"""
    }
  }
  parameters {
    booleanParam(defaultValue: true, description: 'Do a dry run of the build. All commands will be echoed.First run with this on, then when you are sure it is right, choose rebuild in the passing job and uncheck this box', name: 'DRY_RUN')
    choice(choices: ['cdt', 'tools.templates', 'launchbar'], description: 'Project to promote. Promoting cdt will include the cdt standalone debugger.', name: 'PROJECT')
    booleanParam(defaultValue: true, description: 'Include CDT standalone debugger when publishing (if applicable)', name: 'STANDALONE')
    booleanParam(defaultValue: false, description: 'Publish only the standalon debugger. This is used to add the standalone debugger from a different job to the already published CDT release', name: 'STANDALONE_ONLY')
    string(defaultValue: '9.8', description: 'The major and minor version of CDT being released (e.g. 9.7, 9.8, 10.0).', name: 'MINOR_VERSION')
    string(defaultValue: 'cdt-9.8.0', description: 'The full name of this release (e.g. cdt-9.4.2, cdt-9.5.0-rc1, cdt-9.5.0-photon-m7, cdt-9.5.0-photon-rc1)', name: 'MILESTONE')
    string(defaultValue: 'cdt-master', description: 'The CI job name being promoted from', name: 'CDT_JOB_NAME')
    string(defaultValue: '12345', description: 'The CI build number being promoted from', name: 'CDT_BUILD_NUMBER')
    choice(choices: ['releases', 'builds', 'tools.templates', 'launchbar'], description: 'Publish location (releases or builds for CDT main project, or specific sub-project location for others)', name: 'RELEASE_OR_BUILD')
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Upload') {
      steps {
        container('cdt') {
            sshagent ( ['projects-storage.eclipse.org-bot-ssh']) {
              git branch: 'master', url: 'https://github.com/eclipse-cdt/cdt-infra.git'
              sh './scripts/promote-a-build.sh'
            }
        }
      }
    }
  }
}
