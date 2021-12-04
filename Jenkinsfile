pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
      args '-v $HOME/lineage:/code -v $HOME/ccache:/cache'
    }

  }
  stages {
    stage('fetch') {
      steps {
        sh 'pwd && ls'
        sh 'ls /code && ls /code && touch /code/test'
      }
    }

  }
}