pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod-templates/cdt-full-pod-standard.yaml'
    }
  }
  options {
    timestamps()
  }
  stages {
    stage('Git Clone') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            /* Running the git fetch command manually is a workaround. See https://bugs.eclipse.org/bugs/show_bug.cgi?id=560283#c16  */
            sh 'git config remote.origin.url https://git.eclipse.org/r/cdt/org.eclipse.cdt.git'
            /* Workaround for Bug 568904 */
            sh 'git config protocol.version 1'
            sh 'git fetch --no-tags --force --progress -- https://git.eclipse.org/r/cdt/org.eclipse.cdt.git +refs/heads/*:refs/remotes/origin/*'
          }
          checkout([$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'BuildChooserSetting', buildChooser: [$class: 'GerritTriggerBuildChooser']], [$class: 'CloneOption', honorRefspec: true, noTags: true, reference: '', shallow: true]], submoduleCfg: [], userRemoteConfigs: [[refspec: '$GERRIT_REFSPEC', url: 'https://git.eclipse.org/r/cdt/org.eclipse.cdt.git']]])
        }
      }
    }
    stage('Run build and test Terminal') {
      steps {
        container('cdt') {
          timeout(activity: true, time: 20) {
            withEnv(['MAVEN_OPTS=-XX:MaxRAMPercentage=60.0']) {
                sh "/usr/share/maven/bin/mvn \
                      clean verify -B -V \
                      -Dmaven.test.failure.ignore=true \
                      -DexcludedGroups=flakyTest,slowTest \
                      -f terminal/pom.xml \
                      -P only-terminal \
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
        junit '*/*/target/surefire-reports/*.xml,terminal/plugins/org.eclipse.tm.terminal.test/target/surefire-reports/*.xml'
        archiveArtifacts '*/*/target/surefire-reports/**,**/screenshots/*.jpeg,**/target/**/*.log,terminal/repo/target/repository/**'
      }
    }
  }
}
