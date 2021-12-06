pipeline {
  agent {
    docker {
      image 'koswu/aosp-buildenv'
      args '-v $HOME/lineage:/code -v $HOME/ccache:/cache -v $HOME/'
    }

  }
  stages {
    stage('fetch') {
      parallel {
        stage('fetch source code') {
          steps {
            sh 'cp -r local_manifests /code/.repo/ && cd /code && repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-18.1'
            retry(count: 3) {
              sh 'cd /code && repo sync -j 10 -c --force-sync'
            }

          }
        }

        stage('fetch build key') {
          steps {
            sh 'echo $BUILD_KEY_FILE && cp $BUILD_KEY_FILE /tmp/key.tar.gz && cd /tmp && tar xzvf key.tar.gz  '
          }
        }

      }
    }

    stage('build') {
      environment {
        USE_CCACHE = '1'
      }
      steps {
        sh 'bash -c "cd /code && . build/envsetup.sh;lunch lineage_vangogh-user && rm -rf /code/out/*  && mka bacon"'
      }
    }

    stage('archive') {
      steps {
        sh 'mkdir -p $WORKSPACE/build_result && cp /code/out/target/product/*/lineage-*-UNOFFICIAL-*.zip $WORKSPACE/build_result/'
        sh 'ls $WORKSPACE/build_result'
        archiveArtifacts(artifacts: 'build_result/*', fingerprint: true)
      }
    }

    stage('sign') {
      steps {
        sh 'croot && sign_target_files_apks -o -d /tmp/android-certs $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip /tmp/signed-target_files.zip'
        sh '''ota_from_target_files -k /tmp/android-certs/releasekey --block --backup=true /tmp/signed-target_files.zip 
$WORKSPACE/signed-ota_update.zip'''
      }
    }

  }
  environment {
    http_proxy = 'http://192.168.0.105:3128'
    https_proxy = 'http://192.168.0.105:3128'
    BUILD_KEY_FILE = credentials('d25cb702-701b-40b3-9b1d-e8ec716c61f4')
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '3'))
    disableConcurrentBuilds()
    retry(3)
  }
}