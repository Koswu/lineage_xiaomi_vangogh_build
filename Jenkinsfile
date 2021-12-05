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
        retry(count: 3) {
          sh 'cd /code && repo sync -j 10 -c --force-sync'
        }

      }
    }

    stage('build') {
      environment {
        USE_CCACHE = '1'
      }
      steps {
        sh 'bash -c "cd /code && . build/envsetup.sh;lunch lineage_vangogh-user && mka clean && mka bacon"'
      }
    }

    stage('archive') {
      steps {
        sh 'mkdir -p /tmp/build_result && cp /code/out/target/product/*/lineage-*-UNOFFICIAL-*.zip /tmp/build_result'
        archiveArtifacts(artifacts: '/tmp/build_result/*', fingerprint: true)
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
  }
}