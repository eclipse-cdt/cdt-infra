pipeline {
    agent {
        kubernetes {
            label 'cdt-agent-pod'
<<<<<<< HEAD
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: cdt
    image: quay.io/kummallinen/cdt-infra-eclipse-full:v0.3-ubuntu-16.04@sha256:e1670227a6a56c6be3c4062eb65983d567e435db61ed9e2ddcd599befb402bf9
    tty: true
    command: ["/bin/sh"]
    args: ["-c", "/home/cdt/.vnc/xstartup.sh && cat"]
    resources:
      requests:
        memory: "1Gi"
        cpu: "1"
      limits:
        memory: "1Gi"
        cpu: "1"
    volumeMounts:
    - name: volume-known-hosts
      mountPath: /home/jenkins/.ssh
  volumes:
  - name: volume-known-hosts
    configMap:
      name: known-hosts
            """
=======
            yamlFile 'jenkins/pod-templates/cdt-full-pod-small.yaml'
>>>>>>> Add Jenkinsfiles for npm-build jobs
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