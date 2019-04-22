pipeline {
  agent {
    kubernetes {
      label 'cdt-upload-agent-pod'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: cdt
    image: quay.io/kummallinen/cdt-infra-eclipse-full:snapshot-ubuntu-16.04@sha256:78a5560e5556f66f31563541180f26bf0cd13da4fdea658d5f9ea074142e4391
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
    configMap: 
      name: m2-dir
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
