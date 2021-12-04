pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
      args '-v $HOME/lineage:/code -v $HOME/ccache:/cache'
    }

  }
  stages {
    stage('fetch') {
      parallel {
        stage('fetch') {
          steps {
            sh 'cp -r local_manifests /code/.repo/ && cd /code && repo init --depth=1 -u https://mirrors.tuna.tsinghua.edu.cn/git/lineageOS/LineageOS/android.git -b lineage-18.1'
          }
        }

        stage('') {
          steps {
            sh 'repo sync -c --force'
          }
        }

      }
    }

    stage('build') {
      steps {
        sh 'cd /code'
        sh 'source build/envsetup.sh'
        sh 'lunch lineage_vangogh-user'
        sh 'mka bacon'
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
  }
}