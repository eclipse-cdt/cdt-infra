pipeline {
  agent {
    kubernetes {
      label 'promote-files-to-download-27a211f'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: cdt
    image: quay.io/eclipse-cdt/cdt-infra-eclipse-full@sha256:6a2bde05714dfe7e5ea010a8adc30070d509a83a9abf75d57387ba5173d16b90
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
  }
  options {
    timestamps()
  }
 stages {
    stage('Upload') {
      steps {
        container('cdt') {
            sshagent ( ['projects-storage.eclipse.org-bot-ssh']) {
              sh './scripts/promote-files-to-download.sh'
            }
        }
      }
    }
  }
}
