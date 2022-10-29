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
          checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'eclipse-cdt']], submoduleCfg: [], userRemoteConfigs: [[refspec: '+refs/heads/main:refs/remotes/origin/main', url: 'https://github.com/eclipse-cdt/cdt.git']]])
        }
      }
    }
    stage('Git Clone GDB') {
      steps {
        container('cdt') {
          // We use "checkout" instead of "git" here so we can specify relativeTargetDir and other options
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true], [$class: 'RelativeTargetDirectory', relativeTargetDir: 'binutils-gdb']], submoduleCfg: [], userRemoteConfigs: [[refspec: '+refs/heads/master:refs/remotes/origin/master', url: 'https://github.com/bminor/binutils-gdb.git']]])
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
                ${WORKSPACE}/binutils-gdb/configure --prefix=${WORKSPACE}/gdb-install
                make -j1 V=1
                make -C gdb install MAKEINFO=true
                make -C gdbserver install MAKEINFO=true
               """
          }
        }
      }
    }
    stage('Run build') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-XX:MaxRAMPercentage=60.0']) {
                sh "cd ${WORKSPACE}/eclipse-cdt && /usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -Pskip-tests-except-dsf-gdb \
                      -Dmaven.test.failure.ignore=true \
                      -Dcdt.tests.dsf.gdb.versions=gdb,gdbserver \
                      -Ddsf.gdb.tests.gdbPath=${WORKSPACE}/gdb-install/bin \
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
