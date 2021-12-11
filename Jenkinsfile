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
        lock(resource: 'lineage-source') {
          retry(count: 3) {
            sh 'cp -r local_manifests /code/.repo/ && cd /code && repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1'
            sh 'cd /code && repo sync -j 12 -c --force-sync'
          }

        }

        sh 'cp $BUILD_KEY_FILE /tmp/key.tar.gz && cd /tmp && tar xzvf key.tar.gz  '
        sh 'mkdir -p $WORKSPACE/build_result'
      }
    }

    stage('build') {
      environment {
        USE_CCACHE = '1'
      }
      steps {
        lock(resource: 'lineage-source') {
          lock(resource: 'lineage-out') {
            sh 'rm -rf /code/out/*'
            sh 'bash -c \'cd /code && . build/envsetup.sh;breakfast $BUILD_TARGET &&  mka recoveryimage\''
          }

        }

        sh 'cp /code/out/target/product/*/recovery.img $WORKSPACE/build_result/'
      }
    }

    stage('archive') {
      steps {
        archiveArtifacts(artifacts: 'build_result/*', fingerprint: true)
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
    BUILD_KEY_FILE = credentials('d25cb702-701b-40b3-9b1d-e8ec716c61f4')
    BUILD_TARGET = 'lineage_vangogh-eng'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    disableConcurrentBuilds()
  }
}