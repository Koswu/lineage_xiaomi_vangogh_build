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
        sh 'cp -r local_manifests /code/.repo/ && cd /code && repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1'
        sh 'cd /code && repo sync -j 10 -c --force-sync'
      }
    }

    stage('build') {
      steps {
        sh 'cd /code && . build/envsetup.sh;lunch lineage_vangogh-user && mka bacon'
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
  }
}