pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Git Clone CDT') {
      steps {
        container('cdt') {
          // We use "checkout" instead of "git" here so we can specify relativeTargetDir and other options
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'eclipse-cdt']], submoduleCfg: [], userRemoteConfigs: [[refspec: '+refs/heads/master:refs/remotes/origin/master', url: 'git://git.eclipse.org/gitroot/cdt/org.eclipse.cdt.git']]])
        }
      }
    }
    stage('Git Clone GDB') {
      steps {
        container('cdt') {
          // We use "checkout" instead of "git" here so we can specify relativeTargetDir and other options
          checkout([$class: 'GitSCM', branches: [[name: '*/gdb-8.3-branch']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'binutils-gdb']], submoduleCfg: [], userRemoteConfigs: [[refspec: '+refs/heads/gdb-8.3-branch:refs/remotes/origin/gdb-8.3-branch', url: 'https://github.com/bminor/binutils-gdb.git']]])
        }
      }
    }
    stage('Build GDB') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            sh """
                mkdir gdb-build
                cd gdb-build
                ../binutils-gdb/configure
                make -j1 V=1
                cp gdb/gdb gdb/gdb.8.3
               """
          }
        }
      }
    }
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-Xmx768m -Xms768m']) {
                sh "cd ${WORKSPACE}/eclipse-cdt && /usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -Pskip-tests-except-dsf-gdb \
                      -Dcdt.tests.dsf.gdb.versions=gdb.8.3 \
                      -Ddsf.gdb.tests.gdbPath=${WORKSPACE}/gdb-build/gdb \
                      -DskipDoc=true \
                      -Ddsf.gdb.tests.timeout.multiplier=50 \
                      -Dindexer.timeout=300 \
                      -Dmaven.repo.local=/home/jenkins/.m2/repository \
                      --settings /home/jenkins/.m2/settings.xml \
                      "
            }
          }
        }
      }
    }
  }
  post {
    always {
      container('cdt') {
        junit 'eclipse-cdt/*/*/target/surefire-reports/*.xml'
      }
    }
  }
}
