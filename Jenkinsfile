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
        sh 'cd /code && repo init --depth=1 -u https://mirrors.tuna.tsinghua.edu.cn/git/lineageOS/LineageOS/android.git -b lineage-18.1'
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
  }
}