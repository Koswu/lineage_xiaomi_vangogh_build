pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
    }

  }
  stages {
    stage('fetch') {
      steps {
        sh 'pwd && ls'
      }
    }

  }
}