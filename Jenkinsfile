pipeline {
  agent any
  stages {
    stage('Sanity Tests') {
      steps {
        fileExists 'build.sh check-build.sh deploy.sh'
      }
    }
  }
}